package gui.pages 
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import globals.PlayersAccount;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	/**
	 * ...
	 * @author General
	 */
	public class ModsSelectionPage extends InterfacePage 
	{
		private var bgd:NinePartsBgd;
		private var closeBtn:SmallButton;
		private var cap:MultilangTextField;		
		private var modNameCap:MultilangTextField;		
		private var modDescCap:MultilangTextField;		
	
		private var pageCaller:PreStartPage;
		
		private var nxtButton:BitBtn;
		private var prvButton:BitBtn;
		private var selButton:BitBtn;
		public function ModsSelectionPage() 
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
			
			this.cap = new MultilangTextField("TXID_CAP_MODS", 0, 40, sizeWidth-20, 1, 1, 0xffffff, "center", "scale", true, false);
			addChild(cap);	
			
			modNameCap = new MultilangTextField("-", 0, 140, sizeWidth-20, 2, 1, 0xffffff, "center", "scale", true, false);
			addChild(modNameCap);
			modDescCap = new MultilangTextField("-", 0, 340, sizeWidth-20, 10, 1, 0xffffff, "center", "scale", true, false);
			addChild(modDescCap);	
			
			var cy:Number = modDescCap.y + modDescCap.getTextHeight() + 50;
			nxtButton = Routines.buildBitBtn("\u21e8", -1, this, onNextClick, sizeWidth * 0.5 - 150, cy);
			prvButton = Routines.buildBitBtn("\u21e6", -1, this, onPrevClick, -sizeWidth * 0.5 + 150, cy);
			selButton = Routines.buildBitBtn("TXID_CAP_SELECT", -1, this, onSelectClick, 0, cy);
			nxtButton.setBaseWidth(180)
			prvButton.setBaseWidth(180)
			bgd.setDims(sizeWidth, cy + 50);
		}
		
		private function onSelectClick(b:BasicButton):void 
		{
			pageCaller.updateModsButtonFromSelectedMod();
			PlayersAccount.account.setParamOfName("lastPlayedMod", Assets.modsManager.getSelectedModFolder());
			this.hide();
		}
		
		private function onPrevClick(b:BasicButton):void 
		{
			Assets.modsManager.setPrevSelectedModId();
			updateModInfo();
		}
		
		private function onNextClick(b:BasicButton):void 
		{
			Assets.modsManager.setNextSelectedModId();
			updateModInfo();
		}
		
		private function updateModInfo():void 
		{
			modNameCap.showText(Assets.modsManager.getSelectedModName());
			modDescCap.y = modNameCap.y + modNameCap.getTextHeight() + 50;
			modDescCap.showText(Assets.modsManager.getSelectedModDescription());
			var cy:Number = modDescCap.y + modDescCap.getTextHeight() + 50;
			nxtButton.y=cy;
			prvButton.y=cy;
			selButton.y=cy;
			bgd.setDims(sizeWidth, cy + 50);
		}
		
		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			pageCaller = paramsOb.callerStartPage;
			
			updateModInfo();
		}
		
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = Main.self.sizeManager.gameHeight/ 2-300;			
			var cy:Number = modDescCap.y + modDescCap.getTextHeight() + 50;
			bgd.setDims(this.sizeWidth, cy + 50);
		}
		private function closeBtnHandler(b:BasicButton):void 
		{
			hide();
		}		
		override public function handleKeyboardEvent(e:KeyboardEvent):Boolean 
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
				if (e.keyCode==flash.ui.Keyboard.ESCAPE){
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