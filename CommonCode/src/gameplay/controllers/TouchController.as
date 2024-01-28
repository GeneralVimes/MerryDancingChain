package gameplay.controllers 
{
	import flash.geom.Point;
	import gameplay.visual.VisibleWorld;
	import service.TouchInfo;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author ...
	 */
	public class TouchController 
	{
		private var senseSprite:Sprite;
		public var movedVisWorld:VisibleWorld;		
		private var touches:Vector.<Touch>;
		
		private var tchA:Touch;
		private var tchB:Touch;
		private var infoA:TouchInfo;
		private var infoB:TouchInfo;
		
		public var cheatController:CheatController
		public function TouchController() 
		{
			touches = new Vector.<starling.events.Touch>();
			
			infoA = new TouchInfo(0, this)
			infoB = new TouchInfo(1, this)
			cheatController = new CheatController();
			cheatController.react2Resize();
		}
		
		public function registerSenstitiveSprite(spr:Sprite):void 
		{
			senseSprite = spr;
		}
		
		public function registerMovedSprite(wrl:VisibleWorld):void 
		{
			movedVisWorld = wrl;
		}
		
		public function react2Touch(e:starling.events.TouchEvent):void 
		{
			touches.length = 0;
			e.getTouches(senseSprite, null, touches);
			//trace('touches:', touches);

			if (touches.length > 0){
				var tchA:Touch = touches[0];
				if (touches.length > 1){
					var tchB:Touch = touches[1];
				}else{
					tchB = null;
				}
			}else{
				tchA = null;
			}		
			
			infoA.initFromTouch(tchA);
			infoB.initFromTouch(tchB);//отсюда попадём в checkScaleAndMovePossibility
			cheatController.checkCheat(infoA, infoB)
		}
		
		//пока что здесь просто перетаскивание.
		//а как вам такой вид движения, когда тач близко к краю экрана?
		public function checkScaleAndMovePossibility():void 
		{
			if (infoA.canBUsed4ScreenDragging){
				if (infoB.canBUsed4ScreenDragging){
					try2ScaleOrMove(infoA.lastPoint, infoA.nowPoint, infoB.lastPoint, infoB.nowPoint)
				}else{
					try2Move(infoA.lastPoint, infoA.nowPoint);
				}
			}			
		}
		
		private function try2Move(lastPoint:Point, nowPoint:Point):void 
		{
			var dx:Number = nowPoint.x - lastPoint.x;
			var dy:Number = nowPoint.y - lastPoint.y;
			try2MoveByDelta(dx, dy);
		}
		
		private function try2ScaleOrMove(ptA0:Point,ptA1:Point,ptB0:Point,ptB1:Point):void 
		{
			//trace('try2ScaleOrMove',ptA0,ptA1,ptB0,ptB1)
			var Ax1:Number = ptA1.x;
			var Ax0:Number = ptA0.x;
			var Ay1:Number = ptA1.y;
			var Ay0:Number = ptA0.y;
			var Bx1:Number = ptB1.x;
			var Bx0:Number = ptB0.x;
			var By1:Number = ptB1.y;
			var By0:Number = ptB0.y;
			
			var dxA:Number = Ax1 - Ax0; 
			var dyA:Number = Ay1 - Ay0; 
			
			var dxB:Number = Bx1 - Bx0;
			var dyB:Number = By1 - By0;
			//Cc.log(dx, dy, dxB, dyB);
			var d0:Number = Routines.getDistBetweenPoints(Ax0, Ay0, Bx0, By0);
			var d1:Number = Routines.getDistBetweenPoints(Ax1, Ay1, Bx1, By1);
			
			var scalarProd:Number = dxA * dxB + dyA * dyB;
			
			var isScaling:Boolean = false;
			var ratio:Number = 1;
			if (d0 > 1){
				ratio = d1 / d0;
			}
			isScaling = scalarProd < 0;
			
			if (isScaling){
				changeVisWorldScale(ratio, (Ax1 + Bx1) / 2, (Ay1 + By1) / 2);
			}else{
				try2MoveByDelta((Ax1 + Bx1 - Ax0 - Bx0) / 2, (Ay1 + By1 - Ay0 - By0) / 2);
				//parBGD.getMovedBy(dx, dy);
			}
		}
		
		private function try2MoveByDelta(dx:Number, dy:Number):void 
		{
			movedVisWorld.setNewCoords(movedVisWorld.x + dx, movedVisWorld.y + dy);		
		}
		
		public function changeVisWorldScale(mod:Number, xNeutral:Number, yNeutral:Number):void 
		{
			var s0:Number = movedVisWorld.scale;
			var sMin:Number = movedVisWorld.getMinScale();
			var sMax:Number = movedVisWorld.getMaxScale();
			var s1:Number = movedVisWorld.scale * mod;
			
			s1 = Math.max(Math.min(s1, sMax), sMin);
			
			
			if (s1 != movedVisWorld.scale){
				var x0:Number = movedVisWorld.x;
				var y0:Number = movedVisWorld.y;
				var xc0:Number = (xNeutral - x0) / s0;
				var yc0:Number = (yNeutral - y0) / s0;
				var x1:Number = xNeutral - xc0 * s1 ;
				var y1:Number = yNeutral - yc0 * s1; 
				var dx:Number = x1 - movedVisWorld.x;
				var dy:Number = y1 - movedVisWorld.y;
				
				movedVisWorld.setNewCoordsAndScale(x1,y1,s1);				
			}	
		}		
		
		public function callWorldLongTap(inf:TouchInfo):void 
		{
			var sx:Number = inf.nowPoint.x;
			var sy:Number = inf.nowPoint.y;
			var wx:Number = movedVisWorld.scrX2World(sx);
			var wy:Number = movedVisWorld.scrY2World(sy);
			movedVisWorld.realWorld.callWorldLongTap(wx, wy, sx, sy, inf);
		}
		
		public function callWorldClick(inf:TouchInfo):void 
		{
			var sx:Number = inf.nowPoint.x;
			var sy:Number = inf.nowPoint.y;
			var wx:Number = movedVisWorld.scrX2World(sx);
			var wy:Number = movedVisWorld.scrY2World(sy);
			movedVisWorld.realWorld.callWorldClick(wx, wy, sx, sy, inf);			
		}
		
		public function callWorldDoubleClick(inf:TouchInfo):void 
		{
			var sx:Number = inf.nowPoint.x;
			var sy:Number = inf.nowPoint.y;
			var wx:Number = movedVisWorld.scrX2World(sx);
			var wy:Number = movedVisWorld.scrY2World(sy);
			movedVisWorld.realWorld.callWorldDoubleClick(wx, wy, sx, sy, inf);			
		}
		
		public function callWorldDown(inf:TouchInfo):void 
		{
			var sx:Number = inf.nowPoint.x;
			var sy:Number = inf.nowPoint.y;
			var wx:Number = movedVisWorld.scrX2World(sx);
			var wy:Number = movedVisWorld.scrY2World(sy);
			movedVisWorld.realWorld.callWorldDown(wx, wy, sx, sy, inf);			
		}
		
		public function callWorldUp(inf:TouchInfo):void 
		{
			var sx:Number = inf.nowPoint.x;
			var sy:Number = inf.nowPoint.y;
			var wx:Number = movedVisWorld.scrX2World(sx);
			var wy:Number = movedVisWorld.scrY2World(sy);
			movedVisWorld.realWorld.callWorldUp(wx, wy, sx, sy, inf);			
		}
		
		public function callWorldHover(inf:TouchInfo):void 
		{
			var sx:Number = inf.nowPoint.x;
			var sy:Number = inf.nowPoint.y;
			var wx:Number = movedVisWorld.scrX2World(sx);
			var wy:Number = movedVisWorld.scrY2World(sy);
			movedVisWorld.realWorld.callWorldHover(wx, wy, sx, sy, inf);			
		}	
		
		public function callWorldMove(inf:TouchInfo):void 
		{
			var sx:Number = inf.nowPoint.x;
			var sy:Number = inf.nowPoint.y;
			var wx:Number = movedVisWorld.scrX2World(sx);
			var wy:Number = movedVisWorld.scrY2World(sy);
			movedVisWorld.realWorld.callWorldMove(wx, wy, sx, sy, inf);			
		}	
		
		public function callWorldLeave():void 
		{
			movedVisWorld.realWorld.callWorldLeave();			
		}


	}

}