package gameplay.visual 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import gameplay.worlds.World;
	import gui.SpreadedCalculationsProgressInformer;
	import gui.buttons.SmallButton;
	import gui.pages.NewsPage;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author ...
	 */
	public class WorldHUD 
	{
		public var parSpr:DisplayObjectContainer;
		protected var myWorld:World
		protected var lastUpdatesTime:Number = 0;
		protected var currentTime:Number = 0;
		protected var screenNotificationsController:ScreenNotificationsController;
		protected var spreadedCalculationsProgressInformer:gui.SpreadedCalculationsProgressInformer;
	
		public var externalControlledObjects:Dictionary;//кнопки и прочие обхекты интерфейса, которые доступны из стейтов мира

		public function WorldHUD(par:DisplayObjectContainer, wrl:World) 
		{
			parSpr = par;
			myWorld = wrl;
			screenNotificationsController = new ScreenNotificationsController(this);
		
			externalControlledObjects = new Dictionary();
			
			createHudElements();
			
			alignElements();
		}
		
		protected function createHudElements():void 
		{
			spreadedCalculationsProgressInformer = new SpreadedCalculationsProgressInformer();
			spreadedCalculationsProgressInformer.visible = false;			
		}
		
		public function doAnimStep(dt:Number):void 
		{
			currentTime+= dt;
			if (currentTime-lastUpdatesTime >= 0.5){
				this.seldomUpdateInterface();
			}
			screenNotificationsController.doAnimStep(dt);
		}
		
		protected function seldomUpdateInterface():void 
		{

		}
		
		public function react2NewVisualizationCoords():void 
		{
			
		}
		
		public function react2NewVisualizationScale():void 
		{
			
		}
		
		public function react2Resize():void 
		{
			this.alignElements();
		}
		
		public function resetAfterRestart():void 
		{
		
		}
		
		public function showAll():void 
		{
			
		}
		public function hideAll():void 
		{
			spreadedCalculationsProgressInformer.visible = false;
		}
		
		public function addObject2Par(dob:DisplayObject):void 
		{
			parSpr.addChild(dob);
		}
		
		public function openNotificationFromButton(strVal:String, numVal:int):void 
		{
			if (strVal=="news"){
				NewGameScreen.screen.hud.showPageOfClass(NewsPage, {});
			}	
			if (strVal == "rate"){
				NewGameScreen.screen.playerRequestsController.showRateGameRequest();
			}			
		}
		
		public function showNotificationButtonIfNonexistent(code:String):void 
		{
			if (!screenNotificationsController.hasNotificationOfCode(code)){
				screenNotificationsController.createNotificationOfCode(code);
			}			
		}
		
		public function showSpreadedCalculationsProgress(numDone:int, numTotal:int):void 
		{
			if (numTotal > 0){
				spreadedCalculationsProgressInformer.showFraction(numDone/numTotal);
			}else{
				spreadedCalculationsProgressInformer.showFraction(1);
			}
		}
		public function showSpreadedCalculationsStart():void 
		{
			parSpr.addChild(spreadedCalculationsProgressInformer);
			spreadedCalculationsProgressInformer.visible = true;
			spreadedCalculationsProgressInformer.showFraction(0);
		}
		public function showSpreadedCalculationsEnd():void 
		{
			spreadedCalculationsProgressInformer.visible = false;
			spreadedCalculationsProgressInformer.removeFromParent();
		}
		
		protected function alignElements():void 
		{
			spreadedCalculationsProgressInformer.x = Main.self.sizeManager.gameWidth / 2;
			spreadedCalculationsProgressInformer.y = 100;			
		}
		
		public function placeObjectOnScreen(dob:DisplayObject):void 
		{
			parSpr.addChild(dob);
		}
		
		public function loadElementCoords2Point(pt:flash.geom.Point, elemCode:String):void 
		{
			pt.x = 0;
			pt.y = 0;
		}
		
	}

}