package service
{
	import starling.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	/**
	 * ...
	 * @author General
	 */
	public class UltimateTweener extends EventDispatcher
	{
		public static const MODE_LINEAR:int = 1;
		public static const MODE_ACCELERATE:int = 2;
		public static const MODE_DECCELERATE:int = 3;
		public static const MODE_LOGISTICCURVE:int = 4;
		public static const MODE_THEREANDBACK:int = 5;
		public static const MODE_SLIGHTOVERRUN:int = 6;
		static public const MODE_KWAVESTHEREANDBACK:int = 7;
		static public const MODE_SLIGHTBACK:int = 8;
		static public const MODE_BYARRAY:int = 9;
		
		
		
		private var tweenX:Boolean;
		private var tweenY:Boolean;
		private var tweenW:Boolean;
		private var tweenH:Boolean;
		private var tweenRot:Boolean;
		private var tweenAlpha:Boolean;
		private var tweenScale:Boolean;		
		
		private var tweenedObject:DisplayObject;
		
		private var x0:int;
		private var y0:int;
		private var w0:int;
		private var h0:int;
		private var rot0:Number;
		private var alpha0:Number;
		private var scale0:Number;
		
		private var x1:int;
		private var y1:int;
		private var w1:int;
		private var h1:int;
		private var rot1:Number;
		private var alpha1:Number;
		private var scale1:Number;
		
		private var lambdaTime:Number;
		private var lambdaTimeStep:Number;
		
		private var lambdaVal:Number;
		private var lambdaStep:Number;
		
		private var beforeStartDelay:int;
		private var tweenMode:int = 1;
		
		
		private var numWaves2Make:Number;
		private var reciprocal:Number;
		private var sqCoef:Number;
		private var frameTimer:Timer;
		
		private var labmdaVector:Vector.<Number>;
		private var labmdaVectorLen:int;
		private var recLabmdaVectorLen:Number;
		
		private var cbFunc:Function;
		public function UltimateTweener() 
		{
			frameTimer = new Timer(1000 / 60);
			labmdaVector = new Vector.<Number>();
		}
		
		public function setWaves2Make(w:Number):void {
			numWaves2Make = w;
			reciprocal = 1 / numWaves2Make;
			sqCoef = 4 / (reciprocal * reciprocal);
		}
		
		public function setTwnMode(md:int):void {
			tweenMode = md;
		}
		
		public function setDelayBeforeStart(frms:int):void {
			beforeStartDelay = frms;
		}
		
		public function tweenItem2State(itm:DisplayObject, frms:int, newx:int = -100000, newy:int = -100000, neww:int = -100000, newh:int = -100000,
		newRot:Number = -100000, newAlpha:Number = -100000, newScl:Number = -100000):void {
			//trace('tweenItem2State', frms, tweenMode);
			if (tweenedObject) {//бросаем предыдущий
				
			}
			
			tweenedObject = itm;
			lambdaVal = lambdaTime = 0;
			if (frms > 1) {
				lambdaTimeStep = 1 / frms;
			}
			else {
				lambdaTimeStep = 1;
			}
			
			if (newx != -100000) {
				tweenX = true;
				x0 = itm.x;
				x1 = newx;
			}
			else {
				tweenX = false;
			}
			
			if (newy != -100000) {
				tweenY = true;
				y0 = itm.y;
				y1 = newy;
			}
			else {
				tweenY = false;
			}
			
			if (neww != -100000) {
				tweenW = true;
				w0 = itm.width;
				w1 = neww;
			}
			else {
				tweenW = false;
			}
			
			if (newh != -100000) {
				tweenH = true;
				h0 = itm.height;
				h1 = newh;
			}
			else {
				tweenH = false;
			}
			
			if (newRot != -100000) {
				tweenRot = true;
				rot0 = itm.rotation;
				rot1 = newRot;
			}
			else {
				tweenRot = false;
			}
			
			if (newAlpha != -100000) {
				tweenAlpha = true;
				alpha0 = itm.alpha;
				alpha1 = newAlpha;
			}
			else {
				tweenAlpha = false;
			}			
			
			if (newScl != -100000) {
				tweenScale = true;
				scale0 = itm.scaleX;
				scale1 = newScl;
			}
			else {
				tweenScale = false;
			}
			//trace('setting up parameters')
			
			frameTimer.stop();
			//frameTimer.repeatCount = frms;
			frameTimer.reset();
			//if (!hasEventListener(EnterFrameEvent.ENTER_FRAME)) {
				////trace('adding listener')
				//addEventListener(EnterFrameEvent.ENTER_FRAME, onFrame);
			//}				
			
			if (!frameTimer.hasEventListener(TimerEvent.TIMER)) {
				//trace('adding listener')
				frameTimer.addEventListener(TimerEvent.TIMER, onFrame);
			}			
			frameTimer.start();
		}
		
		public function isTweening():Boolean{
			return frameTimer.running;
		}
		
		public function cancelTweening():void 
		{

			
			frameTimer.stop();
			if (frameTimer.hasEventListener(TimerEvent.TIMER)) {
				frameTimer.removeEventListener(TimerEvent.TIMER, onFrame);
			}				
			beforeStartDelay = 0;
			tweenedObject = null;
		}
		
		
		private function onFrame(e:TimerEvent=null):void 
		{
			if (cbFunc){
				cbFunc();
			}			
			//trace('onFrame');
			if (beforeStartDelay == 0) {
				tweenStep();//отсюда потом выйдет комплишен ивент
			}else {
				beforeStartDelay--;
			}
			

		}
		
		private function tweenStep():void {
			
			lambdaTime += lambdaTimeStep;
			
			if (lambdaTime >= 1) {
				lambdaTime = 1;
			}
			
			lambdaVal = calcValOfTimeAndMode(lambdaTime, tweenMode);
			//trace('tweenStep',tweenMode, lambdaTime, lambdaVal);
			
			if (tweenX) {tweenedObject.x = x0 + lambdaVal * (x1-x0);}
			if (tweenY) {tweenedObject.y = y0 + lambdaVal * (y1-y0);}
			if (tweenH) {tweenedObject.height = h0 + lambdaVal * (h1-h0);}
			if (tweenW) {tweenedObject.width = w0 + lambdaVal * (w1-w0);}
			if (tweenRot) {tweenedObject.rotation = rot0 + lambdaVal * (rot1-rot0);}
			if (tweenAlpha) {tweenedObject.alpha = alpha0 + lambdaVal * (alpha1-alpha0);}
			if (tweenScale) {tweenedObject.scaleX = tweenedObject.scaleY = scale0 + lambdaVal * (scale1-scale0);}

			
			if (lambdaTime >= 1) {
				frameTimer.stop();
				frameTimer.removeEventListener(TimerEvent.TIMER, onFrame);
				//removeEventListener(EnterFrameEvent.ENTER_FRAME, onFrame);
				tweenedObject = null;
				dispatchEvent(new Event(Event.COMPLETE));
			}			
			
		}
		
		public function registerLabmdasVector(...rest):void {
			labmdaVectorLen = rest.length-1;
			for (var i:int = 0; i <= labmdaVectorLen; i++) 
			{
				labmdaVector[i] = rest[i];
			}
			
			recLabmdaVectorLen = 1 / labmdaVectorLen;
		}
		
		public function setFramesSpeed(frms:int):void 
		{
			if (frms > 1) {
				lambdaTimeStep = 1 / frms;
			}
			else {
				lambdaTimeStep = 1;
			}
		}
		
		public function registerFrameCallBack(f:Function):void 
		{
			cbFunc = f;
		}
		
		private function calcValOfTimeAndMode(tm:Number, md:int):Number
		{
			var res:Number = 0;
			switch(md) {
				case MODE_ACCELERATE: {
					res = tm * tm;
					break;
				}
				case MODE_DECCELERATE: {
					res = tm * (2 - tm);
					//trace('MODE_DECCELERATE', tm, res)
					break;
				}
				case MODE_LINEAR: {
					res = tm;
					break;
				}
				case MODE_LOGISTICCURVE: {
					res = (tm < 0.5)?(2 * tm * tm):(1 - 2 * (1 - tm) * (1 - tm));
					break;
				}
				case MODE_THEREANDBACK: {
					res = 4 * tm * (1 - tm);
					break;
				}				
				case MODE_SLIGHTOVERRUN: {
					res = 2.2222222 * tm * (1.45 - tm);
					break;
				}				
				case MODE_KWAVESTHEREANDBACK: {
					//trace('mode=MODE_KWAVESTHEREANDBACK')
					var tm0:Number = tm;
					
					while (tm0 > reciprocal) {
						tm0 -= reciprocal;
					}
					res = sqCoef * tm0 * (reciprocal - tm0);
					break;
				}
				case MODE_SLIGHTBACK: {
					res = 2.5 * tm * (tm-0.6);
					break;
				}					
				case MODE_BYARRAY: {
					
					var vid:int = int(labmdaVectorLen * tm);
					if (vid == labmdaVectorLen) {
						res = labmdaVector[labmdaVectorLen];
					}
					else {
						tm0 = tm - recLabmdaVectorLen * vid;
						var l1:Number = tm0 * labmdaVectorLen;
						res = labmdaVector[vid] * (1 - l1) + labmdaVector[vid + 1] * l1;
					}
					//trace('MODE_BYARRAY', tm, vid, l1, res)
					break;
				}					
			}
			return res;
		}
		
	}

}