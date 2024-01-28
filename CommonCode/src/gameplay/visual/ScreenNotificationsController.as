package gameplay.visual 
{
	import gui.buttons.BasicButton;
	import gui.buttons.SmallButton;
	import service.UltimateTweener;
	/**
	 * ...
	 * @author ...
	 */
	public class ScreenNotificationsController 
	{
		private var myHud:WorldHUD;
		private var notificationButtons:Vector.<SmallButton>
		private var notificationDictOb:Object;
		private var twn:UltimateTweener;
		
		private var storedX0:Number=0;
		private var storedY0:Number=0;
		private var storedDir:String = "left";
		
		private var timeExisting:Number = 0;
		public function ScreenNotificationsController(hud:WorldHUD) 
		{
			myHud = hud;
			notificationButtons = new Vector.<gui.buttons.SmallButton>();
			notificationDictOb = {};
			twn = new UltimateTweener();
			twn.setTwnMode(UltimateTweener.MODE_THEREANDBACK);
		}
		
		public function hasNotificationOfCode(cd:String):Boolean 
		{
			return notificationDictOb.hasOwnProperty(cd);
		}
		
		public function createNotificationOfCode(cd:String):void 
		{
			if (notificationDictOb.hasOwnProperty(cd)){
				var btn:SmallButton = notificationDictOb[cd];
			}else{
				btn = new SmallButton(0,3,1);
				notificationDictOb[cd] = btn;
				notificationButtons.push(btn);
				btn.strVal = cd;
				btn.registerOnUpFunction(this.onNotificationButtonClick);
				myHud.addObject2Par(btn);
			}
		}
		
		private function onNotificationButtonClick(b:BasicButton):void 
		{
			myHud.openNotificationFromButton(b.strVal, b.numVal);
			b.visible = false;
			alignNotifications(storedX0, storedY0, storedDir);
		}
		
		public function alignNotifications(x0:Number, y0:Number, dir:String):void{
			storedDir = dir;
			storedX0 = x0;
			storedY0 = y0;
			//dir: left, right, up, down
			var dx:Number = 0;
			var dy:Number = 0;
			switch (dir){
				case "left":{
					dx = -100;
					break;
				}
				case "right":{
					dx = 100;
					break;
				}
				case "up":{
					dy = -100;
					break;
				}
				case "down":{
					dy = 100;
					break;
				}
			}
			for (var i:int = 0; i < notificationButtons.length; i++ ){
				notificationButtons[i].x = x0 + dx * (i+1);
				notificationButtons[i].y = y0 + dy * (i+1);
			}
		}
		
		public function doAnimStep(dt:Number):void 
		{
			var oldTime:Number = timeExisting;
			timeExisting += dt;
			if (Math.floor(oldTime/10)!=Math.floor(timeExisting/10)){
				var btn:SmallButton = getRandomVisibeButton();
				if (btn){
					twn.tweenItem2State(btn, 24, -100000, -100000, -100000, -100000, 1, -100000, 1.5);
				}
			}
		}
		
		private function getRandomVisibeButton():SmallButton 
		{
			var res:SmallButton = null;
			var n:int = 0;
			for (var i:int = 0; i < notificationButtons.length; i++ ){
				var b:SmallButton = notificationButtons[i];
				if (b.visible){
					n++;
					if (Math.random()<1/n){
						res = b;
					}
				}
			}
			return res;
		}
	}
}