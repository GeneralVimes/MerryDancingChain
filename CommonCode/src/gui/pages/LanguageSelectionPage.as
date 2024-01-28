package gui.pages 
{
	import com.junkbyte.console.Cc;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import globals.MenuCommandsPerformer;
	import globals.Translator;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	import starling.core.Starling;
	import starling.core.StatsDisplay;
	import starling.display.MeshBatch;
	/**
	 * ...
	 * @author ...
	 */
	public class LanguageSelectionPage extends InterfacePage
	{
		private var bgd:gui.elements.NinePartsBgd;
		private var closeBtn:gui.buttons.SmallButton;
		private var cap:gui.text.MultilangTextField;
		
		private var langBtns:Vector.<SmallButton>
		private var langBtnsWithNames:Vector.<BitBtn>
		private var langSelInf:gui.text.MultilangTextField;
		
		private var transWebsiteButton:BitBtn;
		private var transWebSiteLink:String="";
		
		private var numCheatClicks:int = 0;
		//private var numCheatClicks2:int = 0;
		private var skipTransButton:BitBtn;
		private var loadTransButton:BitBtn;
		
		private var vertsMoreBtn:BitBtn;
		private var vertsLessBtn:BitBtn;
		private var lastChangeStep:int = 1;
		private var lastChangeDir:int = 1;
		public function LanguageSelectionPage() 
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
			closeBtn.y = 20
			
			this.cap = new MultilangTextField("TXID_LANGSEL", 0, 40, sizeWidth, 1, 1, 0xffffff, "center", "scale", true, true);
			addChild(cap);
			
			langBtns = new Vector.<gui.buttons.SmallButton>();
			langBtnsWithNames = new Vector.<gui.buttons.BitBtn>();
			
			for (var i:int = 0; i < Translator.translator.availableLangs.length; i++ ){
				//var btn:SmallButton = new SmallButton(0);
				//btn.registerOnUpFunction(onLangSelClick)
				////btn.registerOnDownFunction(onLangSelCheatClick)
				//btn.setIconByCode("lang_" + Translator.translator.availableLangs[i]);
				//btn.numVal = i;
				//btn.strVal = Translator.translator.availableLangs[i];
				//langBtns.push(btn);
				//addChild(btn);			
				
				var btn:BitBtn = Routines.buildBitBtn(Translator.translator.getLocalizedVersionOfText("TXID_LANGNAME", Translator.translator.availableLangs[i]), -1, this, onLangSelClick, 0, 100);
				btn.setBaseWidth(300);
				btn.removeCaptionsFromTranslatableList();
				btn.numVal = i;
				btn.strVal = Translator.translator.availableLangs[i];
				langBtnsWithNames.push(btn);
			}
			
			this.langSelInf = new MultilangTextField("TXID_LANGNAME" + "\n" + "TXID_LANGTRANSTHANKS", 0, 140, sizeWidth-20, -1, 1, 0xffffff, "center", "normal", true, false);
			addChild(langSelInf);
			updateLangAndTranslatorInfo();
			
			transWebsiteButton = Routines.buildBitBtn("Website", -1, this, onTransWebsiteClick, this.langSelInf.x, this.langSelInf.y + 10);
			transWebsiteButton.visible = false;
			
			vertsMoreBtn = Routines.buildBitBtn("Less", -1, this, onVertsMoreBtnClick, this.transWebsiteButton.x+300, this.transWebsiteButton.y);
			vertsMoreBtn.visible = false;			
			vertsLessBtn = Routines.buildBitBtn("More", -1, this, onVertsLessBtnClick, this.transWebsiteButton.x-300, this.transWebsiteButton.y);
			vertsLessBtn.visible = false;			
			
			skipTransButton = Routines.buildBitBtn("Text codes on/off", -1, this, onSkipTransClick, this.transWebsiteButton.x+300, this.transWebsiteButton.y);
			skipTransButton.visible = false;
			loadTransButton = Routines.buildBitBtn("Reload translations", -1, this, onReloadTransClick, this.transWebsiteButton.x-300, this.transWebsiteButton.y);
			loadTransButton.visible = false;
		}
		
		private function updateLangAndTranslatorInfo():void 
		{
			var lcd:String = Translator.translator.getCurrentLanguage();
			var translatorStr:String = "";
			
			if (Translator.translator.langsTranslatedByDev.indexOf(lcd)==-1){
				translatorStr = Translator.translator.getLocalizedVersionOfText("TXID_LANGTRANSTHANKS");
				if ((translatorStr!="TXID_LANGTRANSTHANKS")&&(translatorStr!="")){
					translatorStr = Translator.translator.getLocalizedVersionOfText("TXID_MSGCAP_CREDITSTHANKSTRANSLATORS") + ": " + translatorStr;
				}else{
					translatorStr = "";
				}
			}

			var commentStr:String = Translator.translator.getLocalizedVersionOfText("TXID_LANGTRANSCOMMENT");
			if (commentStr.length > 0){
				if (translatorStr.length > 0){
					translatorStr+="\n"
				}
				translatorStr += commentStr;
			}
			
			
			langSelInf.showText("TXID_LANGNAME" + "\n" + translatorStr)
		}


		
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			sizeWidth = Main.self.sizeManager.gameWidth - 10;
			langSelInf.setMaxTextWidth(sizeWidth - 40);
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 20 + Main.self.sizeManager.topMenuDelta;
			
			closeBtn.x = sizeWidth / 2 - 50;
			
			var cx:int = 0;
			var cy:int = 0;
			var btnInfoSize:int = 310;
			var numInLine:int = (sizeWidth - 10) / btnInfoSize;
			
			//for (var i:int = 0; i < langBtns.length; i++ ){
			for (var i:int = 0; i < langBtnsWithNames.length; i++ ){
				//var btn:SmallButton = langBtns[i];
				//var idX:int = i % numInLine;
				//var idY:int = Math.floor(i / numInLine);
				//cx = (idX - (numInLine-1) / 2) * btnInfoSize;
				//cy = 100 + idY * 100;
				//btn.x = cx;
				//btn.y = cy;
				var btn:BitBtn = langBtnsWithNames[i];
				var idX:int = i % numInLine;
				var idY:int = Math.floor(i / numInLine);
				cx = (idX - (numInLine-1) / 2) * btnInfoSize;
				cy = 100 + idY * 100;
				btn.x = cx;
				btn.y = cy;				
			}
			
			langSelInf.y = cy + 100;
			cy = langSelInf.y + langSelInf.getTextHeight();
			if (transWebSiteLink!=""){
				transWebsiteButton.visible = true;
				transWebsiteButton.x = langSelInf.x;
				transWebsiteButton.y = cy;
				cy += 50;
			}else{
				transWebsiteButton.visible = false;
			}
			bgd.setDims(this.sizeWidth, cy + 50);
		}
		
		private function closeBtnHandler(b:BasicButton):void 
		{
			hide();
		}
		
		
		//private function onLangSelCheatClick(b:BasicButton):void {
		//	if (b.numVal==5){
		//		numCheatClicks2++;
		//	}else{
		//		numCheatClicks2 = 0;
		//	}	
		//	if (numCheatClicks2 == 10){
		//		numCheatClicks2 = 0;
		//		MenuCommandsPerformer.self.copyConsole2Clipboard();
		//	}			
		//}
		private function onLangSelClick(b:BasicButton):void 
		{
			Translator.translator.changeLanguage(b.strVal);
			
			updateLangAndTranslatorInfo();
			
			var cy:int = langSelInf.y + langSelInf.getTextHeight();
			transWebSiteLink = Translator.translator.getLocalizedVersionOfText("TXID_LANGTRANSLATORWEBSITE")
			if (transWebSiteLink!=""){
				transWebsiteButton.visible = true;
				transWebsiteButton.x = langSelInf.x;
				transWebsiteButton.y = cy;
				cy += 50;
			}else{
				transWebsiteButton.visible = false;
				transWebsiteButton.x = langSelInf.x;
				transWebsiteButton.y = cy;				
			}			
			bgd.setDims(this.sizeWidth, cy + 50);			
			
			if (b.numVal==0){
				numCheatClicks++;
			}else{
				numCheatClicks = 0;
			}			
			vertsMoreBtn.y = vertsLessBtn.y = transWebsiteButton.y + 100;
			skipTransButton.y = loadTransButton.y = langSelInf.y;
			
			if (numCheatClicks == 10){
				numCheatClicks = 0;
				Main.self.showConsole();
				MenuCommandsPerformer.self.logSaves2Console();
				
				vertsMoreBtn.visible = true;
				vertsLessBtn.visible = true;
				
				loadTransButton.visible = true;
				skipTransButton.visible = true;
			}
		}
		
		
		private function onVertsMoreBtnClick(b:BasicButton):void {
			if (lastChangeDir==-1){
				lastChangeStep *= 2;
			}else{
				lastChangeStep = 1;
			}
			lastChangeDir = -1;	
			MeshBatch.MAX_NUM_VERTICES = Math.max(20, Math.min(65535, MeshBatch.MAX_NUM_VERTICES + lastChangeStep*lastChangeDir));
			
			
			Cc.log("MAX_NUM_VERTICES=",MeshBatch.MAX_NUM_VERTICES)
		}
		private function onVertsLessBtnClick(b:BasicButton):void {
			if (lastChangeDir==1){
				lastChangeStep *= 2;
			}else{
				lastChangeStep = 1;
			}
			lastChangeDir = 1;
			MeshBatch.MAX_NUM_VERTICES = Math.max(20, Math.min(65535, MeshBatch.MAX_NUM_VERTICES + lastChangeStep*lastChangeDir));
			
			Cc.log("MAX_NUM_VERTICES=",MeshBatch.MAX_NUM_VERTICES)
		}
		private function onTransWebsiteClick(b:BasicButton):void 
		{
			if (transWebSiteLink!=""){
				MenuCommandsPerformer.self.openLink(transWebSiteLink);
			}
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

		private function onReloadTransClick(b:BasicButton):void 
		{
			Translator.translator.reloadOuterTranslations();
		}
		
		private function onSkipTransClick(b:BasicButton):void 
		{
			Translator.translator.toggleTranslationSkip();
		}		
	}

}