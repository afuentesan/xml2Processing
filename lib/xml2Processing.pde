/*** Atributos globales ***/
int sWidth = 800;
int sHeight = 600;
ArrayList grids;
boolean isLoad = false;
color bColor = color( 0 );

int x = 0;
int y = 0;

/*** Inicializa el entorno ***/
void setup() 
{
	size( sWidth, sHeight );

	smooth();
	
	grids = new ArrayList();
	
	$( jsXml2Processing.init );
}

/*** Actualiza el entorno ***/
void draw() 
{
	background( bColor );
	
	if( isLoad && grids != null && grids.size() > 0 )
	{
		for( int i = 0 ; i < grids.size() ; i++ )
		{
			grids.get( i ).trigger( "frame" );
			grids.get( i ).display();
		}
	}
}

/*** Gestion de eventos ***/
void mouseClicked()
{
	if( isLoad && grids != null && grids.size() > 0 )
	{
		for( int i = 0 ; i < grids.size() ; i++ )
		
			grids.get( i ).trigger( "click" );
	}	
}

void mouseMoved()
{
	if( isLoad && grids != null && grids.size() > 0 )
	{
		for( int i = 0 ; i < grids.size() ; i++ )
		{
			grids.get( i ).trigger( "mouseon" );
			grids.get( i ).trigger( "mouseout" );
		}
	}	
}

void mouseDragged()
{
	if( isLoad && grids != null && grids.size() > 0 )
	{
		for( int i = 0 ; i < grids.size() ; i++ )
		{
			grids.get( i ).trigger( "mousedragged" );
		}
	}
}

void mouseReleased() 
{
	if( isLoad && grids != null && grids.size() > 0 )
	{
		for( int i = 0 ; i < grids.size() ; i++ )
		{
			/*** El orden es muy importante, primero hay que desencadenar el evento mousedraggedoff y luego el mousereleased que será el que cambie el valor de la variable lockMouseDragged ***/
			grids.get( i ).trigger( "mousedraggedoff" );
			
			grids.get( i ).trigger( "mousereleased" );
		}
	}
}

void keyPressed() 
{
	if( isLoad && grids != null && grids.size() > 0 )
	{
		for( int i = 0 ; i < grids.size() ; i++ )
		{
			grids.get( i ).trigger( "keypressed" );
		}
	}	
}

/*** Funciones para recuperar grids ***/

Grid getGrid( String _id )
{
	if( grids == null || _id == null || _id.trim().equals( "" ) )
	
		return null;
		
	for( int i = 0 ; i < grids.size() ; i++ )
	{
		if( grids.get( i ).id == null || grids.get( i ).id.trim().equals( "" ) )
		
			continue;
			
		if( grids.get( i ).id == _id )
		
			return grids.get( i );	
	}
	
	return null;
}

int getIndGrid( String _id )
{
	if( grids == null || _id == null || _id.trim().equals( "" ) )
	
		return null;
		
	for( int i = 0 ; i < grids.size() ; i++ )
	{
		if( grids.get( i ).id == null || grids.get( i ).id.trim().equals( "" ) )
		
			continue;
			
		if( grids.get( i ).id == _id )
		
			return i;	
	}
	
	return null;
}

/*** Funciones para recuperar XObjects ***/

ArrayList getXObjectsByClass( String _class )
{
	if( _class == null || _class.trim().equals( "" ) )
	
		return null;
		
	ArrayList _return = new ArrayList();
	
	for( int i = 0 ; i < grids.size() ; i++ )
	{
		ArrayList _tmp = grids.get( i ).getXObjectsByClass( _class );
		
		if( _tmp == null )
		
			continue;
			
		for( int x = 0 ; x < _tmp.size() ; x++ )
		{
			_return.add( _tmp.get( x ) );
		}
	}
	
	if( _return.size() <= 0 )
	
		return null;
	
	return _return;
}

XObject getXObject( String _id )
{
	if( _id == null || _id.trim().equals( "" ) )
	
		return null;
	
	for( int i = 0 ; i < grids.size() ; i++ )
	{
		XObject _xObject = grids.get( i ).getXObject( _id );
		
		if( _xObject != null )
		
			return _xObject;
	}
	
	return null;
}

/*** Clases utiles ***/

/*** Clase Point, contiene las coordenadas x e y de un punto ***/
class Point
{
	float x;
	float y;
	float differenceX;
	float differenceY;
	
	Point()
	{
		this.x = 0;
		this.y = 0;
		this.horizontalMovement = 0;
		this.verticalMovement = 0;
	}
	
	Point( float _x, float _y )
	{
		this.x = _x;
		this.y = _y;
		this.horizontalMovement = 0;
		this.verticalMovement = 0;	
	}
	
	float getX()
	{
		return ( ( ( width * this.x ) / 100 ) + ( ( width * this.horizontalMovement ) / 100 ) );
	}
	
	float getY()
	{
		return ( ( ( height * this.y ) / 100 ) + ( ( height * this.verticalMovement ) / 100 ) );
	}
	
	float setX( float _x )
	{
		this.x = _x;
	}
	
	float setY( float _y )
	{
		this.y = _y;	
	}
	
	void setXPercent( float _x )
	{
		this.x = ( ( _x * 100 ) / width );
	}
	
	void setYPercent( float _y )
	{
		this.y = ( ( _y * 100 ) / height );	
	}
	
	float setHorizontalMovement( float _hM )
	{
		if( _hM == null )
		{
			this.horizontalMovement = 0;
			
			return;	
		}
		
		this.horizontalMovement = _hM;
	}
	
	float setVerticalMovement( float _vM )
	{
		if( _vM == null )
		{
			this.verticalMovement = 0;
			
			return;	
		}
		
		this.verticalMovement = _vM;
	}
}

/*** Clase Dimensions, contiene el ancho y alto de un objeto ***/
class Dimensions
{
	float xWidth;
	float xHeight;
	
	Dimensions()
	{
		this.xWidth = 100;
		this.xHeight = 100;	
	}
	
	Dimensions( float _xWidth, float _xHeight )
	{
		this.xWidth = _xWidth;
		this.xHeight = _xHeight;	
	}
	
	float getXWidth()
	{
		return ( ( width * this.xWidth ) / 100 );
	}
	
	float getXHeight()
	{
		return ( ( height * this.xHeight ) / 100 );
	}
	
	float setXWidth( float _xWidth )
	{
		this.xWidth = _xWidth;
	}
	
	float setXHeight( float _xHeight )
	{
		this.xHeight = _xHeight;	
	}
}

/*** Class XImage, encapsula la funcionalidad de las imagenes ***/
class XImage
{
	PImage xImage;
	
	XImage( String _url )
	{
		 xImage = loadImage( _url );
	}
	
	PImage getXImage()
	{
		return xImage;	
	}
	
	void display( float _x, float _y, float _width, float _height )
	{
		if( this.xImage == null )
		
			return;
		
		if( this.xImage.width != _width || this.xImage.height != _height )
		
			this.xImage.resize( _width, _height );
		
		noFill();
		noStroke();
		image( this.xImage, _x, _y );
	}
	
	void display( Sprite _sprite )
	{
		if( this.xImage == null )
		
			return;
			
		PImage _img = _sprite.getCroppedImage();
		
		if( _img == null )
		
			return;
		
		_img.resize( _sprite.dimensions.getXWidth(), _sprite.dimensions.getXHeight() );
		
		noFill();
		noStroke();
		
		image( _img, _sprite.initialPoint.getX(), _sprite.initialPoint.getY() );
	}
	
	PImage getCroppedImage( Dimensions _srcDimensions, Point _srcCoordinate )
	{
		if( this.xImage == null || this.xImage.width <= 0 || this.xImage.height <= 0 )
		
			return null;
		
		float _width = floor( ( _srcDimensions.xWidth * this.xImage.width ) / 100 );
		float _height = floor( ( _srcDimensions.xHeight * this.xImage.height ) / 100 );
		
		float _x = floor( ( _srcCoordinate.x * this.xImage.width ) / 100 );
		float _y = floor( ( _srcCoordinate.y * this.xImage.height ) / 100 );
		
		PImage _new = createImage( _width, _height, ARGB );
		
		_new.blend( this.xImage, _x, _y, _width, _height, 0, 0, _width, _height, SCREEN );
		
		return _new;
	}
}

/*** Class Gradient, encapsula la funcionalidad de un degradado ***/
class Gradient
{
	int Y_AXIS = 1;

	int X_AXIS = 2;
	
	int LINEAR = 1;
	
	int RADIAL = 2;

	XObject container;
	
	color bColor;
	ArrayList gColor;
	
	int axis;
	int type;
	
	Gradient( XObject _container, color _bColor, ArrayList _gColor, int _axis, int _type )
	{
		this.container = _container;
		
		this.bColor = _bColor;
		this.gColor = _gColor;
		this.axis = _axis;
		this.type = _type;
	}
	
	void display()
	{
		if( this.type == null )
		
			this.type = this.LINEAR;
			
		float _x = this.container.initialPoint.getX();
		float _y = this.container.initialPoint.getY();
		
		float _width = this.container.dimensions.getXWidth();
		float _height = this.container.dimensions.getXHeight();

		var _ctx = $( "#" + configXml2Processing.id )[ 0 ].getContext( "2d" );
		
		var _grd = null;
		
		if( this.type == this.LINEAR )
		{
			if( this.container instanceof Triangle )
			{
				_grd = _ctx.createLinearGradient( this.container.getLeftPoint().getX(), this.container.getCenter().getY(), this.container.getRightPoint().getX(), this.container.getCenter().getY() );
				
				if( this.axis == this.Y_AXIS )
			
					_grd = _ctx.createLinearGradient( this.container.getCenter().getX(), this.container.getTopPoint().getY(), this.container.getCenter().getX(), this.container.getBottomPoint().getY() );
			}
			else if( this.container instanceof Ellipse )
			{
				_grd = _ctx.createLinearGradient( ( _x - ( _width / 2 ) ), _y, ( _x + ( _width / 2 ) ), _y );
			
				if( this.axis == this.Y_AXIS )
			
					_grd = _ctx.createLinearGradient( _x, ( _y - ( _height / 2 ) ), _x, ( _y + ( _height / 2 ) ) );
			}
			else
			{
				_grd = _ctx.createLinearGradient( _x, _y, ( _x + _width ), _y );
			
				if( this.axis == this.Y_AXIS )
			
					_grd = _ctx.createLinearGradient( _x, _y, _x, ( _y + _height ) );
			}
		}
		else
		{
			if( this.container instanceof Triangle )
			{
				int _diffTopBottom =  abs( ( this.container.getTopPoint().getY() - this.container.getBottomPoint().getY() ) ); 
				int _diffLeftRight = abs( ( this.container.getRightPoint().getX() - this.container.getLeftPoint().getX() ) ); 
				
				int _xC1 = this.container.getCenter().getX();
				int _yC1 = this.container.getCenter().getY();
					
				int _rC1 = ( _diffTopBottom / 10 );
				
				if( _diffTopBottom > _diffLeftRight )
				
					_rC1 = ( _diffLeftRight / 10 );
					
				int _rC2 = ( _diffLeftRight / 2 );
				
				if( _height > _diffLeftRight )
				
					_rC2 = ( _diffTopBottom / 2 );
					
				_grd = _ctx.createRadialGradient( _xC1, _yC1, _rC1, _xC1, _yC1, _rC2 );
			}
			else if( this.container instanceof Ellipse )
			{
				int _xC1 = _x;
				int _yC1 = _y;
				int _rC1 = ( _height / 10 );
				
				if( _height > _width )
				
					_rC1 = ( _width / 10 );
					
				int _rC2 = ( _width / 2 );
				
				if( _height > _width )
				
					_rC2 = ( _height / 2 );
					
				_grd = _ctx.createRadialGradient( _xC1, _yC1, _rC1, _xC1, _yC1, _rC2 );
			}
			else
			{
				int _xC1 = ( _width / 2 ) + _x;
				int _yC1 = ( _height / 2 ) + _y;
				int _rC1 = ( _height / 10 );
				
				if( _height > _width )
				
					_rC1 = ( _width / 10 );
				
				int _rC2 = ( _width / 2 );
				
				if( _height > _width )
				
					_rC2 = ( _height / 2 );
	
				_grd = _ctx.createRadialGradient( _xC1, _yC1, _rC1, _xC1, _yC1, _rC2 );
			}
		}
		
		_grd.addColorStop( 0, "rgba("+ red( this.bColor )+","+ green( this.bColor )+","+ blue( this.bColor )+","+ alpha( this.bColor ) +" )" );
		
		float _stopSize = ( 1 / ( this.gColor.size() ) );
		
		float _currentStop = _stopSize; 
		
		for( int i = 1 ; i <= this.gColor.size() ; i++ )
		{
			color _color2 = this.gColor.get( ( i - 1 ) );
			
			_grd.addColorStop( _currentStop, "rgba("+ red( _color2 )+","+ green( _color2 )+","+ blue( _color2 )+","+ alpha( _color2 ) +" )" );
			
			_currentStop += _stopSize;
			
			if( ( _currentStop > 1 ) || ( this.gColor.size() == ( i + 1 ) ) )
			
				_currentStop = 1;
		}
		
		
		
		if( this.container instanceof Panel && ! ( this.container instanceof Ellipse ) )
		{
			Panel _p = ( Panel )this.container;
			
			if( _p.weight != null && _p.weight > 0 && _p.fColor != null && _p.radius != null )
			{
				var _rad = ( height * _p.radius ) / 100;
				
				_ctx.beginPath();
				
				_ctx.fillStyle = _grd;
				
				_ctx.moveTo( _x + _rad, _y );
  				
  				_ctx.lineTo( _x + _width - _rad, _y );
  				
  				_ctx.quadraticCurveTo( _x + _width, _y, _x + _width, _y + _rad );
  				
  				_ctx.lineTo( _x + _width, _y + _height - _rad );
  
				_ctx.quadraticCurveTo( _x + _width, _y + _height, _x + _width - _rad, _y + _height );
  
  				_ctx.lineTo( _x + _rad, _y + _height );

				_ctx.quadraticCurveTo( _x, _y + _height, _x, _y + _height- _rad );
				
  				_ctx.lineTo( _x, _y + _rad );
  
  				_ctx.quadraticCurveTo( _x, _y, _x + _rad, _y );
  
  				_ctx.fill();
  				
  				/*_ctx.strokeStyle = "black";
  				_ctx.stroke();*/
  				
  				_ctx.closePath();
			}
			else
			{
				_ctx.fillStyle = _grd;
				
				_ctx.fillRect( _x, _y, _width, _height );
			}
		}
		else if( this.container instanceof Ellipse )
		{
			_x = _x - _width / 2.0;
			_y = _y - _height / 2.0;
			
			var _w = _width;
			var _h = _height;
			
			var _kappa = 0.5522848;
	      	var _ox = ( _w / 2 ) * _kappa;
	      	var _oy = ( _h / 2 ) * _kappa;
	      	var _xe = _x + _w;
			var _ye = _y + _h;
			var _xm = _x + _w / 2;
			var _ym = _y + _h / 2;
	
			_ctx.beginPath();
				
				_ctx.fillStyle = _grd;
				
				_ctx.moveTo( _x, _ym );
				_ctx.bezierCurveTo( _x, _ym - _oy, _xm - _ox, _y, _xm, _y );
				_ctx.bezierCurveTo( _xm + _ox, _y, _xe, _ym - _oy, _xe, _ym );
				_ctx.bezierCurveTo( _xe, _ym + _oy, _xm + _ox, _ye, _xm, _ye );
				_ctx.bezierCurveTo( _xm - _ox, _ye, _x, _ym + _oy, _x, _ym );
				
				_ctx.fill();
			
			_ctx.closePath();
		}
		else if( this.container instanceof Triangle )
		{
			_ctx.beginPath();
			
				_ctx.fillStyle = _grd;
				
				_ctx.moveTo( _x, _y );

				_ctx.lineTo( this.container.point2.getX(), this.container.point2.getY() );

				_ctx.lineTo( this.container.point3.getX(), this.container.point3.getY() );
				
				_ctx.fill();

			_ctx.closePath();
		}
		else
		{
			_ctx.fillStyle = _grd;
			
			_ctx.fillRect( _x, _y, _width, _height );
		}
	}
}

/*** Clases padre ***/

/*** Clase XObject, contiene las propiedades y funcionalidades comunes a todos los objetos de la aplicacion ***/
class XObject
{
	/*** Eventos ***/
	ArrayList click;
	ArrayList mouseon;
	ArrayList mouseout;
	ArrayList mousedragged;
	ArrayList mousedraggedoff;
	ArrayList mousereleased;
	ArrayList keypressed;
	ArrayList frame;
	ArrayList load;
	ArrayList ehide;
	ArrayList eshow;
	/*** Fin eventos ***/
	
	color fColor;
	color bColor;
	
	Gradient gradient;
	
	boolean lockMouseOn;
	boolean lockMouseDragged;
	
	Dimensions dimensions;
	
	String id;
	String className;
	Point initialPoint;
	
	float stepX;
	float stepY;
	
	boolean visible;
	boolean xFocus;
	
	HashMap stateVariables;
	
	XImage xImage;
	
	XObject( String _id, String _className, float _x, float _y, float _xWidth, float _xHeight, color _fColor, color _bColor, ArrayList _gColor, int _axis, int _gType, String _urlXImage, boolean _visible, boolean _focus )
	{
		this.id = _id;
		this.className = _className;
		
		/*** Inicializamos los arraylist de los eventos ***/
		this.click = new ArrayList();
		this.mouseon = new ArrayList();
		this.mouseout = new ArrayList();
		this.mousedragged = new ArrayList();
		this.mousedraggedoff = new ArrayList();
		this.mousereleased = new ArrayList();
		this.keypressed = new ArrayList();
		this.frame = new ArrayList();
		this.load = new ArrayList();
		this.ehide = new ArrayList();
		this.eshow = new ArrayList();
		
		this.initialPoint = new Point( _x, _y );
		
		this.dimensions = new Dimensions( _xWidth, _xHeight );
		
		this.fColor = _fColor;
		this.bColor = _bColor;
		
		this.stepX = 0;
		this.stepY = 0;
		
		this.visible = true;
		
		if( _visible != null )
		
			this.visible = _visible;
			
		this.xFocus = false;
		
		if( _focus != null )
		
			this.xFocus = _focus;
		
		if( _urlXImage != null )
		
			this.xImage = new XImage( _urlXImage );
		
		this.stateVariables = new HashMap();
		
		if( _gColor != null && _bColor != null )
		{
			this.gradient = new Gradient( this, _bColor, _gColor, _axis, _gType );
		}
	}
	
	void setPoint( float x, float y )
	{
		this.initialPoint.setX( x );
		this.initialPoint.setY( y );	
	}
	
	void display()
	{
		if( this.stepX != 0)
		{
			this.initialPoint.setHorizontalMovement( this.initialPoint.horizontalMovement + this.stepX );
		}
		
		if( this.stepY != 0)
		{
			this.initialPoint.setVerticalMovement( this.initialPoint.verticalMovement + this.stepY );
		}
		
		if( ! this.isHide() )
		{
			if( this.xImage != null )
			{
				if( this instanceof Sprite )
				{
					Sprite _s = ( Sprite )this;
					
					this.xImage.display( _s );		
				}
				else
				{
					this.xImage.display( this.initialPoint.getX(), this.initialPoint.getY(), this.dimensions.getXWidth(), this.dimensions.getXHeight() );
				}
			}	
		}
	}
	
	void move( float _stepX, float _stepY )
	{
		this.stepX = _stepX;
		this.stepY = _stepY;
		
		if( this.stepX == null )
		
			this.stepX = 0;
			
		if( this.stepY == null )
		
			this.stepY = 0;	
	}
	
	void stop()
	{
		this.stopX();
		this.stopY();
	}
	
	void stopX()
	{
		this.stepX = 0;
	}
	
	void stopY()
	{
		this.stepY = 0;
	}
	
	void show()
	{
		if( ! this.isHide() )
		
			return;
			
		this.visible = true;
		
		this.trigger( "show" );	
	}
	
	void hide()
	{
		if( this.isHide() )
		
			return;
			
		this.visible = false;
		
		this.trigger( "hide" );
	}
	
	boolean isHide()
	{
		return ( ! this.visible );	
	}
	
	void focus()
	{
		this.xFocus = true;	
	}
	
	void blur()
	{
		this.xFocus = false;	
	}
	
	void isFocus()
	{
		return this.xFocus;	
	}
	
	void onClick( String _func )
	{
		this.addEvent( _func, "click" );
	}
	
	void onMouseOn( String _func )
	{
		this.addEvent( _func, "mouseon" );
	}
	
	void onMouseOut( String _func )
	{
		this.addEvent( _func, "mouseout" );
	}
	
	void onMouseDragged( String _func )
	{
		this.addEvent( _func, "mousedragged" );
	}
	
	void onMouseDraggedOff( String _func )
	{
		this.addEvent( _func, "mousedraggedoff" );
	}
	
	void onMouseReleased( String _func )
	{
		this.addEvent( _func, "mousereleased" );
	}
	
	void onKeyPressed( String _func )
	{
		this.addEvent( _func, "keypressed" );
	}
	
	void onFrame( String _func )
	{
		this.addEvent( _func, "frame" );
	}
	
	void onLoad( String _func )
	{
		this.addEvent( _func, "load" );
	}
	
	void onHide( String _func )
	{
		this.addEvent( _func, "hide" );
	}
	
	void onShow( String _func )
	{
		this.addEvent( _func, "show" );
	}
	
	void attachEvents( HashMap _events )
	{
		if( _events == null )
		
			return;
			
		String _click = _events[ "click" ];
		String _mouseon = _events[ "mouseon" ];
		String _mouseout = _events[ "mouseout" ];
		String _mousedragged = _events[ "mousedragged" ];
		String _mousedraggedoff = _events[ "mousedraggedoff" ];
		String _mousereleased = _events[ "mousereleased" ];
		String _keypressed = _events[ "keypressed" ];
		String _frame = _events[ "frame" ];
		String _load = _events[ "load" ];
		String _hide = _events[ "hide" ];
		String _show = _events[ "show" ];
		
		this.onClick( _click );
		this.onMouseOn( _mouseon );
		this.onMouseOut( _mouseout );
		this.onMouseDragged( _mousedragged );
		this.onMouseDraggedOff( _mousedraggedoff );
		this.onMouseReleased( _mousereleased );
		this.onKeyPressed( _keypressed );
		this.onFrame( _frame );
		this.onLoad( _load );
		this.onHide( _hide );
		this.onShow( _show );
	}
	
	void clearEvents()
	{
		/*** Inicializamos los arraylist de los eventos ***/
		this.click = new ArrayList();
		this.mouseon = new ArrayList();
		this.mouseout = new ArrayList();
		this.mousedragged = new ArrayList();
		this.mousedraggedoff = new ArrayList();
		this.mousereleased = new ArrayList();
		this.keypressed = new ArrayList();
		this.frame = new ArrayList();
		this.load = new ArrayList();
		this.ehide = new ArrayList();
		this.eshow = new ArrayList();	
	}
	
	void addEvent( String _func, String _type )
	{
		if( _func == null || _func.trim().equals( "" ) )
		
			return;
		
		try
		{
			var _str = "var _f = " + _func;
			
			eval( _str );
			
			if( typeof( _f ) != "function" )
			
				return;
			
			if( _type == "click" )
				
				this.click.add( _func );
				
			else if( _type == "mouseon" )
			
				this.mouseon.add( _func );
				
			else if( _type == "mouseout" )
			
				this.mouseout.add( _func );
				
			else if( _type == "mousedragged" )
			
				this.mousedragged.add( _func );
				
			else if( _type == "mousedraggedoff" )
			
				this.mousedraggedoff.add( _func );
				
			else if( _type == "mousereleased" )
			
				this.mousereleased.add( _func );
				
			else if( _type == "keypressed" )
			
				this.keypressed.add( _func );
				
			else if( _type == "frame" )
			
				this.frame.add( _func );
				
			else if( _type == "load" )
			
				this.load.add( _func );
				
			else if( _type == "hide" )
			
				this.ehide.add( _func );
				
			else if( _type == "show" )
			
				this.eshow.add( _func );	
		}
		catch( _ex )
		{
			
		}
	}
	
	color getFColor()
	{
		return this.fColor;	
	}
	
	color getBColor()
	{
		return this.bColor;	
	}
	
	void setFColor( color _color )
	{
		this.fColor = _color;
	}
	
	void setBColor( color _color )
	{
		this.bColor = _color;
	}
	
	void setGradient( Gradient _grad )
	{
		this.gradient = _grad;
		
		this.bColor = _grad.bColor;
	}
	
	void trigger( String _type )
	{
		if( ( ( _type != "frame" && _type != "hide" && _type != "show" && _type != "load" ) && this.isHide() ) || ! this.isMouseOn( _type ) )
		
			return;
		
		String _strFunc = "";
		
		var _strEval = "";
			
		if( _type == "click" )
		{
			for( int i = 0 ; i < this.click.size() ; i++ )
			
				_strEval += this.click.get( i ) + "(this);";
		}
		else if( _type == "mouseon" )
		{
			for( int i = 0 ; i < this.mouseon.size() ; i++ )
			
				_strEval += this.mouseon.get( i ) + "(this);";
		}
		else if( _type == "mouseout" )
		{
			for( int i = 0 ; i < this.mouseout.size() ; i++ )
			
				_strEval += this.mouseout.get( i ) + "(this);";
		}
		else if( _type == "mousedragged" )
		{
			for( int i = 0 ; i < this.mousedragged.size() ; i++ )
			
				_strEval += this.mousedragged.get( i ) + "(this);";
		}
		else if( _type == "mousedraggedoff" )
		{
			for( int i = 0 ; i < this.mousedraggedoff.size() ; i++ )
			
				_strEval += this.mousedraggedoff.get( i ) + "(this);";
		}
		else if( _type == "mousereleased" )
		{
			for( int i = 0 ; i < this.mousereleased.size() ; i++ )
			
				_strEval += this.mousereleased.get( i ) + "(this);";
		}
		else if( _type == "keypressed" )
		{
			for( int i = 0 ; i < this.keypressed.size() ; i++ )
			
				_strEval += this.keypressed.get( i ) + "(this);";
		}
		else if( _type == "frame" )
		{
			for( int i = 0 ; i < this.frame.size() ; i++ )
			
				_strEval += this.frame.get( i ) + "(this);";
		}
		else if( _type == "load" )
		{
			for( int i = 0 ; i < this.load.size() ; i++ )
			
				_strEval += this.load.get( i ) + "(this);";
		}
		else if( _type == "hide" )
		{
			for( int i = 0 ; i < this.ehide.size() ; i++ )
			
				_strEval += this.ehide.get( i ) + "(this);";
		}
		else if( _type == "show" )
		{
			for( int i = 0 ; i < this.eshow.size() ; i++ )
			
				_strEval += this.eshow.get( i ) + "(this);";
		}
		
		
		if( _strEval != null && ! _strEval.trim().equals( "" ) )
		{
			try
			{
				eval( _strEval );
			}
			catch( _ex )
			{
				console.log( _ex );
			}	
		}
	}
	
	boolean isMouseOn( _type )
	{
		if( _type == "frame" || _type == "load" || _type == "show" || _type == "hide" )
		
			return true;
			
		if( this.isHide() )
		
			return false;
			
		if( _type == "keypressed" )
		{
			if( this.xFocus )
			
				return true;
				
			return false;
		}
			
		float _x = this.initialPoint.getX();
		float _y = this.initialPoint.getY();
		
		float _width = this.dimensions.getXWidth();
		float _height = this.dimensions.getXHeight();
		
		if( _type == "mousedraggedoff" )
		{
			if( this.lockMouseDragged )
			
				return true;
				
			return false;
		}
		
		if( _type == "mousereleased" )
		{
			this.lockMouseDragged = false;
		}
		
		boolean _isOverLine = false;
		boolean _isOverEllipse = false;
		boolean _isOverTriangle = false;
		
		if( this instanceof Line )
		
			_isOverLine = ( ( Line )this ).mouseIsOverLine();
			
		else if( this instanceof Ellipse )
		
			_isOverEllipse = ( ( Ellipse )this ).mouseIsOverEllipse();
			
		else if( this instanceof Triangle )
		
			_isOverTriangle = ( ( Triangle )this ).mouseIsOverTriangle();
		
		if( ( ( mouseX > _x && ( mouseX < ( _x + _width ) ) && mouseY > _y && ( mouseY < ( _y + _height ) ) ) && ! ( this instanceof Line ) && ! ( this instanceof Ellipse ) && ! ( this instanceof Triangle ) ) || _isOverLine || _isOverEllipse || _isOverTriangle )
		{
			if( _type == "click" || _type == "mousereleased" )
			{
				if( _type == "click" )
					
					this.focus = true;
					 
				return true;
			}
				
			if( _type == "mouseon" )
			{
				if( ! this.lockMouseOn )
				{
					this.lockMouseOn = true;
					
					return true;	
				}
			}
			
			if( _type == "mousedragged" )
			{
				if( ! this.lockMouseDragged )
				{
					this.lockMouseDragged = true;
					
					return false;
				}
				else
				{
					return true;
				}
			}
		}
		else
		{
			if( _type == "click" )
					
				this.focus = false;
					
			if( _type == "mouseout" )
			{
				if( this.lockMouseOn )
				{
					this.lockMouseOn = false;
					
					return true;	
				}
				
				this.lockMouseOn = false;
			}
			
			if( _type == "mousedragged" )
			{
				if( this.lockMouseDragged )
				
					return true;
			}
		}
		
		return false;
	}
	
	Grid getGrid()
	{
		if( this instanceof Grid )
		{
			Grid _g = ( Grid )this;
			
			return _g;	
		}
		
		for( int i = 0 ; i < grids.size() ; i++ )
		{
			XObject _obj = grids.get( i ).getXObject( this.id );
			
			if( _obj != null )
			{
				return grids.get( i );	
			} 
		}
		
		return null;
	}
}

/*** Clase Grid, el lugar donde se van a pintar todos los objetos ***/
class Grid extends XObject
{
	ArrayList xObjects;
	
	Grid( String _id, String _className, color _bColor, ArrayList _gColor, int _axis, int _gType, String _urlXImage, boolean _visible )
	{
		super( _id, _className, 0, 0, 100, 100, null, _bColor, _gColor, _axis, _gType, _urlXImage, _visible, null );
		
		this.xObjects = new ArrayList();
	}
	
	void putXObject( XObject _obj )
	{
		this.xObjects.add( _obj );
	}
	
	XObject getXObject( String _id )
	{
		for( int i = 0 ; i < this.xObjects.size() ; i++ ) 
		{
			XObject _xObject = ( XObject )this.xObjects.get( i );
			
			if( _xObject.id == _id )
			
				return _xObject;
		}
		
		return null;	
	}
	
	void removeXObject( String _id )
	{
		for( int i = 0 ; i < this.xObjects.size() ; i++ ) 
		{
			XObject _xObject = ( XObject )this.xObjects.get( i );
			
			if( _xObject.id == _id )
			{
				this.xObjects.remove( i );
			}
		}
	}
	
	void removeXObjectsByClass( String _className )
	{
		for( int i = 0 ; i < this.xObjects.size() ; i++ ) 
		{
			XObject _xObject = ( XObject )this.xObjects.get( i );
			
			if( _xObject.className == _className )
			{
				this.xObjects.remove( i );
				
				this.removeXObjectsByClass( _className );
			}
		}
	}
	
	ArrayList getXObjectsByClass( String _className )
	{
		ArrayList _return = new ArrayList();
		
		for( int i = 0 ; i < this.xObjects.size() ; i++ ) 
		{
			XObject _xObject = ( XObject )this.xObjects.get( i );
			
			if( _xObject.className == _className )
			{
				_return.add( _xObject );
			}
		}
		
		if( _return.size() <= 0 )
		
			return null;
			
		return _return;		
	}
	
	void trigger( String _type )
	{
		if( this.xObjects.size() <= 0 || ( this.isHide() && _type != "frame" ) )
		{
			super.trigger( _type );
			
			return;
		}
		
		for( int i = 0 ; i < this.xObjects.size() ; i++ ) 
		{
			( ( XObject )this.xObjects.get( i ) ).trigger( _type );
		}
		
		super.trigger( _type );
	}
	
	void display()
	{
		if( this.isHide() )
		{
			super.display();
			
			return;
		}
		
		super.display();
		
		if( this.gradient != null )
		{
			noFill();
			
			this.gradient.display();
		}
		else
		{
			if( this.bColor != null )
			{
				fill( this.bColor );
				
				rect( this.initialPoint.getX(), this.initialPoint.getY(), this.dimensions.getXWidth(), this.dimensions.getXHeight() );
			}
			else
			
				noFill();
		}
		
		if( this.xObjects != null && this.xObjects.size() > 0 )
		{
			for( int i = 0 ; i < this.xObjects.size() ; i++ ) 
			{
				XObject _xObject = ( XObject )this.xObjects.get( i );
				
				_xObject.display();	
			}
		}
	}
}

/*** Clase Text, nos permitira pintar un texto en pantalla ***/
class Text extends XObject
{
	String xText;
	PFont font;
	float hAlign;
	float vAlign;
	float xSize;
	
	Text( String _text, String _type, float _size, float _hAlign, float _vAlign, String _id, String _className, float _x, float _y, float _xWidth, float _xHeight, color _fColor, String _urlXImage, boolean _visible, boolean _focus )
	{
		super( _id, _className, _x, _y, _xWidth, _xHeight, _fColor, null, null, null, null, _urlXImage, _visible, _focus );
		
		this.xText = _text;
		
		this.hAlign = _hAlign;
		
		this.vAlign = _vAlign;
		
		this.xSize = _size;
		
		this.font = loadFont( _type );
	}
	
	void display()
	{
		super.display();
		
		if( this.isHide() )
		
			return;

		float _size = ( height * this.xSize ) / 100;
		
		textFont( this.font, _size );
		
		textAlign( this.hAlign, this.vAlign );
		
		fill( this.fColor );
		
		text( this.xText, this.initialPoint.getX(), this.initialPoint.getY(), this.dimensions.getXWidth(), this.dimensions.getXHeight() );
	}
}

/*** Clase Line, permite pintar una línea en pantalla ***/
class Line extends XObject
{
	float weight;
	
	Line( float _weight, String _id, String _className, float _x, float _y, float _xWidth, float _xHeight, color _fColor, String _urlXImage, boolean _visible, boolean _focus )
	{
		super( _id, _className, _x, _y, _xWidth, _xHeight, _fColor, null, null, null, null, _urlXImage, _visible, _focus );
		
		this.weight = _weight;
	}
	
	void display()
	{
		super.display();
		
		if( this.isHide() )
		
			return;
		
		float _weight = ( height * this.weight ) / 100;
		
		stroke( this.fColor );
		
		strokeWeight( _weight );
		
		float _x = this.initialPoint.getX();
		float _y = this.initialPoint.getY();
		float _fX = this.initialPoint.getX() + this.dimensions.getXWidth();
		float _fY = this.initialPoint.getY() + this.dimensions.getXHeight();
		
		line( _x, _y, _fX, _fY );
	}
	
	boolean mouseIsOverLine() 
	{
		float _weight = ( height * this.weight ) / 100;
		
		float _x = this.initialPoint.getX();
		float _y = this.initialPoint.getY();
		float _fX = this.initialPoint.getX() + this.dimensions.getXWidth();
		float _fY = this.initialPoint.getY() + this.dimensions.getXHeight();
		
		float _d = dist( _x, _y, _fX, _fY );
		
		float _d1 = dist( _x, _y, mouseX, mouseY );
		
		float _d2 = dist( _fX, _fY, mouseX, mouseY );

		// distance between vertices must be similar to sum of distances from each vertex to mouse
		if( _d1 + _d2 < _d + ( _weight / 20 ) )
		
			return true;
		
		return false;
	}
}

/*** Clase Panel, pintará un panel ***/
class Panel extends XObject
{
	float weight;
	float radius;
	float tlradius;
	float trradius;
	float blradius;
	float brradius;
	
	Panel( float _weight, String _id, String _className, float _x, float _y, float _xWidth, float _xHeight, color _fColor, color _bColor, ArrayList _gColor, int _axis, int _gType, String _urlXImage, boolean _visible, boolean _focus, float _radius, float _tlradius, float _trradius, float _blradius, float _brradius )
	{
		super( _id, _className, _x, _y, _xWidth, _xHeight, _fColor, _bColor, _gColor, _axis, _gType, _urlXImage, _visible, _focus );
		
		this.weight = _weight;
		this.radius = _radius;
		this.tlradius = _tlradius;
		this.trradius = _trradius;
		this.blradius = _blradius;
		this.brradius = _brradius;
	}
	
	void display()
	{
		super.display();
		
		if( this.isHide() )
		
			return;

		if( this.gradient != null )
		{
			noFill();
			
			this.gradient.display();
		}
		else
		{
			if( this.bColor != null )
			
				fill( this.bColor );
			
			else
			
				noFill();
		}
		
		if( this.weight != null && this.weight > 0 && this.fColor != null )
		{
			float _weight = ( height * this.weight ) / 100;
			
			stroke( this.fColor );
	
			strokeWeight( _weight );
		}
		else
		{
			noStroke();	
		}
		
		if( this instanceof Ellipse )
		{
			Ellipse _e = ( Ellipse )this;
			
			ellipse( _e.initialPoint.getX(), _e.initialPoint.getY(), _e.dimensions.getXWidth(), _e.dimensions.getXHeight() );
		}
		else if( this.radius != null )
		{
			float _radius = ( height * this.radius ) / 100;
			
			rect( this.initialPoint.getX(), this.initialPoint.getY(), this.dimensions.getXWidth(), this.dimensions.getXHeight(), _radius );
		}
		else
		{
			float _tlradius = 0;
			float _trradius = 0;
			float _blradius = 0;
			float _brradius = 0;
			
			if( this.tlradius != null )
			
				_tlradius = ( height * this.tlradius ) / 100;
				
			if( this.trradius != null )
			
				_trradius = ( height * this.trradius ) / 100;
				
			if( this.blradius != null )
			
				_blradius = ( height * this.blradius ) / 100;
			
			if( this.brradius != null )
			
				_brradius = ( height * this.brradius ) / 100;
			
			rect( this.initialPoint.getX(), this.initialPoint.getY(), this.dimensions.getXWidth(), this.dimensions.getXHeight(), _tlradius, _trradius, _brradius, _blradius );
		}
	}
}

/*** Clase Ellipse, pinta una elipse, si el alto y el ancho son iguales pinta un circulo ***/
class Ellipse extends Panel
{
	Ellipse( float _weight, String _id, String _className, float _x, float _y, float _xWidth, float _xHeight, color _fColor, color _bColor, color _gColor, int _axis, int _type, String _urlXImage, boolean _visible, boolean _focus )
	{
		super( _weight, _id, _className, _x, _y, _xWidth, _xHeight, _fColor, _bColor, _gColor, _axis, _type, _urlXImage, _visible, _focus, null, null, null, null, null );
	}
	
	void display()
	{
		super.display();
	}
	
	boolean mouseIsOverEllipse() 
	{
		int _a = ( this.dimensions.getXWidth() / 2 );
		int _b = ( this.dimensions.getXHeight() / 2 );
		
		int _xRel = ( mouseX + ( -1 * this.initialPoint.getX() ) );
		int _yRel = ( mouseY + ( -1 * this.initialPoint.getY() ) );
		
		int _result = ( ( ( _xRel * _xRel ) / ( _a * _a ) ) + ( ( _yRel * _yRel ) / ( _b * _b ) ) );

		if( _result <= 1 )
		
			return true;
			
		return false;
	}
}

class Triangle extends XObject
{
	Point center;
	Point point2;
	Point point3;
	
	float weight;
	
	Triangle( float _xp2, float _yp2, float _xp3, float _yp3 ,float _weight, String _id, String _className, float _x, float _y, color _fColor, color _bColor, color _gColor, int _axis, int _type, boolean _visible, boolean _focus )
	{
		super( _id, _className, _x, _y, 0, 0, _fColor, _bColor, _gColor, _axis, _type, null, _visible, _focus );
		
		this.point2 = new Point( _xp2, _yp2 );
		this.point3 = new Point( _xp3, _yp3 );
		
		this.weight = _weight;
	}
	
	void display()
	{
		super.display();
		
		if( this.isHide() )
		
			return;

		if( this.gradient != null )
		{
			noFill();
			
			this.gradient.display();
		}
		else
		{
			if( this.bColor != null )
			
				fill( this.bColor );
			
			else
			
				noFill();
		}
		
		if( this.weight != null && this.weight > 0 && this.fColor != null )
		{
			float _weight = ( height * this.weight ) / 100;
			
			stroke( this.fColor );
	
			strokeWeight( _weight );
		}
		else
		{
			noStroke();	
		}
			
		triangle( this.initialPoint.getX(), this.initialPoint.getY(), this.point2.getX(), this.point2.getY(), this.point3.getX(), this.point3.getY() );
	}
	
	boolean mouseIsOverTriangle( String _type ) 
	{
		//A1A2A3
		int _dir1 = ( this.initialPoint.getX() - this.point3.getX() ) * ( this.point2.getY() - this.point3.getY() ) - ( this.initialPoint.getY() - this.point3.getY() ) * ( this.point2.getX() - this.point3.getX() );
		
		//A1A2P
		int _dir2 = ( this.initialPoint.getX() - mouseX ) * ( this.point2.getY() - mouseY ) - ( this.initialPoint.getY() - mouseY ) * ( this.point2.getX() - mouseX );
		
		//A2A3P
		int _dir3 = ( this.point2.getX() - mouseX ) * ( this.point3.getY() - mouseY ) - ( this.point2.getY() - mouseY ) * ( this.point3.getX() - mouseX );
		
		//A3A1P
		int _dir4 = ( this.point3.getX() - mouseX ) * ( this.initialPoint.getY() - mouseY ) - ( this.point3.getY() - mouseY ) * ( this.initialPoint.getX() - mouseX );
		
		if( _dir1 >= 0 && _dir2 >= 0 && _dir3 >= 0 && _dir4 >= 0 )
		
			return true;
		
		if( _dir1 < 0 && _dir2 < 0 && _dir3 < 0 && _dir4 < 0 )
		
			return true;
			
		return false;
	}
	
	Point getCenter()
	{
		if( this.center != null )
		
			return this.center;
			
		float _x = ( ( this.initialPoint.getX() + this.point2.getX() + this.point3.getX() ) / 3 );
		float _y = ( ( this.initialPoint.getY() + this.point2.getY() + this.point3.getY() ) / 3 );
		
		_x = ( ( _x * 100 ) / width );
		_y = ( ( _y * 100 ) / height );
		
		this.center = new Point( _x, _y );
		
		return this.center;
	}
	
	Point getTopPoint()
	{
		if( ( this.initialPoint.getY() <= this.point2.getY() ) && ( this.initialPoint.getY() <= this.point3.getY() ) )
		{
			return this.initialPoint;
		}	
		if( ( this.point2.getY() <= this.initialPoint.getY() ) && ( this.point2.getY() <= this.point3.getY() ) )
		{
			return this.point2;
		}
		return this.point3;
	}
	
	Point getBottomPoint()
	{
		if( ( this.initialPoint.getY() >= this.point2.getY() ) && ( this.initialPoint.getY() >= this.point3.getY() ) )
		
			return this.initialPoint;
			
		if( ( this.point2.getY() >= this.initialPoint.getY() ) && ( this.point2.getY() >= this.point3.getY() ) )
		
			return this.point2;
	
		return this.point3;
	}
	
	Point getLeftPoint()
	{
		if( ( this.initialPoint.getX() <= this.point2.getX() ) && ( this.initialPoint.getX() <= this.point3.getX() ) )
		
			return this.initialPoint;
			
		if( ( this.point2.getX() <= this.initialPoint.getX() ) && ( this.point2.getX() <= this.point3.getX() ) )
		
			return this.point2;
			
		return this.point3;
	}
	
	Point getRightPoint()
	{
		if( ( this.initialPoint.getX() >= this.point2.getX() ) && ( this.initialPoint.getX() >= this.point3.getX() ) )
		
			return this.initialPoint;
			
		if( ( this.point2.getX() >= this.initialPoint.getX() ) && ( this.point2.getX() >= this.point3.getX() ) )
		
			return this.point2;
			
		return this.point3;
	}
}

/*** Clase sprite, encapsula la funcionalidad de los sprites ***/
class Sprite extends XObject
{
	Point srcInitialPoint;
	Dimensions srcDimensions;
	
	Sprite( float _srcX, float _srcY, float _srcWidth, float _srcHeight, String _id, String _className, float _x, float _y, float _xWidth, float _xHeight, String _urlXImage, boolean _visible, boolean _focus )
	{
		super( _id, _className, _x, _y, _xWidth, _xHeight, null, null, null, null, null, _urlXImage, _visible, _focus );
		
		this.srcInitialPoint = new Point( _srcX, _srcY );
		this.srcDimensions = new Dimensions( _srcWidth, _srcHeight );
	}
	
	PImage getCroppedImage()
	{
		return this.xImage.getCroppedImage( this.srcDimensions, this.srcInitialPoint, this.dimensions );
	}
}

/*** Parte javascript ***/

jsXml2Processing = {
	
	config : null,
	localConfig : null,
	
	init : function()
	{
		jsXml2Processing.setConfig();
		
		if( jsXml2Processing == null )
		
			return;
			
		jsXml2Processing.loadGrids( jsXml2Processing.config.url );
	},
	
	setConfig : function()
	{
		if( typeof( configXml2Processing ) == "undefined" || ! configXml2Processing )
		
			return;
		
		if( typeof( configXml2Processing.url ) == "undefined" || ! configXml2Processing.url || $.trim( configXml2Processing.url ) == "" )
		
			return;
			
		jsXml2Processing.config = configXml2Processing;
	},
	
	loadConfig : function( _xml )
	{
		if( ! _xml || ! $( _xml ).children( "xml2Processing" ) || $( _xml ).children( "xml2Processing" ).length <= 0 )
		
			return;
			
		var _node = $( _xml ).children( "xml2Processing" ).children( "config" );
		
		if( ! _node || _node.length <= 0 )
		
			return;
			
		var _config = jsXml2Processing.parseAttrsConfig( _node );
		
		for( var i in _config )
		{
			if( _config[ i ] == null )
			
				continue;
				
			if( typeof( jsXml2Processing.actionsConfig[ i ] ) == "function" )
			
				jsXml2Processing.actionsConfig[ i ]( _config );
		}
	},
	
	actionsConfig : {
		
		"fullpage" : function( _config )
		{
			setTimeout( function() {
				jsXml2Processing.util.fullPage( jsXml2Processing.config.id );
				
				$( window ).resize(
					function(){
						jsXml2Processing.util.fullPage( jsXml2Processing.config.id );
					}
				);
				
			}, 500 );	
		},
		
		"frameRate" : function( _config )
		{	
			frameRate( _config[ "frameRate" ] );
		},
		
		bColor : function( _config )
		{
			var _bColor = _config[ "bColor" ];
			
			if( _bColor == null )
			
				return;
				
			bColor = _config[ "bColor" ];
		}
	},
	
	parseAttrsConfig : function( _node )
	{
		var _keys = [ 
			{
				tag : "fullscreen",
				type : "boolean"
			},
			{ 
				tag : "fullpage",
				type : "boolean"
			},
			{ 
				tag : "frameRate",
				type : "int"
			},
			{
				tag : "bColor",
				type : "color"	
			} ];
		
		return jsXml2Processing.getAttrs( _node, _keys );
	},
	
	loadScripts : function( _xml, _func )
	{
		var _node = $( _xml ).children( "xml2Processing" ).children( "scripts" );
		
		if( ! _node || _node.length <= 0 )
		{
			_func();
			
			return;
		}
		
		var _urls = $( _node[ 0 ] ).children( "url" );
		
		if( ! _urls || _urls.length <= 0 )
		{
			_func();
			
			return;	
		}
		
		var _srcs = [];
		
		for( var i = 0 ; i < _urls.length ; i++ )
		{
			var _src = $.trim( $( _urls[ i ] ).text() );
			
			if( _src && _src != "" )
			
				_srcs.push( _src );
		}
		
		var _func2 = function() {
			
			if( ! _srcs || _srcs.length <= 0 )
			{
				_func();
				
				return;	
			}
			
			var _urlGet = _srcs.splice( 0, 1 );

			$.getScript( _urlGet[ 0 ] ).done(
			
				function( _script, _textStatus ) 
				{
					_func2();
					
				} ).fail( function( _jqxhr, _settings, _exception ) 
				{
					_func2();
					
				}
			);
		};
		
		_func2();
	},
	
	loadGrids : function( _url, _clear )
	{
		isLoad = false;
		
		if( typeof( _clear ) == "undefined" || ! _clear )
		
			_clear = false;
			
		else
		
			_clear = true;
		
		if( _clear )
		{	
			grids = null;
			grids = new ArrayList();
		}
			
		$.get( _url, "", function( _xml ) 
		{
			var _func = function(){
				
				jsXml2Processing.loadConfig( _xml );
				
				ArrayList _newGrids = new ArrayList();
				
				$( _xml ).find( "grid" ).each( function( _key, _value ) {
					
					var _eventsGrid = jsXml2Processing.parseEventsGrid( $( _value ).children( "events" )[ 0 ] );
					
					var _attrs = jsXml2Processing.parseGenericAttrs( $( _value ).children( "attributes" )[ 0 ] );
					
					Grid _grid = new Grid( _attrs.id, _attrs.className, _attrs.bColor, _attrs.gColor, _attrs.axis, _attrs.gType, _attrs.image, _attrs.visible );
					
					$( _value ).children().each( function( _keyObj, _valueObj ) {
					
						XObject _obj = jsXml2Processing.parseObject( _valueObj );
						
						if( _obj != null )
						
							_grid.putXObject( _obj );
					} );
					
					int _tmp = getIndGrid( _grid.id );
					
					_grid.attachEvents( _eventsGrid );
					
					if( _tmp != null )
					{	
						grids.set( _tmp, _grid );
					}	
					else
					{	
						grids.add( _grid );
					}
					
					_newGrids.add( _grid );
					
				} );
				
				isLoad = true; 
				
				if( _newGrids != null )
				{
					for( int i = 0 ; i < _newGrids.size() ; i++ )
					{
						_newGrids.get( i ).trigger( "load" );
					}		
				}
			};
			
			
			
			var _func2 = function() {
			
				if( $( _xml ).find( "image" ).length > 0 )
				{
					$( _xml ).find( "image" ).each( function( _key, _value ) {
						
						var _src = $.trim( $( _value ).text() );
						
						if( _src )
						
							jsXml2Processing.util.preloadImg( _src );
							
					} );
					
					_func();
				}
				else
				{
					_func();	
				}
			
			};
			
			jsXml2Processing.loadScripts( _xml, _func2 );
			
		}, "xml");
	},
	
	parseObject : function( _node )
	{
		var _tag = $( _node ).prop( "tagName" );
		
		if( ! _tag )
		
			return null;
		
		var _events = jsXml2Processing.parseEvents( $( _node ).find( "events" )[ 0 ] );
		
		if( _tag == "text" )
		{
			var _attrs = jsXml2Processing.parseGenericAttrs( $( _node ).find( "attributes" )[ 0 ] );
			
			var _tmp = jsXml2Processing.parseAttrsTextObject( $( _node ).find( "attributes" )[ 0 ] );
			
			for( var i in _tmp )
			{
				_attrs[ i ] = _tmp[ i ];
			}
			
			Text _text = new Text( _attrs.string, _attrs.type, _attrs.size, _attrs.hAlign, _attrs.vAlign, _attrs.id, _attrs.className, _attrs.x, _attrs.y, _attrs.width, _attrs.height, _attrs.fColor, _attrs.image, _attrs.visible, _attrs.focus );
			
			_text.attachEvents( _events );
			
			return _text;
		}
		else if( _tag == "panel" )
		{
			var _attrs = jsXml2Processing.parseGenericAttrs( $( _node ).find( "attributes" )[ 0 ] );
			
			var _tmp = jsXml2Processing.parseAttrsPanelObject( $( _node ).find( "attributes" )[ 0 ] );
			
			for( var i in _tmp )
			{
				_attrs[ i ] = _tmp[ i ];
			}

			Panel _panel = new Panel( _attrs.weight, _attrs.id, _attrs.className, _attrs.x, _attrs.y, _attrs.width, _attrs.height, _attrs.fColor, _attrs.bColor, _attrs.gColor, _attrs.axis, _attrs.gType, _attrs.image, _attrs.visible, _attrs.focus, _attrs.radius, _attrs.tlradius, _attrs.trradius, _attrs.blradius, _attrs.brradius );
			
			_panel.attachEvents( _events );
			
			return _panel;
		}
		else if( _tag == "ellipse" )
		{
			var _attrs = jsXml2Processing.parseGenericAttrs( $( _node ).find( "attributes" )[ 0 ] );
			
			var _tmp = jsXml2Processing.parseAttrsPanelObject( $( _node ).find( "attributes" )[ 0 ] );
			
			for( var i in _tmp )
			{
				_attrs[ i ] = _tmp[ i ];
			}

			Ellipse _ellipse = new Ellipse( _attrs.weight, _attrs.id, _attrs.className, _attrs.x, _attrs.y, _attrs.width, _attrs.height, _attrs.fColor, _attrs.bColor, _attrs.gColor, _attrs.axis, _attrs.gType, _attrs.image, _attrs.visible, _attrs.focus );
			
			_ellipse.attachEvents( _events );
			
			return _ellipse;
		}
		else if( _tag == "line" )
		{
			var _attrs = jsXml2Processing.parseGenericAttrs( $( _node ).find( "attributes" )[ 0 ] );
			
			var _tmp = jsXml2Processing.parseAttrsLineObject( $( _node ).find( "attributes" )[ 0 ] );
			
			for( var i in _tmp )
			{
				_attrs[ i ] = _tmp[ i ];
			}
			
			Line _line = new Line( _attrs.weight, _attrs.id, _attrs.className, _attrs.x, _attrs.y, _attrs.width, _attrs.height, _attrs.fColor, _attrs.image, _attrs.visible, _attrs.focus );
			
			_line.attachEvents( _events );
			
			return _line;
		}
		else if( _tag == "sprite" )
		{
			var _attrs = jsXml2Processing.parseGenericAttrs( $( _node ).find( "attributes" )[ 0 ] );
			
			var _tmp = jsXml2Processing.parseAttrsSpriteObject( $( _node ).find( "attributes" )[ 0 ] );
			
			for( var i in _tmp )
			{
				_attrs[ i ] = _tmp[ i ];
			}
			
			Sprite _sprite = new Sprite( _attrs.srcX, _attrs.srcY, _attrs.srcWidth, _attrs.srcHeight, _attrs.id, _attrs.className, _attrs.x, _attrs.y, _attrs.width, _attrs.height, _attrs.image, _attrs.visible, _attrs.focus );
			
			_sprite.attachEvents( _events );
			
			return _sprite;
		}
		else if( _tag == "triangle" )
		{
			var _attrs = jsXml2Processing.parseGenericAttrs( $( _node ).find( "attributes" )[ 0 ] );
			
			var _tmp = jsXml2Processing.parseAttrsTriangleObject( $( _node ).find( "attributes" )[ 0 ] );
			
			for( var i in _tmp )
			{
				_attrs[ i ] = _tmp[ i ];
			}
			
			Triangle _triangle = new Triangle( _attrs.x2, _attrs.y2, _attrs.x3, _attrs.y3, _attrs.weight, _attrs.id, _attrs.className, _attrs.x, _attrs.y, _attrs.fColor, _attrs.bColor, _attrs.gColor, _attrs.axis, _attrs.gType, _attrs.visible, _attrs.focus );
			
			_triangle.attachEvents( _events );
			
			return _triangle;
		}
		
		return null;
	},
	
	parseEventsGrid : function( _node )
	{
		var _keys = [ 
			{ 
				tag : "load",
				type : "event"
			},
			{
				tag : "frame",
				type : "event"
			}, 
			{
				tag : "hide",
				type : "event"
			}, 
			{
				tag : "show",
				type : "event"
			} ];
		
		return jsXml2Processing.getAttrs( _node, _keys );
	},
	
	parseEvents : function( _node )
	{
		var _keys = [ 
			{ 
				tag : "click",
				type : "event"
			},
			{
				tag : "mouseon",
				type : "event"
			}, 
			{
				tag : "mouseout",
				type : "event"
			}, 
			{
				tag : "mousedragged",
				type : "event"
			},
			{
				tag : "mousedraggedoff",
				type : "event"
			},
			{
				tag : "mousereleased",
				type : "event"
			},
			{
				tag : "keypressed",
				type : "event"
			}, 
			{
				tag : "frame",
				type : "event"
			}, 
			{
				tag : "hide",
				type : "event"
			}, 
			{
				tag : "show",
				type : "event"
			} ];
		
		return jsXml2Processing.getAttrs( _node, _keys );
	},
	
	parseAttrsTextObject : function( _node )
	{
		var _keys = [ 
			{ 
				tag : "string",
				type : "string"
			},
			{
				tag : "type",
				type : "string"
			}, 
			{
				tag : "size",
				type : "float"
			},
			{
				tag : "hAlign",
				type : "align"
			},
			{
				tag : "vAlign",
				type : "align"
			} ];
		
		return jsXml2Processing.getAttrs( _node, _keys );
	},
	
	parseAttrsPanelObject : function( _node )
	{
		var _keys = [ 
			{ 
				tag : "weight",
				type : "float"
			},
			{ 
				tag : "radius",
				type : "float"
			},
			{ 
				tag : "tlradius",
				type : "float"
			},
			{ 
				tag : "trradius",
				type : "float"
			},
			{ 
				tag : "blradius",
				type : "float"
			},
			{ 
				tag : "brradius",
				type : "float"
			} ];
		
		return jsXml2Processing.getAttrs( _node, _keys );
	},
	
	parseAttrsLineObject : function( _node )
	{
		var _keys = [ 
			{ 
				tag : "weight",
				type : "float"
			} ];
		
		return jsXml2Processing.getAttrs( _node, _keys );
	},
	
	parseAttrsSpriteObject : function( _node )
	{
		var _keys = [
			{ 
				tag : "srcX",
				type : "float"
			},
			{ 
				tag : "srcY",
				type : "float"
			},
			{ 
				tag : "srcWidth",
				type : "float"
			},
			{ 
				tag : "srcHeight",
				type : "float"
			} ];
		
		return jsXml2Processing.getAttrs( _node, _keys );
	},
	
	parseAttrsTriangleObject : function( _node )
	{
		var _keys = [ 
			{ 
				tag : "x2",
				type : "float"
			},
			{ 
				tag : "y2",
				type : "float"
			},
			{ 
				tag : "x3",
				type : "float"
			},
			{ 
				tag : "y3",
				type : "float"
			},
			{ 
				tag : "weight",
				type : "float"
			} ];
		
		return jsXml2Processing.getAttrs( _node, _keys );
	},
	
	parseGenericAttrs : function( _node )
	{
		var _keys = [
			{ 
				tag : "id",
				type : "string"
			},
			{
				tag : "className",
				type : "string"
			},
			{ 
				tag : "x",
				type : "float"
			},
			{
				tag : "y",
				type : "float"
			}, 
			{
				tag : "width",
				type : "float"
			},
			{
				tag : "height",
				type : "float"
			},
			{
				tag : "fColor",
				type : "color"
			},
			{
				tag : "bColor",
				type : "color"
			},
			{ 
				tag : "gColor",
				type : "colorList"
			},
			{ 
				tag : "axis",
				type : "axis"
			},
			{ 
				tag : "gType",
				type : "gradientType"
			},
			{
				tag : "image",
				type : "string"	
			},
			{
				tag : "visible",
				type : "boolean"	
			},
			{
				tag : "focus",
				type : "boolean"	
			}  ];
		
		return jsXml2Processing.getAttrs( _node, _keys );
	},
	
	getAttrs : function( _node, _keys )
	{
		var _attrs = {};
		
		for( var i = 0 ; i < _keys.length ; i++ )
		{
			if( typeof( jsXml2Processing.getAttrOfType[ _keys[ i ].type ] ) == "function" )
			{
				var _tmp = $( _node ).find( _keys[ i ].tag );
				
				if( ! _tmp )
				
					_attrs[ _keys[ i ].tag ] = null;
				
				else
				
					_attrs[ _keys[ i ].tag ] = jsXml2Processing.getAttrOfType[ _keys[ i ].type ]( _tmp );
			}	
		}
		
		return _attrs;
	},
	
	getAttrOfType : {
		
		"event" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
				
			try
			{
				eval( 'var _func = ' + $.trim( $( _node ).text() ) );
				
				if( typeof( _func ) != "function" )
				
					return null;
					
				return $.trim( $( _node ).text() );
			}
			catch( _ex )
			{
				return null;	
			}
			
			return null;
		},
		
		"axis" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
				
			var _txt = $.trim( $( _node ).text() ).toUpperCase();
			
			if( _txt != "X" && _txt != "Y" )
			
				return null;
				
			if( _txt == "X" )
			
				return 2;
				
			return 1;
		},
		
		"gradientType" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
				
			var _txt = $.trim( $( _node ).text() ).toUpperCase();
			
			if( _txt != "LINEAR" && _txt != "RADIAL" )
			
				return null;
				
			if( _txt == "RADIAL" )
			
				return 2;
				
			return 1;
		},
		
		"string" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
				
			return $.trim( $( _node ).text() );
		},
		
		"boolean" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
			
			if( $.trim( $( _node ).text() ) == "false" )
			
				return false;
				
			return true;
		},
		
		"float" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
				
			return parseFloat( $.trim( $( _node ).text() ) );
		},
		
		"int" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
				
			return parseInt( $.trim( $( _node ).text() ), 10 );
		},
		
		"color" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
				
			var _color = $.trim( $( _node ).text() );
		
			_color = _color.replace( /#/g, "" );
				
			if( _color.length != 6 && _color.length != 8 )
			
				return null;
				
			int _red = parseInt( _color.substring( 0, 2 ), 16 );
			int _green = parseInt( _color.substring( 2, 4 ), 16 );
			int _blue = parseInt( _color.substring( 4, 6 ), 16 );
			int _alpha = parseInt( "ff", 16 );
			
			if( _color.length == 8 )
			
				_alpha = parseInt( _color.substring( 6, 8 ), 16 );
			
			return color( _red, _green, _blue, _alpha );
		},
		
		"colorList" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
				
			var _colors = $.trim( $( _node ).text() );
			
			ArrayList _list = new ArrayList();
			
			if( ! _colors.match( /,/ ) )
			{
				var _color = jsXml2Processing.getAttrOfType.color( _node );
				
				if( _color != null )
				{
					_list.add( _color );
					
					return _list;
				} 
				
				return null;
			}
			
			var _arrColors = _colors.split( "," );
			
			for( var i = 0 ; i < _arrColors.length ; i++ )
			{
				var _codeNode = '<gColor>' + _arrColors[ i ] + '</gColor>';
				
				var _color = jsXml2Processing.getAttrOfType.color( $( _codeNode )[ 0 ] );
				
				if( _color != null )
				{
					_list.add( _color );
				}	
			}
			
			if( _list.size() <= 0 )
			
				return null;
			
			return _list;
		},
		
		"align" : function( _node )
		{
			var _str = $.trim( $( _node ).text() );
			
			if( ! _str )
		
				return CENTER;
				
			if( _str.toUpperCase() == "CENTER" )
			{
				return CENTER;
			}
			else if( _str.toUpperCase() == "LEFT" )
			{
				return LEFT;
			}
			else if( _str.toUpperCase() == "RIGHT" )
			{
				return RIGHT;
			}
			else if( _str.toUpperCase() == "TOP" )
			{
				return TOP;
			}
			else if( _str.toUpperCase() == "BOTTOM" )
			{
				return BOTTOM;
			}
			else if( _str.toUpperCase() == "BASELINE" )
			{
				return BASELINE;
			}
			
			return CENTER;
		}
		
	},
	
	util : {
		
		preloadImg : function( _src ) 
		{
	    	$('<img/>')[ 0 ].src = _src;
		},
		
		colorRollover : function( _obj, _changeBColor, _changeFColor, _changeTypeGradient )
		{	
			if( _changeFColor && _obj.fColor != null )
			
				_obj.fColor = jsXml2Processing.util.getRGBARollover( _obj.fColor );
			
			if( _changeBColor && _obj.bColor != null )
			
				_obj.bColor = jsXml2Processing.util.getRGBARollover( _obj.bColor );
				
			if( ( _changeTypeGradient || _changeBColor ) && _obj.bColor != null && _obj.gradient != null && _obj.gradient.gColor.size() > 0 )
			{
				ArrayList _newG = new ArrayList();
				
				if( _changeBColor )
				{
					for( int i = 0 ; i < _obj.gradient.gColor.size() ; i++ )
				
						_newG.add( jsXml2Processing.util.getRGBARollover( _obj.gradient.gColor.get( i ) ) );
				}
				else
				{
					_newG = _obj.gradient.gColor;	
				}
					
				if( ! _changeTypeGradient )
				
					_obj.setGradient( new Gradient( _obj, _obj.bColor, _newG, _obj.gradient.axis, _obj.gradient.type ) );
					
				else
				{
					int _type = _obj.gradient.LINEAR;
					
					if( _obj.gradient.type == _obj.gradient.LINEAR )
					
						_type = _obj.gradient.RADIAL;
						
					_obj.setGradient( new Gradient( _obj, _obj.bColor, _newG, _obj.gradient.axis, _type ) );
				}	
			}				
		},
		
		getProcessingInstance : function()
		{
			var _processingInstance = Processing.getInstanceById( jsXml2Processing.config.id );
			
			return _processingInstance;
		},
		
		getRGBARollover : function( _color )
		{
			if( ! _color )
			
				return null;
				
			float _rollR = ( red( _color ) <= 127 )?( 127 + abs( ( 127 - red( _color ) ) ) ):( 127 - abs( ( 127 - red( _color ) ) ) );
			float _rollG = ( green( _color ) <= 127 )?( 127 + abs( ( 127 - green( _color ) ) ) ):( 127 - abs( ( 127 - green( _color ) ) ) );
			float _rollB = ( blue( _color ) <= 127 )?( 127 + abs( ( 127 - blue( _color ) ) ) ):( 127 - abs( ( 127 - blue( _color ) ) ) );
			
			return color( _rollR, _rollG, _rollB, alpha( _color ) );
		},
		
		addXObjectToGrid : function( _id, _obj )
		{
			if( ! _id || ! _obj )
			
				return;
			
			Grid _grid = getGrid( _id );
			
			if( _grid == null )
			
				return;
				
			var _x2js = new X2JS(); 
			
			var _xml = _x2js.json2xml( _obj );
			
			XObject _new = jsXml2Processing.parseObject( $( _xml ).children()[ 0 ] );
			
			if( _new != null )
			{
				_grid.putXObject( _new );
			}
		},
		
		toggleFullScreen : function() 
		{
			if( ( document.fullscreenElement && document.fullscreenElement !== null ) ||
				( ! document.mozFullScreenElement && ! document.webkitFullscreenElement ) )
			{
				if( document.documentElement.requestFullscreen ) 
				{
					document.documentElement.requestFullscreen();
				} 
				else if( document.documentElement.mozRequestFullScreen ) 
				{
          			document.documentElement.mozRequestFullScreen();
				} 
				else if( document.documentElement.webkitRequestFullscreen ) 
				{
					document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
				}
			} 
			else 
			{
				if( document.cancelFullScreen ) 
				{
					document.cancelFullScreen();
				} 
				else if( document.mozCancelFullScreen ) 
				{
          			document.mozCancelFullScreen();
        		} 
        		else if( document.webkitCancelFullScreen ) 
        		{
          			document.webkitCancelFullScreen();
				}
			}
		},
		
		fullPage : function( _idCanvas )
		{
			var _canvElem = document.getElementById( _idCanvas );
			
		    var _newWidth = document.documentElement.clientWidth;
		    var _newHeight = document.documentElement.clientHeight;
		    
		    _canvElem.style.position = "fixed";
		    _canvElem.setAttribute( "width", _newWidth );
		    _canvElem.setAttribute( "height", _newHeight );
		    _canvElem.style.top = 0 + "px";
		    _canvElem.style.left = 0 + "px";
		    
		    size( _newWidth, _newHeight );
		    
		    sWidth = _newWidth;
		    sHeight = _newHeight;
		}
	}
};