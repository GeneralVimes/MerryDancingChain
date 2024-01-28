package gameplay.controllers 
{
	import flash.geom.Rectangle;
	import service.TouchInfo;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author ...
	 */
	public class CheatController 
	{
		private var cheats:Vector.<CheatSequence>;

		public function CheatController() 
		{
			cheats = new Vector.<CheatSequence>();
			var ch:CheatSequence = new CheatSequence();
			cheats.push(ch);
			ch.registerRect(new Rectangle(0.9, 0, 0.1,1));
			ch.registerRect(new Rectangle(0.9, 0, 0.1, 1));			
			ch.registerRect(new Rectangle(0, 0, 0.1, 1));
			ch.registerRect(new Rectangle(0, 0, 0.1, 1));
			ch.registerRect(new Rectangle(0.9, 0, 0.1, 1));
			ch.registerRect(new Rectangle(0.9, 0, 0.1, 1));			
			ch.registerRect(new Rectangle(0.9, 0, 0.1, 1));
		}
		
		public function react2Resize():void{
			for (var i:int = 0; i < cheats.length; i++ ){
				cheats[i].setActualScreenSize(Main.self.sizeManager.gameWidth, Main.self.sizeManager.gameHeight);
			}
		}
		
		public function checkCheat(infoA:TouchInfo, infoB:TouchInfo):void 
		{
			if (infoA.isOnThisCheck){
				if (infoA.phase == TouchPhase.BEGAN){
					for (var i:int = 0; i < cheats.length; i++ ){
						cheats[i].checkTouchCoords(infoA.nowPoint.x, infoA.nowPoint.y);
						if (cheats[i].hasTriggered){
							performCheatOfId(i);
							cheats[i].hasTriggered = false;
						}
					}					
				}
			}else{
				for (i = 0; i < cheats.length; i++ ){
					cheats[i].reset();
				}
			}
		}
		
		private function performCheatOfId(id:int):void 
		{
			if (NewGameScreen.screen.currentWorld){
				NewGameScreen.screen.currentWorld.performCheatOfId(id);
			}
			
		}
		
	}

}