package gui.buttons 
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class BasicButton extends Sprite
	{
		public var isEnabled:Boolean = true;
		private var upFunction:Function;//BasicButton
		private var downFunction:Function;//BasicButton
		private var moveFunction:Function;//BasicButton, screePoint
		
		public var numVal:int;
		public var strVal:String;
		
		private var upTimer:Timer;
		public function BasicButton() 
		{
			upTimer = new Timer(200, 1);
			upTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onUpTimer);
		}

		
		public function getExtendedBounds(targetSpace:DisplayObject, out:Rectangle = null):Rectangle {
			var rct:Rectangle = getBounds(targetSpace, out);
			rct.left -= 10;
			rct.right += 10;
			rct.top -= 10;
			rct.bottom += 10;
			return rct;
		}
		
		public function setUpSate():void 
		{
			
		}
		
		public function setDownState():void 
		{
			
		}		
		
		public function performOnUpFunction():void 
		{
			if (this.upFunction){
				this.upFunction(this);
			}
		}
		
		public function performOnDownFunction():void 
		{
			if (this.downFunction){
				this.downFunction(this);
			}
		}
		
		public function performOnMoveFunction(screenPt:flash.geom.Point):void 
		{
			if (this.moveFunction){
				this.moveFunction(this, screenPt);
			}			
		}
		
		public function registerOnDownFunction(func:Function):void{
			this.downFunction = func;
		}
		public function registerOnUpFunction(func:Function):void{
			this.upFunction = func;
		}
		public function registerOnMoveFunction(func:Function):void{
			this.moveFunction = func;
		}
		
		public function animDownAndUp():void{
			this.setDownState();
			upTimer.reset();
			upTimer.start();
		}
		
		
		private function onUpTimer(e:TimerEvent):void 
		{
			setUpSate();
		}		
	}

}