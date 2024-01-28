package gui.pages 
{

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import gameplay.worlds.World;
	import globals.MenuCommandsPerformer;
	import globals.PlayersAccount;
	import globals.SoundPlayer;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.pages.BabelGiftsPanel;
	import gui.pages.InterfacePage;
	import gui.pages.LanguageSelectionPage;
	import gui.pages.NewsPage;
	import gui.text.MultilangTextField;
	/**
	 * ...
	 * @author ...
	 */
	public class BabelMenuPanel extends InterfacePage
	{
		private var bgd:NinePartsBgd;
		private var closeBtn:SmallButton;
		private var cap:gui.text.MultilangTextField;
		private var myWorld:World;
		private var giftBtn:BitBtn;
		private var newsBtn:BitBtn;
		private var restartBtn:BitBtn;
		private var creditsBtn:BitBtn;
		private var moreBtn:BitBtn;
		private var bkpBtn:BitBtn;
		private var testBtn:BitBtn;
		protected var test2Btn:BitBtn;
		
		private var langBtn:SmallButton;
		private var gdprBtn:SmallButton;
		private var soundBtn:gui.buttons.SmallButton;
		private var screenshotBtn:gui.buttons.SmallButton;
		private var codeBtn:gui.buttons.BitBtn;
		
		private var fullScreenBtn:SmallButton;
		private var makeWindowBtn:SmallButton;
		private var exitDosButton:BitBtn;		
		//var aw:int = 100;
		//var ah:int = 100;
		public function BabelMenuPanel() 
		{
			super();
			bgd = new NinePartsBgd();
			addChild(bgd);
			bgd.alpha = 0.8;
			
			gdprBtn = new SmallButton(0);
			gdprBtn.setIconByCode("gdpr")
			gdprBtn.x = sizeWidth/2;
			gdprBtn.y = 250;
			gdprBtn.registerOnUpFunction(onGDPRBtnClick);		
			if (Main.self.config.platformGroup=='Mobile'){
				addChild(gdprBtn);
			}
			
			
			screenshotBtn = new SmallButton(0);
			screenshotBtn.setIconByCode("photo")
			screenshotBtn.x = -sizeWidth/2;
			screenshotBtn.y = 250;
			addChild(screenshotBtn);
			screenshotBtn.registerOnUpFunction(onScreenshotBtnClick);	
			
			fullScreenBtn = new SmallButton(68);
			fullScreenBtn.x = -sizeWidth/2;
			fullScreenBtn.y = 320;			
			addChild(fullScreenBtn);
			fullScreenBtn.registerOnUpFunction(onFullScreenCick);		
			fullScreenBtn.visible = (!Main.self.isPCFullScreen()) && (Main.self.config.platformGroup=="PC")
			
			makeWindowBtn = new SmallButton(70);
			makeWindowBtn.x = -sizeWidth/2;
			makeWindowBtn.y = 320;			
			addChild(makeWindowBtn);
			makeWindowBtn.registerOnUpFunction(onMakeWindowCick);		
			makeWindowBtn.visible = (Main.self.isPCFullScreen()) && (Main.self.config.platformGroup=="PC")
			
			
			
			langBtn = new SmallButton(0);
			langBtn.setIconByCode("langselect")
			langBtn.x = sizeWidth/2;
			langBtn.y = 50;
			addChild(langBtn);
			langBtn.registerOnUpFunction(onLangBtnClick);
			
			soundBtn = new SmallButton(0);
			soundBtn.setIconByCode(SoundPlayer.player.isSound?"sound_on":"sound_off")
			soundBtn.x = sizeWidth/2
			soundBtn.y = 150;
			addChild(soundBtn);
			soundBtn.registerOnUpFunction(onSoundBtnClick);


			closeBtn = new SmallButton(0);
			closeBtn.setIconByCode("close");
			closeBtn.registerOnUpFunction(this.closeBtnHandler);
			addChild(closeBtn);
			closeBtn.x = Main.self.sizeManager.fitterWidth*0.5-70
			closeBtn.y = 0
			
			this.cap = new MultilangTextField("TXID_MSGCAP_MENU", 0, 0, sizeWidth, 1, 1, 0xffffff, "center", "scale", true,true);	
			addChild(cap);
			
			giftBtn = new BitBtn(); 
			giftBtn.setMaxCaptionLines(1);
			giftBtn.setIconTextMode("text");
			giftBtn.setCaption ('TXID_CAP_DAILYBONUS')
			giftBtn.y = 50;
			giftBtn.setBaseWidth(490);
			//giftBtn.setViewMode('highlighted');
			giftBtn.registerOnUpFunction(this.giftBtnHandler);
			//addChild(giftBtn);			
			
			newsBtn = new BitBtn(); 
			newsBtn.setIconTextMode("text");
			newsBtn.setCaption ('TXID_CAP_NEWS')
			newsBtn.y = 50+90*1;
			newsBtn.setBaseWidth(490);
			newsBtn.registerOnUpFunction(this.newsBtnHandler);
			addChild(newsBtn);
			
			restartBtn = new BitBtn(); 
			restartBtn.setIconTextMode("text");
			restartBtn.setCaption ('TXID_CAP_RESTART')
			restartBtn.y = 50+90*2;
			restartBtn.setBaseWidth(490);
			restartBtn.registerOnUpFunction(this.restartBtnHandler);
			addChild(restartBtn);

			codeBtn = new BitBtn(); 
			codeBtn.setIconTextMode("text");
			codeBtn.setCaption ('TXID_CAP_ENTERCODE')
			codeBtn.y = 50+90*3;
			codeBtn.setBaseWidth(490);
			codeBtn.registerOnUpFunction(this.codeBtnHandler);
			if (Main.self.config.platform!='Apple'){
				//addChild(codeBtn);
			}				
	
			
			
			bkpBtn = new BitBtn(); 
			bkpBtn.setIconTextMode("text");
			bkpBtn.setCaption ('TXID_CAP_BACKUPS')
			bkpBtn.y = 50+90*4
			bkpBtn.setBaseWidth(490);
			bkpBtn.registerOnUpFunction(this.bkpBtnHandler);
			//addChild(bkpBtn);
			
			testBtn = new BitBtn(); 
			testBtn.setIconTextMode("text");
			testBtn.setCaption ('TXID_CAP_SWITCHSKIN')
			testBtn.y = 50+90*5
			testBtn.setBaseWidth(490);
			testBtn.registerOnUpFunction(this.testBtnHandler);
			//addChild(testBtn);	
			
			test2Btn = new BitBtn(); 
			test2Btn.setIconTextMode("text");
			test2Btn.setCaption ('TXID_CAP_TOWERSMAP')
			test2Btn.y = 50+90*6
			test2Btn.setBaseWidth(490);
			test2Btn.registerOnUpFunction(this.test2BtnHandler);
			//addChild(test2Btn);	
			
			creditsBtn = new BitBtn(); 
			creditsBtn.setIconTextMode("text");
			creditsBtn.setCaption( 'TXID_CAP_CREDITS')
			creditsBtn.x = -200
			creditsBtn.y = 50+90*7;
			creditsBtn.setBaseWidth(390);
			creditsBtn.registerOnUpFunction(this.creditsBtnHandler);
			addChild(creditsBtn);
			
			moreBtn = new BitBtn(); 
			moreBtn.setIconTextMode("text");
			moreBtn.setCaption ('TXID_CAP_MOREGAMES')
			moreBtn.x = 200
			moreBtn.y = 50+90*7
			moreBtn.setBaseWidth(390);
			moreBtn.registerOnUpFunction(this.moreBtnHandler);
			addChild(moreBtn);				
			
			exitDosButton = Routines.buildBitBtn("TXID_CAP_EXIT", -1, this, onExitCick, 0, 50+90*8);
			exitDosButton.visible = Main.self.config.platformGroup=="PC"
			exitDosButton.setBaseWidth(390);

			bgd.setDims(this.sizeWidth, exitDosButton.y + 50);
			//var btn:BitBtn = new BitBtn()
			//addChild(btn);
			//btn.registerOnUpFunction(testFunc);			
			//var btn2:BitBtn = new BitBtn()
			//addChild(btn2);
			//btn2.registerOnUpFunction(testFunc2);
			//btn2.y = 200;
		}

		
		private function onSoundBtnClick(b:BasicButton):void 
		{
			SoundPlayer.player.setSound(!SoundPlayer.player.isSound);
			soundBtn.setIconByCode(SoundPlayer.player.isSound?"sound_on":"sound_off")
		}
		
		private function giftBtnHandler(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(BabelGiftsPanel,{world:this.myWorld},1)
		}
		private function newsBtnHandler(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(NewsPage, {world:this.myWorld},1)
		}
		private function restartBtnHandler(b:BasicButton):void 
		{
			this.myWorld.showRestartRequest();
			this.hide();
		}
		private function creditsBtnHandler(b:BasicButton):void 
		{
			MenuCommandsPerformer.self.showCreditsMessage();
		}
		private function moreBtnHandler(b:BasicButton):void 
		{
			MenuCommandsPerformer.self.openLinkByCode("moreGames");
		}
		private function codeBtnHandler(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(CodeEnterPage, {world:this.myWorld},1)
		}
		private function bkpBtnHandler(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(BackupsPage, {world:this.myWorld},1)
		}
				
		private function testBtnHandler(b:BasicButton):void 
		{
			NewGameScreen.screen.onSaveTimer(null);
			var worldOb:Object = NewGameScreen.screen.worldsController.getObOfId(this.myWorld.worldTypeId)//.worldData[0];
			
			var oldSkinId:int = NewGameScreen.screen.worldsController.getIdOfWorldSkin(0, Assets.workingSkinCode)
			
			NewGameScreen.screen.startPlayingWorld(worldOb, (oldSkinId+1)%worldOb.skins.length);//clearCurrentWorld будет внутри
		}	
		
		protected function test2BtnHandler(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(MapPage, {world:this.myWorld}, 1);
		}
		
		private function testFunc(b:BasicButton):void 
		{
			//aw+=1
			bgd.y++//setInnerDims(aw, ah);
		}		
		//private function testFunc2(b:BasicButton):void 
		//{
		//	ah+=1;
		//	bgd.setInnerDims(aw, ah);
		//}		
		private function closeBtnHandler(b:BasicButton):void 
		{
			this.hide();
		}
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 120 + Main.self.sizeManager.topMenuDelta;
			
			screenshotBtn.x = -sizeWidth/2+100;
			screenshotBtn.y = 80;	
			
			fullScreenBtn.x = screenshotBtn.x;
			fullScreenBtn.y = screenshotBtn.y + 100;
			fullScreenBtn.visible = (!Main.self.isPCFullScreen()) && (Main.self.config.platformGroup=="PC")
			
			makeWindowBtn.x = screenshotBtn.x;
			makeWindowBtn.y = screenshotBtn.y + 100;
			makeWindowBtn.visible = (Main.self.isPCFullScreen()) && (Main.self.config.platformGroup=="PC")
			
			langBtn.x = sizeWidth/2-100;
			langBtn.y = 80;			
			
			soundBtn.x = langBtn.x;
			soundBtn.y = langBtn.y + 100;		
			
			gdprBtn.x = soundBtn.x;
			gdprBtn.y = soundBtn.y+100;
			
			if (exitDosButton.visible){
				bgd.setDims(this.sizeWidth, exitDosButton.y + 50);
			}else{
				bgd.setDims(this.sizeWidth, moreBtn.y + 50);
			}
			
			
		}
		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			myWorld = paramsOb.world;
			
		}	
		private function onScreenshotBtnClick(b:BasicButton):void 
		{
			this.hide();
			MenuCommandsPerformer.self.sendScreenshot2Discord();
		}	
		private function onLangBtnClick(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(LanguageSelectionPage, null, 1);
		}	
		private function onGDPRBtnClick(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(GDPRPage);
			PlayersAccount.account.setParamOfName("dataOptInResult", "consentWithdrawn");
			PlayersAccount.account.doFlush();
			EnhanceWrapper.serviceTermsOptOut();			
		}
		
		private function onFullScreenCick(b:BasicButton):void 
		{
			Main.self.startPCFullScreen();
			fullScreenBtn.visible = false;
			makeWindowBtn.visible = true;
		}
		
		private function onMakeWindowCick(b:BasicButton):void 
		{
			Main.self.startPCWindowScreen();
			makeWindowBtn.visible = false;
			fullScreenBtn.visible = true;
		}
		
		private function onExitCick(b:BasicButton):void 
		{
			Main.self.exitNativeApplication();
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