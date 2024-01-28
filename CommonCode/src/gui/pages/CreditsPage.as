package gui.pages 
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
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
	public class CreditsPage extends InterfacePage
	{
		private var bgd:gui.elements.NinePartsBgd;
		private var closeBtn:gui.buttons.SmallButton;
		private var cap:gui.text.MultilangTextField;
		private var txt:gui.text.MultilangTextField;
		private var contactBtn:BitBtn;
		private var okBtn:BitBtn;
		
		private var specialThanks:Array = ["Global Game Jam Ukraine"];
		private var translatorThanks:Array = [""];
		private var soundThanks:Array = ["Kevin McLeod (incompetech.com)"];
		
		public function CreditsPage() 
		{
			bgd = new NinePartsBgd();
			addChild(bgd);
			bgd.alpha = 0.8;
            
			closeBtn = new SmallButton(0);
			closeBtn.setIconByCode("close")
			closeBtn.registerOnUpFunction(this.closeBtnHandler);
			addChild(closeBtn);
			closeBtn.x = Main.self.sizeManager.fitterWidth*0.5-70
			closeBtn.y = 0
			
			this.cap = new MultilangTextField("TXID_CAP_CREDITS", 0, 20, sizeWidth-20, 1, 1, 0xffffff, "center", "scale", true, true);
			addChild(cap);
			
			this.txt = new MultilangTextField("", 0, 80, sizeWidth-20, -1, 1, 0xffffff, "center", "scale", true, true);
			addChild(txt);
			updateCreditsCaption()
			
			contactBtn = Routines.buildBitBtn("TXID_MSGANS_CONTACT", -1, this, this.onCreditsContactClick, 200, this.txt.y + this.txt.getTextHeight() + 50);
			okBtn = Routines.buildBitBtn("TXID_MSGANS_OK", -1, this, this.onCreditsOKClick, -200, this.txt.y + this.txt.getTextHeight() + 50);
			
		}
		
		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			updateCreditsCaption()
		}
		
		private function updateCreditsCaption():void 
		{
			var str:String = "TXID_MSGCAP_CREDITSAUTHORS\n";

			if (specialThanks.length > 0){
				str += "\nTXID_MSGCAP_CREDITSTHANKSSPECIAL:";
				for (var i:int = 0; i < specialThanks.length; i++){
					if (i > 0){str += ","}
					str += " " + specialThanks[i];
				}				
			}		
			if (translatorThanks.length > 0){
				str += "\nTXID_MSGCAP_CREDITSTHANKSTRANSLATORS:";
				for (i = 0; i < translatorThanks.length; i++){
					if (i > 0){str += ","}
					str += " " + translatorThanks[i];
				}				
			}
			if (soundThanks.length > 0){
				str += "\nTXID_MSGCAP_CREDITSTHANKSSOUNDS:";
				for (i = 0; i < soundThanks.length; i++){
					if (i > 0){str += ","}
					str += " " + soundThanks[i];
				}
				str+=" (Freesound.org)"
			}
			//	"\nTXID_MSGCAP_CREDITSTHANKS"+
			//	"\nTXID_MSGCAP_CREDITSTHANKS_MORE"+
			//	"\n\nTXID_MSGCAP_CREDITSMORE"+
			//	"\n\nTXID_MSGCAP_MADEINUKRAINE"
			if (Assets.modsManager.selectedModId!=-1){
				str += "\n\nTXID_MSGCAP_MODAUTHOR: " + Assets.modsManager.getSelectedModAuthor()
			}
			this.txt.showText(str);			
		}
		
		private function onCreditsOKClick(b:BasicButton):void 
		{
			this.hide();
		}
		
		private function onCreditsContactClick(b:BasicButton):void 
		{
			MenuCommandsPerformer.self.openLinkByCode("contact");
		}
		
		private function closeBtnHandler(b:BasicButton):void 
		{
			this.hide();
		}
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			sizeWidth = Main.self.sizeManager.gameWidth - 40;
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 50 + Main.self.sizeManager.topMenuDelta;
			
			closeBtn.x = sizeWidth / 2 - 50;
			
			this.cap.setMaxTextWidth(sizeWidth - 20);
			
			this.txt.setMaxTextLines( -1, false);
			this.txt.setMaxTextWidth(sizeWidth - 20);
			
			var cy:int = this.txt.y + this.txt.getTextHeight() + 50;
			
			if (cy > Main.self.sizeManager.gameHeight - 50 - this.y){
				var delta:Number = cy - (Main.self.sizeManager.gameHeight - 50 - this.y)
				cy = cy - delta;
				
				var perc:Number = (this.txt.getTextHeight() - delta) / this.txt.getTextHeight();
				if (perc<0){perc=0}
				if (perc > 1){perc = 1}
				var newLines:int = Math.max(Math.floor(this.txt.getTextLines() * Math.sqrt(perc)), 1);
				this.txt.setMaxTextLines(newLines, true);
			}
			
			contactBtn.y =cy
			okBtn.y = cy;
			bgd.setDims(sizeWidth, cy+50);
		}
		override public function handleKeyboardEvent(e:KeyboardEvent):Boolean 
		{
			if (!this.visible){return false}
			var b:Boolean = super.handleKeyboardEvent(e);
			if (!b){
				if (e.keyCode==Keyboard.BACK){
					if (closeBtn.visible){
						this.hide();
						b = true;
					}
				}
				if (e.keyCode==flash.ui.Keyboard.ESCAPE){
					if (closeBtn.visible){
						this.hide();
						b = true;
					}
				}				
			}
			return b;			
		}		
	}

}