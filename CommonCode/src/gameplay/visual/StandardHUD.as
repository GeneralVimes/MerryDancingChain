package gameplay.visual 
{
	import gameplay.worlds.World;
	import globals.PlayersAccount;
	import gui.buttons.BasicButton;
	import gui.buttons.SmallButton;
	import gui.pages.BabelMenuPanel;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StandardHUD extends WorldHUD 
	{
		protected var menuButton:SmallButton;
		public function StandardHUD(par:DisplayObjectContainer, wrl:World) 
		{
			super(par, wrl);
		}
		
		override protected function createHudElements():void 
		{
			super.createHudElements();
						
			menuButton = new SmallButton(0);
			menuButton.setIconByCode("menu");
			menuButton.registerOnUpFunction(onMenuClick);
			parSpr.addChild(menuButton)			
		}
		
		override protected function alignElements():void 
		{
			super.alignElements();
			
			menuButton.x = Main.self.sizeManager.gameWidth - 36;
			menuButton.y = Main.self.sizeManager.topMenuDelta+40;
			
			screenNotificationsController.alignNotifications(menuButton.x, menuButton.y + 80, "down");
		}
		
		override public function showNotificationButtonIfNonexistent(code:String):void 
		{
			super.showNotificationButtonIfNonexistent(code);
			screenNotificationsController.alignNotifications(menuButton.x, menuButton.y + 80, "down");
		}	
		
		override protected function seldomUpdateInterface():void 
		{
			super.seldomUpdateInterface();
			if (!screenNotificationsController.hasNotificationOfCode("news")){
				if (NewGameScreen.screen.newsController.hasNewNews()){
					if (PlayersAccount.account.numLaunches>2){
						screenNotificationsController.createNotificationOfCode("news")
						screenNotificationsController.alignNotifications(menuButton.x, menuButton.y + 80, "down");						
					}
				}				
			}			
		}
		
		override public function hideAll():void 
		{
			super.hideAll();
			menuButton.visible = false;
		}
		
		override public function showAll():void 
		{
			super.showAll();
			menuButton.visible = true;
		}
		
		
		protected function onMenuClick(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(BabelMenuPanel, {world:this.myWorld});
		}		
	}

}