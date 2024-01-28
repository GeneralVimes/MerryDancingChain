package gui.pages 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import globals.StatsWrapper;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class InterfacePage extends Sprite
	{
		public var mustBClosedWhenAnotherOpens:Boolean = true;
		public var skipsTutorialPreventingCheck:Boolean = false;//не учитывать єто окно в isSomethingPreventingTutorial
		public var myClass:Class;
		protected var sizeWidth:Number;
		
		protected var previouslyCalledParams:Object;
		public function InterfacePage() 
		{
			sizeWidth = Main.self.sizeManager.fitterWidth - 140;
		}
		//в необновляемых страницах сначала вызывается alignOnScreen а потом show
		public function alignOnScreen():void 
		{
			sizeWidth = Main.self.sizeManager.fitterWidth - 140;
		}
		
		public function hide(mustShowPrevious:Boolean=false):void{
			visible = false;
			if (mustShowPrevious){
				NewGameScreen.screen.hud.showPreviousInStack();
			}
		}
		
		public function show(paramsOb:Object):void{
			initParamsFromObject(paramsOb);
			visible = true;
			StatsWrapper.stats.logTextWithParams("PageShown", this.myClass.toString());
		}
		
		public function handleKeyboardEvent(e:flash.events.KeyboardEvent):Boolean 
		{
			return false;
		}
		
		public function handleMouseWheel(e:flash.events.MouseEvent):Boolean 
		{
			return false;
		}
		
		protected function initParamsFromObject(paramsOb:Object):void 
		{
			previouslyCalledParams = paramsOb;
		}
		
		public function getPreviouslyCalledParams():Object{
			return previouslyCalledParams;
		}
		
		public function pauseUpdatesTimer():void{
			
		}
		
		public function startUpdatesTimer():void{
			
		}		

	}
}