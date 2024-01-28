package gameplay.visual 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;


	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import gameplay.worlds.World;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class VisibleWorld extends Sprite
	{
		public var maxScale:Number = 2;
		public var minScaleVal:Number = 0.1;
		
		private var mostTopPt:Number = 0;
		private var mostLeftPt:Number = 0;
		private var mostRightPt:Number = 0;
		private var mostBottomPt:Number = 0;		
		
		
		public var layersAr:Array = [];
		//private var parallaxedGameObjects:Vector.<BasicGameObject>;
		//private var unMovedBackObjects:Vector.<UnmovedBackObject>;
		public var sprite4UnmovedBackObjects:DisplayObjectContainer;
		private var topField4Inerface:Number=100;
		private var botField4Inerface:Number=200;
		private var leftField4Inerface:Number=100;
		private var rightField4Inerface:Number=200;
		public var wrapX:Number=0; //зацикливание карты при прокрутке по горизонтали
		public var wrapY:Number=0; //зацикливание карты при прокрутке по вертикалн
		public var screenRectInWorld:Rectangle = new Rectangle();
		public var screenRectWithFieldsInWorld:Rectangle = new Rectangle();
		public var screenRectOnScreen:Rectangle = new Rectangle();
		
		public var realWorld:World;
		public function VisibleWorld(wrl:World) 
		{
			for (var i:int = 0; i < 8; i++){
				var spr:Sprite = new Sprite();
				layersAr.push(spr);
				addChild(spr);
			}
			realWorld = wrl;
			updateScreenRectOnScreen();
			updateScreenRectInWorld();
		}
		
		public function updateScreenRectOnScreen():void 
		{
			screenRectOnScreen.right = Main.self.sizeManager.gameWidth;
			screenRectOnScreen.bottom = Main.self.sizeManager.gameHeight;			
		}
		
		public function registerUnmovedBackSprite(spr:DisplayObjectContainer):void 
		{
			sprite4UnmovedBackObjects = spr;
		}	
		
		public function getLayerOfId(lid:int):Sprite 
		{
			return layersAr[lid];
		}
		
		public function wrlX2Screen(wx:Number):Number{
			return wx * this.scale+this.x;
		}
		
		public function wrlY2Screen(wy:Number):Number{
			return wy * this.scale+this.y;
		}
		
		public function scrX2World(sx:Number):Number{
			return (sx - this.x) / this.scale;
		}
		
		public function scrY2World(sy:Number):Number{
			return (sy - this.y) / this.scale;
		}
		
		public function setMaxVievedZoneFromRect(rct:Rectangle):void 
		{
			mostLeftPt = rct.left;
			mostRightPt = rct.right;
			mostTopPt = rct.top;
			mostBottomPt = rct.bottom;
		}		
		
		public function setNewCoords(x1:Number, y1:Number):void 
		{			
			var x0:Number = x;
			var y0:Number = y;
			
			x = x1;
			y = y1;
			
			var errLeft:Boolean = wrlX2Screen(mostLeftPt) > 0+leftField4Inerface;
			var errRight:Boolean = wrlX2Screen(mostRightPt) < Main.self.sizeManager.gameWidth-rightField4Inerface;
			var errTop:Boolean = wrlY2Screen(mostTopPt) > 0+topField4Inerface;
			var errBottom:Boolean = wrlY2Screen(mostBottomPt) < Main.self.sizeManager.gameHeight-botField4Inerface;

			if (errLeft){
				this.x -= wrlX2Screen(mostLeftPt)-leftField4Inerface;
			}			
			if (errRight){
				this.x += Main.self.sizeManager.gameWidth-wrlX2Screen(mostRightPt)-rightField4Inerface;
			}			
			
			if (errTop){
				this.y -= wrlY2Screen(mostTopPt)-topField4Inerface;
			}			
			if (errBottom){
				this.y += Main.self.sizeManager.gameHeight-wrlY2Screen(mostBottomPt)-botField4Inerface;
			}
		
			//if (mustAnimate){
			//	var tX:Number = x;
			//	var tY:Number = y;
			//	x = x0;
			//	y = y0;
			//	moveAnimationTween.cancelTweening();
			//	moveAnimationTween.tweenItem2State(this, 10, tX, tY);
			//}
			if (wrapX > 0){
				var offset:Number = wrapX * this.scale;
				//trace('x:', x, 'offset:', offset);
				if (this.x > 0){
					this.x -= offset;
					//trace('x -- now:', x);
				}
				if (this.x<-offset){
					this.x += offset;
					//trace('x ++ now:', x);
				}					
			}
			if (wrapY > 0){
				offset = wrapY * this.scale;
				//trace('x:', x, 'offset:', offset);
				if (this.y > 0){
					this.y -= offset;
					//trace('x -- now:', x);
				}
				if (this.y<-offset){
					this.y += offset;
					//trace('x ++ now:', x);
				}					
			}
	
			updateScreenRectInWorld()
			//setBGDParallaxAtNewCoords();
			//updPointingArrows2OffscreenVisMarkers();
			realWorld.react2NewVisualizationCoords();
		}		
		
		public function adjustScaleIfExceedsMinMax(scl:Number):Number 
		{
			return Math.max(Math.min(scl,  getMaxScale()), getMinScale());			
		}
		
		public function setNewCoordsAndScale(x1:Number, y1:Number, s1:Number):void 
		{
			//trace('setNewCoordsAndScale', s1);
			//проверка на границы масштаба сделана перед входом сюда
			//trace('trying setNewCoordsAndScale:', x1, y1, s1);			
			x = x1;
			y = y1;
			scale = s1;
			
			var errLeft:Boolean = wrlX2Screen(mostLeftPt) > 0+leftField4Inerface;
			var errRight:Boolean = wrlX2Screen(mostRightPt) < Main.self.sizeManager.gameWidth-rightField4Inerface;
			var errTop:Boolean = wrlY2Screen(mostTopPt) > 0+topField4Inerface;
			var errBottom:Boolean = wrlY2Screen(mostBottomPt) < Main.self.sizeManager.gameHeight-botField4Inerface;			
			
			if (errLeft){
				this.x -= wrlX2Screen(mostLeftPt)-leftField4Inerface;
			}			
			if (errRight){
				this.x += Main.self.sizeManager.gameWidth-wrlX2Screen(mostRightPt)-rightField4Inerface;
			}			
			
			if (errTop){
				this.y -= wrlY2Screen(mostTopPt)-topField4Inerface;
			}			
			if (errBottom){
				this.y += Main.self.sizeManager.gameHeight-wrlY2Screen(mostBottomPt)-botField4Inerface;
			}
			
			if (wrapX > 0){
				var offset:Number = wrapX * this.scale;
				//trace('x:', x, 'offset:', offset);
				if (this.x > 0){
					this.x -= offset;
					//trace('x -- now:', x);
				}
				if (this.x<-offset){
					this.x += offset;
					//trace('x ++ now:', x);
				}					
			}
			if (wrapY > 0){
				offset = wrapY * this.scale;
				//trace('x:', x, 'offset:', offset);
				if (this.y > 0){
					this.y -= offset;
					//trace('x -- now:', x);
				}
				if (this.y<-offset){
					this.y += offset;
					//trace('x ++ now:', x);
				}					
			}			
			updateScreenRectInWorld();
		//	setBGDParallaxAtNewCoords();
		//	updPointingArrows2OffscreenVisMarkers();
		//	adjustInterfaceButtonsScales2LookTheSame();
			realWorld.react2NewVisualizationScale();
			realWorld.react2NewVisualizationCoords();
		}	
		
		public function showWorldPointAtScreenCenter(SCX:int, SCY:int):void{
			var mx:Number = (Main.self.sizeManager.gameWidth/2 - SCX*this.scale)
			var my:Number = (Main.self.sizeManager.gameHeight / 2 -SCY * this.scale)

			setNewCoords(mx, my);
		}		
		
		public function getMinScale():Number
		{
			//что если на экран выходит картинка шире, чем нарисованный мир?
			var wCoef:Number = (mostRightPt - mostLeftPt+leftField4Inerface+rightField4Inerface) / Main.self.sizeManager.gameWidth;
			
			//что если на экран выходит картинка выше, чем нарисованный мир?
			var hCoef:Number = (mostBottomPt - mostTopPt+topField4Inerface+botField4Inerface) / Main.self.sizeManager.gameHeight;

			
			var sCoef:Number = Math.min(wCoef, hCoef);
			//если поставить max, будет показываться вся карта целиком. 
			//вот только будут непонятные прыжки
			
			var res:Number = (1 / sCoef)
			if (res < minScaleVal){
				res = minScaleVal;
			}
			
			return res;
		}
		public function getMaxScale():Number
		{
			return maxScale;
		}
		
		public function initFields4Interface(fields4Interface:Object):void 
		{
			leftField4Inerface = fields4Interface.left;
			topField4Inerface = fields4Interface.top;
			rightField4Inerface = fields4Interface.right;
			botField4Inerface = fields4Interface.bottom;
		}
		
		public function getWorldPointAtScreenCenter():Point 
		{
			return new Point(scrX2World(Main.self.sizeManager.gameWidth/2), scrY2World(Main.self.sizeManager.gameHeight/2))
		}
		
		public function addUnmovedSprite(spr:DisplayObject):void 
		{
			sprite4UnmovedBackObjects.addChild(spr)
		}

		
		private function updateScreenRectInWorld():void 
		{
			screenRectInWorld.left = scrX2World(0);
			screenRectInWorld.right = scrX2World(Main.self.sizeManager.gameWidth);
			screenRectInWorld.top = scrY2World(0);
			screenRectInWorld.bottom = scrY2World(Main.self.sizeManager.gameHeight);
			
			screenRectWithFieldsInWorld.left = scrX2World(-100);
			screenRectWithFieldsInWorld.right = scrX2World(Main.self.sizeManager.gameWidth+100);
			screenRectWithFieldsInWorld.top = scrY2World(-100);
			screenRectWithFieldsInWorld.bottom = scrY2World(Main.self.sizeManager.gameHeight+100);			
		}		
	}

}