package gui.pages 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ...
	 */
	public class UpdatedInterfacePage extends InterfacePage 
	{
		protected var updTimer:Timer;
		public function UpdatedInterfacePage() 
		{
			super();
			updTimer = new Timer(500, 0);
			updTimer.addEventListener(TimerEvent.TIMER, onUpdTimer);
		}
		
		private function onUpdTimer(e:TimerEvent):void 
		{
			updateView();
		}
		
		override public function show(paramsOb:Object):void 
		{
			super.show(paramsOb);
			updTimer.reset();
			updTimer.start();
			updateView();
		}
		
		override public function hide(mustShowPrevious:Boolean=false):void 
		{
			super.hide(mustShowPrevious);
			updTimer.stop();
		}
		
		public function updateView():void 
		{
			
		}

		override public function pauseUpdatesTimer():void{
			updTimer.stop();
		}
		override public function startUpdatesTimer():void{
			updTimer.reset();
			updTimer.start();
		}
		
	}

}