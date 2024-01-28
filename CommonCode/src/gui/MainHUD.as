package gui 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import gui.pages.InterfacePage;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class MainHUD 
	{
		private var pages:Vector.<InterfacePage>
		private var pagesByClass:Dictionary;
		
		private var msgBoxes:Vector.<MessageBox>;
		private var parSprite:DisplayObjectContainer;
		
		//private var gdprPage:GDPRPage;
		//private var preStartPage:PreStartPage;
		
		private var stackOfPreviousPages:Array = [];
		public function MainHUD(par:DisplayObjectContainer) 
		{
			msgBoxes = new Vector.<gui.MessageBox>();
			parSprite = par;
			
			pages = new Vector.<gui.pages.InterfacePage>();
			pagesByClass = new Dictionary();
			//gdprPage = createPage(GDPRPage);
			//preStartPage = createPage(PreStartPage);
		}
				
		public function hidePageOfClass(cls:Class):void{
			var pg:InterfacePage = pagesByClass[cls];
			if (pg){
				pg.hide();
			}
		}
		
		//stackMode 0 - обычный показ, стираем стек, 1 - добавляем предыдущую открытую в стек, чтобы вернуться в неё, 2 - возврат на 1 шаг в стеке, стек не стираем
		public function showPageOfClass(cls:Class, paramsOb:Object=null, stackMode:int=0):InterfacePage{
			var pg:InterfacePage = pagesByClass[cls];
			if (!pg){
				pg = createPage(cls);
			}
			showPage(pg, paramsOb, stackMode);
			return pg;
		}
		
		public function createPage(cls:Class):InterfacePage{
			var pg:InterfacePage = new cls();
			pg.myClass = cls;
			pages.push(pg);
			parSprite.addChild(pg);
			pg.visible = false;
			
			pagesByClass[cls] = pg;
			
			return pg;
		}
		
		//stackMode 0 - обычный показ, стираем стек, 1 - добавляем предыдущую открытую в стек, чтобы вернуться в неё, 2 - возврат на 1 шаг в стеке, стек не стираем
		public function showPage(pg:InterfacePage, paramsOb:Object=null, stackMode:int=0):void{
			for (var i:int = 0; i < pages.length; i++ ){
				var pg0:InterfacePage = pages[i];
				if (pg0!=pg){
					if (pg0.mustBClosedWhenAnotherOpens){
						if (pg0.visible){
							if (stackMode==1){
								stackOfPreviousPages.push({
									cls:pg0.myClass,
									params:pg0.getPreviouslyCalledParams()
								})
							}
							pg0.hide();
						}
					}
				}
			}
			if (stackMode==0){
				stackOfPreviousPages.length = 0;
			}
			parSprite.addChild(pg);
			pg.alignOnScreen();
			pg.show(paramsOb);
			//pg.alignOnScreen();
		}
		
		
		public function showPreviousInStack():void 
		{
			if (stackOfPreviousPages.length > 0){
				var ob:Object = stackOfPreviousPages[stackOfPreviousPages.length - 1];
				
				showPageOfClass(ob.cls, ob.params, 2)
				
				stackOfPreviousPages.splice(stackOfPreviousPages.length - 1, 1);
			}
		}		
		
		public function clearStack():void {
			stackOfPreviousPages.length = 0;
		}
		
		
		public function showColoredMessage(cap:String, colorsOb:Object, ansAr:Array, eftsAr:Array=null, iconsAr:Array=null, propsOb:Object=null):void 
		{
			var res:MessageBox = getOrCreateMessagebox(); 
			
			res.y = 150+Main.self.sizeManager.topMenuDelta;
			res.x = Main.self.sizeManager.gameWidth / 2;
			
			res.showColored(cap, colorsOb, ansAr, eftsAr, iconsAr, propsOb);
			parSprite.addChild(res);			
		}	
		
		public function showMessage(cap:String, txt:String, ansAr:Array, eftsAr:Array=null, iconsAr:Array=null, propsOb:Object=null):void{
			var res:MessageBox = getOrCreateMessagebox(); 
			
			res.y = 100+Main.self.sizeManager.topMenuDelta;
			res.x = Main.self.sizeManager.gameWidth / 2;
			
			res.show(cap, txt, ansAr, eftsAr, iconsAr, propsOb);
			parSprite.addChild(res);
		}
		
		private function getOrCreateMessagebox():MessageBox 
		{
			var res:MessageBox = null;
			for (var i:int = 0; i < msgBoxes.length; i++ ){
				if (!msgBoxes[i].visible){
					res = msgBoxes[i];
					break;
				}
			}
			if (!res){
				res = new MessageBox();
				msgBoxes.push(res);
				parSprite.addChild(res);
			}
			return res;
		}
		
		public function react2Resize():void 
		{
			for (var i:int = 0; i < msgBoxes.length; i++){
				if (msgBoxes[i].visible){
					msgBoxes[i].alignOnScreen();
				}
			}
			
			for (i = 0; i < pages.length; i++ ){
				var pg:InterfacePage = pages[i];
				if (pg.visible){
					pg.alignOnScreen();
				}
			}
		}
		
		public function clearPool():void 
		{
			for (var i:int = 0; i < msgBoxes.length; i++ ){
				msgBoxes[i].removeFromParent();
			}
			msgBoxes.length = 0;
			
			for (i = 0; i < pages.length; i++ ){
				pages[i].removeFromParent();
			}
			pages.length = 0;
			pagesByClass = new Dictionary();
			trace("numChildren=",parSprite.numChildren);
		}
		
		public function registerBaseDob(spr:starling.display.Sprite):void 
		{
			parSprite = spr;
		}
		
		public function getPageOfClass(cls:Class):InterfacePage 
		{
			return pagesByClass[cls];
		}
		
		public function hasOpenPageOfClass(cls:Class):Boolean{
			var res:Boolean = false;
			var pg:InterfacePage = pagesByClass[cls];
			if (pg){
				res = pg.visible;
			}
			return res;
		} 
		
		public function hasOpenPage():Boolean 
		{
			var res:Boolean = false;
			for (var i:int = 0; i < pages.length; i++ ){
				if (pages[i].visible&&!pages[i].skipsTutorialPreventingCheck){
					res = true;
					break;
				}
			}
			return res;
		}
		public function hasOpenMessage():Boolean{
			var res:Boolean = false;
			for (var i:int = 0; i < msgBoxes.length; i++ ){
				if (msgBoxes[i].visible){
					res = true;
					break;
				}
			}
			return res;			
		}
		
		public function closeAllMessages():void 
		{
			for (var i:int = 0; i < msgBoxes.length; i++ ){
				if (msgBoxes[i].visible){
					msgBoxes[i].close();
				}
			}
		}
		
		public function handleKeyboardEvent(e:flash.events.KeyboardEvent):Boolean 
		{
			
			var b:Boolean = false;
			for (var i:int = 0; i< msgBoxes.length; i++ ){
				if (msgBoxes[i].visible){
					b = b || msgBoxes[i].handleKeyboardEvent(e);
					if (b){
						break;
					}					
				}
			}
			if (!b){
				for (i = 0; i < pages.length; i++ ){
					if (pages[i].visible){
						b = b || pages[i].handleKeyboardEvent(e);
						if (b){
							break;
						}						
					}
				}
			}
			return b;
		}
		
		public function handleMouseWheel(e:flash.events.MouseEvent):Boolean 
		{
			var b:Boolean = false;
			for (var i:int = 0; i < pages.length; i++ ){
				if (pages[i].visible){
					b = b || pages[i].handleMouseWheel(e);
					if (b){
						break;
					}						
				}
			}
			return b;
		}
		
		public function stopUpdateTimers():void 
		{
			for (var i:int = 0; i < pages.length; i++ ){
				if (pages[i].visible){
					pages[i].pauseUpdatesTimer();
				}
			}			
		}
		
		public function runUpdateTimers():void 
		{
			for (var i:int = 0; i < pages.length; i++ ){
				if (pages[i].visible){
					pages[i].startUpdatesTimer();						
				}
			}			
		}



	}

}