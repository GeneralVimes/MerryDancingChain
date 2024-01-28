package gui.pages 
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import gameplay.worlds.World;
	import globals.MenuCommandsPerformer;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	/**
	 * ...
	 * @author ...
	 */
	public class CodeEnterPage extends InterfacePage 
	{
		private var bgd:gui.elements.NinePartsBgd;
		private var closeBtn:gui.buttons.SmallButton;
		private var isCapClear:Boolean = true;
		
		private var myWorld:World;
		private var bigCap:gui.text.MultilangTextField;
		private var cap:gui.text.MultilangTextField;
		private var resTxt:gui.text.MultilangTextField;
		
		private var numCheatClicks:int = 0;
		public function CodeEnterPage() 
		{
			super();
			bgd = new NinePartsBgd();
			addChild(bgd);
			bgd.alpha = 0.8;
			
			closeBtn = new SmallButton(0);
			closeBtn.setIconByCode("close")
			closeBtn.registerOnUpFunction(this.closeBtnHandler);
			addChild(closeBtn);
			closeBtn.x = Main.self.sizeManager.fitterWidth*0.5-70
			closeBtn.y = 0
			this.bigCap = new MultilangTextField("TXID_CAP_BREAKCODE", 0, 20, sizeWidth-40, 1, 1, 0xffffff, "center", "scale", true, true);
			
			
			this.cap = new MultilangTextField("TXID_CAP_ENTERCODE", -sizeWidth/2+30, 40+50, sizeWidth-250, 1, 1, 0xffffff, "left", "scale", true, true);
			addChild(cap);
			this.resTxt = new MultilangTextField("", -sizeWidth/2+30, 100+50, sizeWidth-250, 2, 1, 0xffff00, "left", "scale", true, true);
			addChild(resTxt);
			var okBtn:BitBtn = Routines.buildBitBtn('OK', -1, this, onOkClick, sizeWidth / 2 - 140, 40+50);
			var delBtn:BitBtn = Routines.buildBitBtn('DEL', -1, this, onDelClick, sizeWidth / 2 - 140, 100+50);
			okBtn.setBaseWidth(150);
			delBtn.setBaseWidth(150);
			var smbArs:Array = [
				"1234567890","QWERTYUIOP","ASDFGHJKL","ZXCVBNM"
			]
			var cy:int = 0;
			for (var i:int = 0; i < smbArs.length; i++ ){
				var str:String = smbArs[i];
				for (var j:int = 0; j < str.length; j++ ){
					var ch:String = str.charAt(j);
					cy = this.resTxt.y + 20 + 65+50 + i * 55;
					var btn:BitBtn = Routines.buildBitBtn(ch, -1, this, typeSymbol, (j - str.length / 2 + 0.5) * 60, cy);
					btn.setBaseHeight(50);
					btn.setBaseWidth(55);
				}
			}
			cy += 50;
			if (Main.self.config.platform == 'Apple'){
				addChild(bigCap);
				
				var explCap:MultilangTextField = new MultilangTextField("TXID_CAP_FINDHINTS", 0, cy + 20, sizeWidth - 40, 1, 1, 0xffffff, "center", "scale", true, true);
				addChild(explCap);
				cy = explCap.y + explCap.getTextHeight();				
			}
			var discorBtn:BitBtn = Routines.buildBitBtn(Main.self.config.platform=='Apple'?'TXID_CAP_INDISCORD':'TXID_CAP_GETMORECODESINDISCORD', -1, this, onDiscordClick, 0, cy+20);
			discorBtn.setBaseWidth(500);
			cy += 50;
			bgd.setDims(sizeWidth, cy+20);
		}
		
		private function onDelClick(b:BasicButton):void 
		{
			if (!this.isCapClear){
				var str:String = cap.getCurrentText();
				if (str.length==1){
					this.clearCaption();
				}else{
					cap.showText(str.substr(0, str.length - 1));
				}
			}else{
				this.clearCaption();
				numCheatClicks++;
				if (numCheatClicks==10){
					numCheatClicks = 0;
					this.myWorld.codeBonusesController.generateNewCodes();
				}
			}
			resTxt.showText('');
		}
		
		private function clearCaption():void 
		{
			this.isCapClear = true;
			this.cap.showText("TXID_CAP_ENTERCODE");
		}
		
		private function onOkClick(b:BasicButton):void 
		{
			var code:String = cap.getCurrentText();
			var res:String = myWorld.codeBonusesController.handleCodeChecking(code);
			if (res=="OK"){
				clearCaption();
			}
			resTxt.showText(res);
		}
		
		private function onDiscordClick(b:BasicButton):void 
		{
			MenuCommandsPerformer.self.openLinkByCode("discordcodes");
		}
		
		private function typeSymbol(b:BitBtn):void 
		{
			if (isCapClear){
				cap.showText(b.getCaptionText());
				isCapClear = false;
			}else{
				cap.showText(cap.getCurrentText() + b.getCaptionText());
				isCapClear = false;
			}			
		}
		
		private function closeBtnHandler(b:BasicButton):void 
		{
			this.hide();
		}
		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			myWorld = paramsOb.world;
			
		}
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 120 + Main.self.sizeManager.topMenuDelta;
			
		}	
		override public function handleKeyboardEvent(e:flash.events.KeyboardEvent):Boolean 
		{
			if (!this.visible){return false}
			var b:Boolean = super.handleKeyboardEvent(e);
			if (!b){
				if (e.keyCode==Keyboard.BACK){
					if (closeBtn.visible){
						this.hide(true);
						b = true;
					}
				}
				if (e.keyCode==Keyboard.ESCAPE){
					if (closeBtn.visible){
						this.hide(true);
						b = true;
					}
				}				
			}
			return b;	
		}
	}

}