/*** Atributos globales ***/
int sWidth = 800;
int sHeight = 600;
ArrayList grids;
boolean isLoad = false;
color bColor = color( 0 );
int actualFrameRate = 24;

int x = 0;
int y = 0;

/*** Inicializa el entorno ***/
void setup() 
{
	size( sWidth, sHeight );
	
	frameRate( actualFrameRate );

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

void mousePressed() 
{
	if( isLoad && grids != null && grids.size() > 0 )
	{
		for( int i = 0 ; i < grids.size() ; i++ )
		{
			grids.get( i ).trigger( "mousepressed" );
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

void keyReleased()
{
	if( isLoad && grids != null && grids.size() > 0 )
	{
		for( int i = 0 ; i < grids.size() ; i++ )
		{
			grids.get( i ).trigger( "keyreleased" );
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
	final static int TIME_TO_RESIZE = 100;
	
	PImage xImage;
	String src;
	
	float lastWidth;
	float lastHeight;
	
	int imageResized = 0;
	
	XImage( String _src )
	{
		 this.xImage = requestImage( _src );
		 
		 this.src = _src;
	}
	
	PImage getXImage()
	{
		return this.xImage;	
	}
	
	String getSrc()
	{
		return this.src;	
	}
	
	void setSrc( String _src )
	{
		this.xImage = requestImage( _src );
	}
	
	void display( float _x, float _y, float _width, float _height )
	{
		if( this.xImage == null )
		
			return;
		
		boolean _show = true;

		if( this.lastWidth != width || this.lastHeight != height )
		{
			float _framesToResize = ( XImage.TIME_TO_RESIZE * actualFrameRate ) / 1000;
			
			if( this.imageResized > _framesToResize )
			{
				this.lastWidth = width;
				this.lastHeight = height;
				this.xImage.resize( _width, _height );
				
				_show = true;	
			}
			else
			{
				_show = false;
			}
			
			this.imageResized++;
		}
		
		if( _show )
		{
			noFill();
			noStroke();
			image( this.xImage, _x, _y );
		}
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
	static final int Y_AXIS = 1;

	static final int X_AXIS = 2;
	
	static final int LINEAR = 1;
	
	static final int RADIAL = 2;

	XObject container;
	
	ArrayList gColor;
	
	int axis;
	int gType;
	
	Gradient( XObject _container, ArrayList _gColor, int _axis, int _gType )
	{
		this.container = _container;
		
		this.gColor = _gColor;
		this.axis = _axis;
		this.gType = _gType;
	}
	
	ArrayList getGColor()
	{
		return this.gColor;	
	}
	
	int getAxis()
	{
		return this.axis;	
	}
	
	int getGType()
	{
		return this.gType;	
	}
	
	void setGColor( ArrayList _gColor )
	{
		this.gColor = _gColor;	
	}
	
	void setAxis( int _axis )
	{
		this.axis = _axis;	
	}
	
	void setGType( int _gType )
	{
		this.gType = _gType;	
	}
	
	void display()
	{
		if( this.gType == null )
		
			this.gType = Gradient.LINEAR;
			
		if( this.axis == null )
		
			this.axis = Gradient.Y_AXIS;
			
		float _x = this.container.initialPoint.getX();
		float _y = this.container.initialPoint.getY();
		
		float _width = this.container.dimensions.getXWidth();
		float _height = this.container.dimensions.getXHeight();

		var _ctx = $( "#" + configXml2Processing.id )[ 0 ].getContext( "2d" );
		
		var _grd = null;
		
		if( this.gType == Gradient.LINEAR )
		{
			if( this.container instanceof Triangle )
			{
				_grd = _ctx.createLinearGradient( this.container.getLeftPoint().getX(), this.container.getCenter().getY(), this.container.getRightPoint().getX(), this.container.getCenter().getY() );
				
				if( this.axis == Gradient.Y_AXIS )
			
					_grd = _ctx.createLinearGradient( this.container.getCenter().getX(), this.container.getTopPoint().getY(), this.container.getCenter().getX(), this.container.getBottomPoint().getY() );
			}
			else if( this.container instanceof Ellipse )
			{
				_grd = _ctx.createLinearGradient( ( _x - ( _width / 2 ) ), _y, ( _x + ( _width / 2 ) ), _y );
			
				if( this.axis == Gradient.Y_AXIS )
			
					_grd = _ctx.createLinearGradient( _x, ( _y - ( _height / 2 ) ), _x, ( _y + ( _height / 2 ) ) );
			}
			else
			{
				_grd = _ctx.createLinearGradient( _x, _y, ( _x + _width ), _y );
			
				if( this.axis == Gradient.Y_AXIS )
			
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
		
		_grd.addColorStop( 0, "rgba("+ red( this.container.getBColor() )+","+ green( this.container.getBColor() )+","+ blue( this.container.getBColor() )+","+ alpha( this.container.getBColor() ) +" )" );
		
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
	ArrayList mousepressed;
	ArrayList mousereleased;
	ArrayList keypressed;
	ArrayList keyreleased;
	ArrayList frame;
	ArrayList load;
	ArrayList ehide;
	ArrayList eshow;
	ArrayList efocus;
	ArrayList eblur;
	/*** Fin eventos ***/
	
	color fColor;
	color bColor;
	
	Gradient gradient;
	
	boolean lockMouseOn;
	boolean lockMouseDragged;
	boolean lockMousePressed;
	boolean lockKeyPressed;
	
	Dimensions dimensions;
	
	String id;
	String className;
	Point initialPoint;
	
	float stepX;
	float stepY;
	boolean noiseMove;
	int framesToMove;
	int lastFramesToMove;
	
	boolean visible;
	boolean xFocus;
	
	/*** Array que contendra las teclas pulsadas ***/
	ArrayList pressedKeys;
	
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
		this.mousepressed = new ArrayList();
		this.mousereleased = new ArrayList();
		this.keypressed = new ArrayList();
		this.keyreleased = new ArrayList();
		this.frame = new ArrayList();
		this.load = new ArrayList();
		this.ehide = new ArrayList();
		this.eshow = new ArrayList();
		this.efocus = new ArrayList();
		this.eblur = new ArrayList();
		
		this.initialPoint = new Point( _x, _y );
		
		this.dimensions = new Dimensions( _xWidth, _xHeight );
		
		this.fColor = _fColor;
		this.bColor = _bColor;
		
		this.stepX = 0;
		this.stepY = 0;
		
		this.lastFramesToMove = null;
		this.framesToMove = null;
		
		this.noiseMove = false;
		
		this.visible = true;
		
		if( _visible != null )
		
			this.visible = _visible;
			
		this.xFocus = false;
		
		if( _focus != null )
		
			this.xFocus = _focus;
		
		if( _urlXImage != null )
		
			this.xImage = new XImage( _urlXImage );
			
		this.pressedKeys = new ArrayList();
		
		this.stateVariables = new HashMap();
		
		if( _gColor != null && _bColor != null )
		{
			this.gradient = new Gradient( this, _gColor, _axis, _gType );
		}
	}
	
	void setPoint( float x, float y )
	{
		this.initialPoint.setX( x );
		this.initialPoint.setY( y );	
	}
	
	void display()
	{
		boolean _move = false;
		
		if( this.stepX != 0 || this.stepY != 0 )
		{
			if( this.framesToMove == null )
			{
				_move = true;	
			}
			else
			{
				if( this.lastFramesToMove === null )
				{
					_move = true;
					
					this.lastFramesToMove = 0;
				}
				else
				{
					if( ( this.lastFramesToMove % this.framesToMove ) == 0 )
					
						_move = true;
				}
				
				this.lastFramesToMove++;
			}
		}

		if( this.stepX != 0 )
		{
			if( _move )
			{
				float _stepX = this.stepX;
				
				if( this.noiseMove )
				
					_stepX = noise( this.stepX ) * this.stepX;
					
				this.initialPoint.setHorizontalMovement( this.initialPoint.horizontalMovement + _stepX );
			}
		}
		
		if( this.stepY != 0 )
		{
			if( _move )
			{
				float _stepY = this.stepY;
				
				if( this.noiseMove )
				
					_stepY = noise( this.stepY ) * this.stepY;
					
				this.initialPoint.setVerticalMovement( this.initialPoint.verticalMovement + _stepY );
			}
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
					if( this instanceof Ellipse )
					
						this.xImage.display( ( this.initialPoint.getX() - ( this.dimensions.getXWidth() / 2 ) ), ( this.initialPoint.getY() - ( this.dimensions.getXHeight() / 2 ) ), this.dimensions.getXWidth(), this.dimensions.getXHeight() );
					
					else
					
						this.xImage.display( this.initialPoint.getX(), this.initialPoint.getY(), this.dimensions.getXWidth(), this.dimensions.getXHeight() );
				}
			}	
		}
	}
	
	void move( float _stepX, float _stepY, boolean _noise, int _framesToMove )
	{
		this.move( _stepX, _stepY );
		this.noiseMove = _noise;
		this.framesToMove = _framesToMove;
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
		
		this.lastFramesToMove = null;
		this.framesToMove = null;
		this.noiseMove = false;
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
		if( this.isFocus() )
		
			return;
			
		this.xFocus = true;
		
		this.trigger( "focus" );	
	}
	
	void blur()
	{
		if( ! this.isFocus() )
		
			return;
			
		this.xFocus = false;
		
		this.trigger( "blur" );	
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
	
	void onMousePressed( String _func )
	{
		this.addEvent( _func, "mousepressed" );
	}
	
	void onMouseReleased( String _func )
	{
		this.addEvent( _func, "mousereleased" );
	}
	
	void onKeyPressed( String _func )
	{
		this.addEvent( _func, "keypressed" );
	}
	
	void onKeyReleased( String _func )
	{
		this.addEvent( _func, "keyreleased" );
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
	
	void onFocus( String _func )
	{
		this.addEvent( _func, "focus" );
	}
	
	void onBlur( String _func )
	{
		this.addEvent( _func, "blur" );
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
		String _mousepressed = _events[ "mousepressed" ];
		String _mousereleased = _events[ "mousereleased" ];
		String _keypressed = _events[ "keypressed" ];
		String _keyreleased = _events[ "keyreleased" ];
		String _frame = _events[ "frame" ];
		String _load = _events[ "load" ];
		String _hide = _events[ "hide" ];
		String _show = _events[ "show" ];
		String _focus = _events[ "focus" ];
		String _blur = _events[ "blur" ];
		
		this.onClick( _click );
		this.onMouseOn( _mouseon );
		this.onMouseOut( _mouseout );
		this.onMouseDragged( _mousedragged );
		this.onMouseDraggedOff( _mousedraggedoff );
		this.onMousePressed( _mousepressed );
		this.onMouseReleased( _mousereleased );
		this.onKeyPressed( _keypressed );
		this.onKeyReleased( _keyreleased );
		this.onFrame( _frame );
		this.onLoad( _load );
		this.onHide( _hide );
		this.onShow( _show );
		this.onFocus( _focus );
		this.onBlur( _blur );
	}
	
	void clearEvents()
	{
		/*** Inicializamos los arraylist de los eventos ***/
		this.click = new ArrayList();
		this.mouseon = new ArrayList();
		this.mouseout = new ArrayList();
		this.mousedragged = new ArrayList();
		this.mousedraggedoff = new ArrayList();
		this.mousepressed = new ArrayList();
		this.mousereleased = new ArrayList();
		this.keypressed = new ArrayList();
		this.keyreleased = new ArrayList();
		this.frame = new ArrayList();
		this.load = new ArrayList();
		this.ehide = new ArrayList();
		this.eshow = new ArrayList();
		this.efocus = new ArrayList();
		this.eblur = new ArrayList();
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
				
			else if( _type == "mousepressed" )
			
				this.mousepressed.add( _func );
				
			else if( _type == "mousereleased" )
			
				this.mousereleased.add( _func );
				
			else if( _type == "keypressed" )
			
				this.keypressed.add( _func );
				
			else if( _type == "keyreleased" )
			
				this.keyreleased.add( _func );
				
			else if( _type == "frame" )
			
				this.frame.add( _func );
				
			else if( _type == "load" )
			
				this.load.add( _func );
				
			else if( _type == "hide" )
			
				this.ehide.add( _func );
				
			else if( _type == "show" )
			
				this.eshow.add( _func );
				
			else if( _type == "focus" )
			
				this.efocus.add( _func );
				
			else if( _type == "blur" )
			
				this.eblur.add( _func );
		}
		catch( _ex )
		{
			
		}
	}
	
	Object getStateVariable( String _key )
	{
		return this.stateVariables.get( _key );	
	}
	
	void setStateVariable( String _key, Object _value )
	{
		this.stateVariables.put( _key, _value );	
	}
	
	void removeStateVariable( String _key )
	{
		this.stateVariables.remove( _key );	
	}
	
	String getSrcImage()
	{
		if( this.xImage == null )
		
			return null;
			
		return this.xImage.getSrc();	
	}
	
	color getFColor()
	{
		return this.fColor;	
	}
	
	color getBColor()
	{
		return this.bColor;	
	}
	
	ArrayList getGColor()
	{
		if( this.gradient == null )
		
			return null;
			
		return this.gradient.getGColor(); 	
	}
	
	int getAxis()
	{
		if( this.gradient == null )
		
			return null;
			
		return this.gradient.getAxis(); 	
	}
	
	int getGType()
	{
		if( this.gradient == null )
		
			return null;
			
		return this.gradient.getGType(); 	
	}
	
	String setSrcImage( String _src )
	{
		if( this.xImage == null )
		{
			this.xImage = new XImage( _src );
		}
		else
		{	
			this.xImage.setSrc( _src );
		}	
	}
	
	void setFColor( color _color )
	{
		this.fColor = _color;
	}
	
	void setBColor( color _color )
	{
		this.bColor = _color;
	}
	
	void setGColor( ArrayList _gColor )
	{
		if( this.gradient == null )
		
			return;
			
		this.gradient.setGColor( _gColor );	
	}
	
	void setAxis( int _axis )
	{
		if( this.gradient == null )
		
			return;
			
		this.gradient.setAxis( _axis );		
	}
	
	void setGType( int _gType )
	{
		if( this.gradient == null )
		
			return;
			
		this.gradient.setGType( _gType );		
	}
	
	void setGradient( color _bColor, ArrayList _gColor, int _axis, int _gType )
	{
		if( _bColor == null || _gColor == null )
		
			return;
		
		this.bColor = _bColor;
		
		Gradient _grad = new Gradient( this, _gColor, _axis, _gType );
		
		this.gradient = _grad;
	}
	
	void clearGradient()
	{
		this.gradient = null;	
	}
	
	boolean isKeyInList( char _key )
	{
		for( int i = 0 ; i < this.pressedKeys.size() ; i++ )
		{
			if( this.pressedKeys.get( i ) == _key )
			
				return true;	
		}
		
		return false;
	}
	
	char getKeyPressed()
	{
		if( key == CODED )
			
			return keyCode;
		
		return key;		
	}
	
	void removeKey( char _key )
	{
		for( int i = 0 ; i < this.pressedKeys.size() ; i++ )
		{
			if( this.pressedKeys.get( i ) == _key )
			{
				this.pressedKeys.remove( i );
			}	
		}
	}
	
	ArrayList getPressedKeys()
	{
		return this.pressedKeys;	
	}
	
	void trigger( String _type )
	{
		if( ( ( _type != "frame" && _type != "hide" && _type != "show" && _type != "focus" && _type != "blur" && _type != "load" ) && this.isHide() ) || ! this.isMouseOn( _type ) )
		
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
		else if( _type == "mousepressed" )
		{
			for( int i = 0 ; i < this.mousepressed.size() ; i++ )
			
				_strEval += this.mousepressed.get( i ) + "(this);";
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
		else if( _type == "keyreleased" )
		{
			for( int i = 0 ; i < this.keyreleased.size() ; i++ )
			
				_strEval += this.keyreleased.get( i ) + "(this);";
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
		else if( _type == "focus" )
		{
			for( int i = 0 ; i < this.efocus.size() ; i++ )
			
				_strEval += this.efocus.get( i ) + "(this);";
		}
		else if( _type == "blur" )
		{
			for( int i = 0 ; i < this.eblur.size() ; i++ )
			
				_strEval += this.eblur.get( i ) + "(this);";
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
		if( _type == "frame" || _type == "load" || _type == "show" || _type == "hide" || _type == "focus" || _type == "blur" )
		
			return true;
			
		if( this.isHide() )
		
			return false;
		
		if( this instanceof Text || this instanceof Line )
		{
			if( _type == "mouseon" || _type == "mouseout" || _type == "mousedragged" || _type == "mousedraggedoff" || _type == "click" || _type == "mousepressed" || _type == "mousereleased" || _type == "keypressed" || _type == "keyreleased" )
			
				return false;	
		}
			
		if( _type == "keypressed" || _type == "keyreleased" )
		{
			if( this.xFocus )
			{
				char _key = this.getKeyPressed();
				
				if( _type == "keypressed" )
				{	
					if( this.isKeyInList( _key ) )
					
						return false;
					
					this.pressedKeys.add( _key );
					
					return true;	
				}
				
				this.removeKey( _key );
				
				return true;
			}
			
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
				if( _type == "mousereleased" && this.lockMousePressed )
				{
					this.lockMousePressed = false;
					
					return true;
				}
					
				if( _type == "click" )
				{
					//this.xFocus = true;
					
					return true;
				}
					
				return false;
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
			
			if( _type == "mousepressed" )
			{
				if( ! this.lockMousePressed )
				{
					this.lockMousePressed = true;
					
					return true;	
				}
			}
		}
		else
		{
			/*if( _type == "click" )
					
				this.xFocus = false;*/
					
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
			
			if( _type == "mousereleased" )
			{
				if( this.lockMousePressed )
				{
					this.lockMousePressed = false;
					
					return true;
				}
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
	
	Grid( String _id, String _className, color _bColor, ArrayList _gColor, int _axis, int _gType, String _urlXImage, boolean _visible, boolean _focus )
	{
		super( _id, _className, 0, 0, 100, 100, null, _bColor, _gColor, _axis, _gType, _urlXImage, _visible, _focus );
		
		this.xObjects = new ArrayList();
	}
	
	void putXObject( XObject _obj )
	{
		for( int i = 0 ; i < this.xObjects.size() ; i++ )
		{
			XObject _xObject = ( XObject )this.xObjects.get( i );
			
			if( _xObject.id == _obj.id )
			{
				this.xObjects.set( i, _obj );
				
				return;
			}
		}
		
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
				
				return;
			}
		}
	}
	
	void removeXObject( XObject _obj )
	{
		for( int i = 0 ; i < this.xObjects.size() ; i++ ) 
		{
			XObject _xObject = ( XObject )this.xObjects.get( i );
			
			if( _xObject.id == _obj.id )
			{
				this.xObjects.remove( i );
				
				return;
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
	
	Text( String _text, String _type, float _size, float _hAlign, float _vAlign, String _id, String _className, float _x, float _y, float _xWidth, float _xHeight, color _fColor, boolean _visible, boolean _focus )
	{
		super( _id, _className, _x, _y, _xWidth, _xHeight, _fColor, null, null, null, null, null, _visible, _focus );
		
		this.xText = _text;
		
		this.hAlign = _hAlign;
		
		this.vAlign = _vAlign;
		
		this.xSize = _size;
		
		this.font = loadFont( _type );
	}
	
	String getString()
	{
		return this.xText;
	}
	
	void setString( String _str )
	{
		this.xText = _str;	
	}
	
	PFont getFont()
	{
		return this.font;
	}
	
	void setFont( String _type, String _url )
	{
		if( _url != null )
		{
			var _fonts = [
			
				{
					"type" : _type,
					"url" : _url	
				}
			];
			
			jsXml2Processing.util.preloadFonts( _fonts, null );	
		}
		
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
	float point2;
	
	Line( float _x2, float _y2, float _weight, String _id, String _className, float _x, float _y, color _fColor, boolean _visible, boolean _focus )
	{
		super( _id, _className, _x, _y, 0, 0, _fColor, null, null, null, null, null, _visible, _focus );
		
		this.weight = _weight;
		this.point2 = new Point( _x2, _y2 );
	}
	
	void setInitialPoint( float _x, float _y )
	{
		this.initialPoint.setX( _x );
		this.initialPoint.setY( _y );	
	}
	
	void setFinalPoint( float _x, float _y )
	{
		this.point2.setX( _x );
		this.point2.setY( _y );	
	}
	
	void setWeight( float _weight )
	{
		this.weight = _weight;	
	}
	
	float getWeight()
	{
		return this.weight;	
	}
	
	void display()
	{
		super.display();
		
		if( this.isHide() )
		
			return;
		
		float _weight = ( height * this.weight ) / 100;
		
		if( width < height )
		
			_weight = ( width * this.weight ) / 100;
		
		stroke( this.fColor );
		
		strokeWeight( _weight );
		
		float _x = this.initialPoint.getX();
		float _y = this.initialPoint.getY();
		float _fX = this.point2.getX();
		float _fY = this.point2.getY();
		
		line( _x, _y, _fX, _fY );
	}
	
	boolean mouseIsOverLine() 
	{	
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
	
	void setWeight( float _weight )
	{
		this.weight = _weight;	
	}
	
	float getWeight()
	{
		return this.weight;	
	}
	
	void removeBorder()
	{
		this.weight = null;
		this.fColor = null;	
	}
	
	void setRadius( float _radius )
	{
		this.radius = _radius;
	}
	
	float getRadius()
	{
		return this.radius;	
	}
	
	void setTlRadius( float _tlradius )
	{
		this.tlradius = _tlradius;	
	}
	
	float getTlRadius()
	{
		return this.tlradius;
	}
	
	void setTrRadius( float _trradius )
	{
		this.trradius = _trradius;	
	}
	
	float getTrRadius()
	{
		return this.trradius;
	}
	
	void setBlRadius( float _blradius )
	{
		this.blradius = _blradius;	
	}
	
	float getBlRadius()
	{
		return this.blradius;
	}
	
	void setBrRadius( float _brradius )
	{
		this.brradius = _brradius;	
	}
	
	float getBrRadius()
	{
		return this.brradius;
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
	
	void setVisibleArea( float _srcX, float _srcY, float _srcWidth, float _srcHeight )
	{
		this.srcInitialPoint.setX( _srcX );
		this.srcInitialPoint.setY( _srcY );
		
		this.srcDimensions.setXWidth( _srcWidth );
		this.srcDimensions.setXHeight( _srcHeight );
	}
	
	void setVisibleArea( float _srcX, float _srcY )
	{
		this.srcInitialPoint.setX( _srcX );
		this.srcInitialPoint.setY( _srcY );
	}
}

/*** Parte javascript ***/

jsXml2Processing = {
	
	config : null,
	localConfig : null,
	chargedFonts : {},
	loadedImages : [],
	
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
		
		var _width = sWidth;
		var _height = sHeight;
		
		for( var i in _config )
		{
			if( _config[ i ] == null )
			
				continue;
			
			if( i == "width" )
			{
				_width = _config[ i ];
				
				continue;	
			}
			
			if( i == "height" )
			{
				_height = _config[ i ];
				
				continue;	
			}
			
			if( typeof( jsXml2Processing.actionsConfig[ i ] ) == "function" )
			
				jsXml2Processing.actionsConfig[ i ]( _config );
		}
		
		if( _width != sWidth || _height != sHeight )
		
			jsXml2Processing.util.changeWidthAndHeight( _width, _height );
	},
	
	actionsConfig : {
		
		"fullpage" : function( _config )
		{
			setTimeout( function() {
				jsXml2Processing.util.fullPage();
				
				$( window ).resize(
					function(){
						jsXml2Processing.util.fullPage();
					}
				);
				
			}, 500 );	
		},
		
		"frameRate" : function( _config )
		{	
			frameRate( _config[ "frameRate" ] );
			actualFrameRate = _config[ "frameRate" ];
		},
		
		"bColor" : function( _config )
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
			},
			{
				tag : "width",
				type : "int"	
			},
			{
				tag : "height",
				type : "int"	
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
					
					Grid _grid = new Grid( _attrs.id, _attrs.className, _attrs.bColor, _attrs.gColor, _attrs.axis, _attrs.gType, _attrs.image, _attrs.visible, _attrs.focus );
					
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
			
			var _func3 = function()
			{
				if( $( _xml ).find( "font" ).length > 0 )
				{
					var _fonts = [];
					
					$( _xml ).find( "font" ).each( function( _key, _value ) {
						
						var _type = $.trim( $( _value ).parent().children( "type" ).text() );
						
						var _url = $.trim( $( _value ).text() );
						
						var _font = {
							"url" : _url,
							"type" : _type	
						};
						
						_fonts.push( _font );
							
					} );
					
					jsXml2Processing.util.preloadFonts( _fonts, _func );
				}
				else
				{
					_func();	
				}	
			};
			
			var _func2 = function() {
			
				if( $( _xml ).find( "image" ).length > 0 )
				{
					var _images = [];
					
					$( _xml ).find( "image" ).each( function( _key, _value ) {
						
						var _src = $.trim( $( _value ).text() );

						_images.push( _src );
							
					} );
					
					jsXml2Processing.util.preloadImages( _images, _func3 );
				}
				else
				{
					_func3();	
				}
			
			};
			
			jsXml2Processing.loadScripts( _xml, _func2 );
			
		}, "xml").fail( function( _jqxhr, _settings, _exception ) 
		{
			try
			{
				console.log( _exception );
			}
			catch( _ex ){}
			
			Grid _grid = new Grid( "xml2ProcessingErrorXmlLoad", null, color( 0 ), null, null, null, null, null, null );
			
			Text _text = new Text( "Error loading xml", "courier", 5, 1, 1, "xml2ProcessingErrorTextXmlLoad", null, 10, 10, 80, 40, color( 255 ), null, null );
			
			_grid.putXObject( _text );
			
			grids.add( _grid );
			
			isLoad = true; 
			
		} );
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
			
			Text _text = new Text( _attrs.string, _attrs.type, _attrs.size, _attrs.hAlign, _attrs.vAlign, _attrs.id, _attrs.className, _attrs.x, _attrs.y, _attrs.width, _attrs.height, _attrs.fColor, _attrs.visible, _attrs.focus );
			
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
			
			Line _line = new Line( _attrs.x2, _attrs.y2, _attrs.weight, _attrs.id, _attrs.className, _attrs.x, _attrs.y, _attrs.fColor, _attrs.visible, _attrs.focus );
			
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
			}, 
			{
				tag : "focus",
				type : "event"
			}, 
			{
				tag : "blur",
				type : "event"
			}, 
			{
				tag : "keypressed",
				type : "event"
			}, 
			{
				tag : "keyreleased",
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
				tag : "mousepressed",
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
				tag : "keyreleased",
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
			}, 
			{
				tag : "focus",
				type : "event"
			}, 
			{
				tag : "blur",
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
				tag : "x2",
				type : "float"
			},
			{ 
				tag : "y2",
				type : "float"
			},
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
			
				return Gradient.X_AXIS;
				
			return Gradient.Y_AXIS;
		},
		
		"gradientType" : function( _node )
		{
			if( ! $( _node ).text() || $.trim( $( _node ).text() ) == "" )
			
				return null;
				
			var _txt = $.trim( $( _node ).text() ).toUpperCase();
			
			if( _txt != "LINEAR" && _txt != "RADIAL" )
			
				return null;
				
			if( _txt == "RADIAL" )
			
				return Gradient.RADIAL;
				
			return Gradient.LINEAR;
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
		
		preloadImages : function( _arr, _func )
		{
			if( ! _arr || _arr.length <= 0 )
			{
				if( typeof( _func ) == "function" )
				
					_func();
					
				return;	
			}
			
			if( $.inArray( _arr[ 0 ], jsXml2Processing.loadedImages ) != -1 )
			{
				_arr.splice( 0, 1 );
				
				jsXml2Processing.util.preloadImages( _arr, _func );
				
				return;
			}
			
			jsXml2Processing.loadedImages.push( _arr[ 0 ] );
			
			var _code = '<img src="' + _arr[ 0 ] + '" />';
			
			$( _code ).load( function() {
				
				_arr.splice( 0, 1 );
				
				jsXml2Processing.util.preloadImages( _arr, _func );
				
			} ).error( function()
			{
				_arr.splice( 0, 1 );
				
				jsXml2Processing.util.preloadImages( _arr, _func );
				
			} );
		},
		
		preloadFonts : function( _arr, _func )
		{
			if( ! _arr || _arr.length <= 0 )
			{
				if( typeof( _func ) == "function" )
				
					_func();
					
				return;	
			}
			
			var _url = _arr[ 0 ][ "url" ];
			var _type = _arr[ 0 ][ "type" ];
			
			if( typeof( jsXml2Processing.chargedFonts[ _type ] ) != "undefined" && jsXml2Processing.chargedFonts[ _type ] )
			{
				_arr.splice( 0, 1 );
				
				jsXml2Processing.util.preloadFonts( _arr, _func );
				
				return;
			}
			
			$( "head" ).prepend( '<style type="text/css">' +
									'@font-face {'+
		    							"font-family: '" + _type + "';"+
		    							"src: url('" + _url + "');"+
										"}"+
										"</style>" );
			
			$.get( _url, "", function( _font ) {
				
				jsXml2Processing.chargedFonts[ _arr[ 0 ].type ] = true;
				
				_arr.splice( 0, 1 );
				
				jsXml2Processing.util.preloadFonts( _arr, _func );
				
			}, "text" ).fail( function() 
			{
				jsXml2Processing.chargedFonts[ _arr[ 0 ].type ] = true;
				
				_arr.splice( 0, 1 );
				
				jsXml2Processing.util.preloadFonts( _arr, _func );
			} );
		},
		
		colorRollover : function( _obj, _changeBColor, _changeFColor, _changeTypeGradient )
		{	
			if( _changeFColor && _obj.getFColor() != null )
			
				_obj.setFColor( jsXml2Processing.util.getRGBARollover( _obj.getFColor() ) );
			
			if( _changeBColor && _obj.getBColor() != null )
			
				_obj.setBColor( jsXml2Processing.util.getRGBARollover( _obj.getBColor() ) );
				
			if( ( _changeTypeGradient || _changeBColor ) && _obj.getBColor() != null && _obj.gradient != null && _obj.gradient.getGColor().size() > 0 )
			{
				ArrayList _newG = new ArrayList();
				
				if( _changeBColor )
				{
					for( int i = 0 ; i < _obj.gradient.getGColor().size() ; i++ )
				
						_newG.add( jsXml2Processing.util.getRGBARollover( _obj.gradient.getGColor().get( i ) ) );
				}
				else
				{
					_newG = _obj.gradient.getGColor();	
				}
					
				if( ! _changeTypeGradient )
				{
					_obj.setGColor( _newG );
				}	
				else
				{
					int _gType = Gradient.LINEAR;
					
					if( _obj.getGType() == Gradient.LINEAR )
					
						_gType = Gradient.RADIAL;
						
					_obj.setGType( _gType );
					_obj.setGColor( _newG );
				}	
			}				
		},
		
		getColorFromHex : function( _hex )
		{
			return jsXml2Processing.getAttrOfType.color( $( '<color>' + _hex + '</color>' ) );
		},
		
		getProcessingInstance : function()
		{
			var _processingInstance = Processing.getInstanceById( jsXml2Processing.config.id );
			
			return _processingInstance;
		},
		
		getFrameCount : function()
		{
			return frameCount;
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
		
		removeXObject : function( _obj )
		{
			if( ! _obj )
			
				return;
			
			if( typeof( _obj ) == "string" )
			{
				_obj = getXObject( _obj );
			}
			
			if( ! _obj )
			
				return;
				
			Grid _grid = _obj.getGrid();
			
			if( ! _grid )
			
				return;
				
			_grid.removeXObject( _obj );
		},
		
		addXObjectToGrid : function( _id, _obj, _callback )
		{
			if( ! _id || ! _obj )
			
				return;
				
			if( $.isArray( _obj ) )
			{
				for( var i = 0 ; i < _obj.length ; i++ )
				{
					if( i == ( _obj.length - 1 ) )
					
						jsXml2Processing.util.addSingleXObjectToGrid( _id, _obj[ i ], _callback );
						
					else
					
						jsXml2Processing.util.addSingleXObjectToGrid( _id, _obj[ i ] );
				}
			}
			else
			{	
				jsXml2Processing.util.addSingleXObjectToGrid( _id, _obj, _callback );
			}
		},
		
		addSingleXObjectToGrid : function( _id, _obj, _callback )
		{
			if( ! _id || ! _obj )
			
				return;
				
			Grid _grid = null;
			
			if( typeof( _id ) == "string" )
			
				_grid = getGrid( _id );
				
			else 
				
				_grid = _id.getGrid();
			
			if( _grid == null )
			
				return;
				
			var _x2js = new X2JS(); 
				
			var _xml = _x2js.json2xml( _obj );
			
			var _func = function() {
				
				XObject _new = jsXml2Processing.parseObject( $( _xml ).children()[ 0 ] );
				
				if( _new != null )
				{
					_grid.putXObject( _new );
				}
				
				if( typeof( _callback ) == "function" )
				
					_callback();
			};
			
			if( $( _xml ).find( "image" ).length > 0 )
			{
				var _images = [];
					
				$( _xml ).find( "image" ).each( function( _key, _value ) {
						
				var _src = $.trim( $( _value ).text() );

					_images.push( _src );
							
				} );
					
				jsXml2Processing.util.preloadImages( _images, _func );
			}
			else
			{
				_func();	
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
		
		fullPage : function()
		{
			var _idCanvas = jsXml2Processing.config.id;
			
			$( window ).scrollTop( 0 );
			$( window ).scrollLeft( 0 );
			$( window ).css( { "overflow" : "hidden" } );
			$( "body" ).scrollTop( 0 );
			$( "body" ).scrollLeft( 0 );
			$( "body" ).css( { "overflow" : "hidden" } );
			
			setTimeout( function() {
				var _canvas = $( "#" + jsXml2Processing.config.id );
				
				var _width = $( window ).width();
				var _height = $( window ).height();
				
				_canvas.attr( "width", _width );
			    _canvas.attr( "height", _height );
			    
			    _canvas.css( { "width" : _width + "px", "height" : _height + "px", position : "fixed", top : "0px", left : "0px", "z-index" : "1000000" } );
				
				 size( _width, _height );
			    
			    sWidth = _width;
			    sHeight = _height;
			    
			    $( window ).unbind( "resize", jsXml2Processing.util.fullPage );
			    $( window ).bind( "resize", jsXml2Processing.util.fullPage );
			    
			    
			}, 500 );
		},
		
		changeWidthAndHeight : function( _width, _height )
		{
			var _canvas = $( "#" + jsXml2Processing.config.id );
			
			if( _canvas.length <= 0 )
			
				return;
				
			_canvas.attr( "width", _width );
		    _canvas.attr( "height", _height );
		    
		    _canvas.css( { "width" : _width + "px", "height" : _height + "px" } );
		    
		    size( _width, _height );
		    
		    sWidth = _width;
		    sHeight = _height;
		},
		
		focus : function()
		{
			var _canvas = $( "#" + jsXml2Processing.config.id );
			
			_canvas.focus();
		}
	}
};