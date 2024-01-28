package gui 
{
	import flash.geom.Point;
	import globals.SoundPlayer;
	import gui.buttons.BasicButton;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author General
	 */
	public class FancyGuiController 
	{
		static public var controller:FancyGuiController;

		private var lastDownBitBtn:BasicButton;
		private var screenPt:Point = new Point();
		private var lastDownScreenPt:Point = new Point();
		public function FancyGuiController() 
		{
			controller = this;
		}
		
		public function handleTouch(e:TouchEvent, scrn:NewGameScreen):Boolean 
		{
			var tch:Touch = e.getTouch(scrn);
			
			if (tch){
				screenPt.x = tch.globalX;
				screenPt.y = tch.globalY;
				switch (tch.phase){
					case TouchPhase.ENDED:{
						if (lastDownBitBtn){
							lastDownBitBtn.setUpSate();
							lastDownBitBtn.performOnUpFunction();
							lastDownBitBtn = null;
							SoundPlayer.player.playNewSound("buttonUp");
						}						
						break;
					}
					case TouchPhase.HOVER:{
						releaseLastDownElem();		
						break;
					}
					case TouchPhase.MOVED:{
						if (lastDownBitBtn){
							lastDownBitBtn.performOnMoveFunction(screenPt);
						}
						break;
					}
					case TouchPhase.BEGAN:{
						lastDownScreenPt.copyFrom(screenPt);
						releaseLastDownElem();	
						if (tch.target is BasicButton){
							if ((tch.target as BasicButton).isEnabled){
								lastDownBitBtn = tch.target as BasicButton;
								lastDownBitBtn.performOnDownFunction();
								lastDownBitBtn.setDownState();
								SoundPlayer.player.playNewSound("buttonDown");
							}
						}	
						break;
					}
				}
				
			}else{
				releaseLastDownElem();
			}
			
			var res:Boolean = false;

			return res;			
		}		
		
		private function releaseLastDownElem():void 
		{
			if (lastDownBitBtn){
				lastDownBitBtn.setUpSate();
				lastDownBitBtn = null;
			}			
		}
		
	}

}