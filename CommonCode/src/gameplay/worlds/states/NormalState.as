package gameplay.worlds.states 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import gameplay.worlds.World;
	import service.TouchInfo;
	/**
	 * ...
	 * @author ...
	 */
	public class NormalState extends WorldState
	{
		
		public function NormalState(wrl:World) 
		{
			super(wrl);
		}
		override public function callWorldMove(wx:Number, wy:Number, sx:Number, sy:Number, inf:TouchInfo):void 
		{
			super.callWorldMove(wx, wy, sx, sy, inf);
			//пример: мир перетаскивается только если курсор - в левой части экрана
			//sif (sx >= Main.self.sizeManager.gameWidth / 2){
			//s	inf.canBUsed4ScreenDragging = false;
			//s}
		}
		override public function handleKeyboardEent(e:flash.events.KeyboardEvent):Boolean 
		{
			var res:Boolean = super.handleKeyboardEent(e);
			

			if (!res){
				if (e.keyCode == Keyboard.Z){
					res = true;
					NewGameScreen.screen.touchController.changeVisWorldScale(0.95, Main.self.sizeManager.gameWidth / 2,Main.self.sizeManager.gameHeight / 2);
					
				}
				if (e.keyCode == Keyboard.X){
					res = true;
					NewGameScreen.screen.touchController.changeVisWorldScale(1.05, Main.self.sizeManager.gameWidth / 2,Main.self.sizeManager.gameHeight / 2);
					
				}
				if (e.keyCode == Keyboard.C){
					res = true;
					this.myWorld.hud.hideAll();
				}
				if (e.keyCode == Keyboard.V){
					res = true;
					this.myWorld.hud.showAll();
				}
			}
			
			return res;
		}
		override public function handleMouseWheel(e:MouseEvent):Boolean 
		{
			var res:Boolean = super.handleMouseWheel(e);
			if (Math.abs(e.delta) >= 3){
				var cx:Number = Main.self.sizeManager.gameWidth * e.stageX / Main.self.sizeManager.screenW;
				var cy:Number = Main.self.sizeManager.gameHeight * e.stageY / Main.self.sizeManager.screenH;					
				if (e.delta < 0){
					NewGameScreen.screen.touchController.changeVisWorldScale(0.90, cx, cy);
				}else{
					NewGameScreen.screen.touchController.changeVisWorldScale(1.10, cx, cy);
				}
			}
			return res;
		}		
	}

}