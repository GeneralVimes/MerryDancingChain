package gui.pages 
{
	import com.junkbyte.console.Cc;
	import flash.system.Capabilities;
	import globals.MenuCommandsPerformer;
	import globals.PlayersAccount;
	import globals.SoundPlayer;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.pages.InterfacePage;
	import gui.text.MultilangTextField;
	import gui.text.ShadowedTextField;
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class PreStartPage extends InterfacePage
	{
		private var verTxt:MultilangTextField;
		private var capIm:Image;
		private var bgIm:Image;
		
		private var bgW0:int;
		private var bgH0:int;
		
		private var topStripe:Image;
		private var botStripe:Image;
		private var startBtn:BitBtn;
		private var credsBtn:BitBtn;
		private var moreBtn:BitBtn;
		private var modsBtn:BitBtn;
		private var modsDesc:ShadowedTextField;
		//private var testBtn:BitBtn;
		//private var testBtn2:BitBtn;
		private var langBtn:SmallButton;
		private var soundBtn:gui.buttons.SmallButton;
		
		private var frndTxt:ShadowedTextField;
		private var grpTxt:ShadowedTextField;
		
		private var twiBtn:SmallButton;
		private var fbBtn:SmallButton;
		private var discBtn:SmallButton;
		private var rdtBtn:SmallButton;
		
		private var fullScreenBtn:SmallButton;
		private var makeWindowBtn:SmallButton;
		private var exitDosButton:BitBtn;
		public function PreStartPage() 
		{
			mustBClosedWhenAnotherOpens = false;
			
			topStripe = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0, 0, "center", "top");
			botStripe = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0, 0, "center", "top");
			
			topStripe.color = 0x629AEC;
			botStripe.color = 0x74EA85;
			
			bgIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_GAMESTARTPAGEBGD"], this, 0, 0, "center", "top");
			bgW0 = bgIm.width;
			bgH0 = bgIm.height;
			capIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_GAMENAME"], this, 0, 0, "center", "top");
			verTxt = new MultilangTextField(Main.self.config.gameVersion, 100, 100, 500, 1, 1, 0xffffff, 'right', 'scale', false);
			addChild(verTxt);
			
			startBtn = Routines.buildBitBtn("TXID_CAP_START", -1, this, onStartCick, 0, 0)
			startBtn.setBaseWidth(350);
			startBtn.setBaseHeight(100);
			credsBtn = Routines.buildBitBtn("TXID_CAP_CREDITS", -1, this, onCredsCick, 0, 0)
			moreBtn = Routines.buildBitBtn("TXID_CAP_MOREGAMES", -1, this, onAirapportCick, 0, 0)
			modsBtn = Routines.buildBitBtn("TXID_CAP_MODS", -1, this, onModsCick, 0, 0)
			
			
			modsDesc = new ShadowedTextField("mod Desc", 0, 0, Main.self.sizeManager.fitterWidth * 0.9, 1, 1, 0xffffff, 0x000000, "center", "scale", false, false);
			addChild(modsDesc);
			updateModsButtonFromSelectedMod();
			
			
			exitDosButton = Routines.buildBitBtn("TXID_CAP_EXIT", -1, this, onExitCick, 0, 0);
			exitDosButton.visible = Main.self.config.platformGroup=="PC"
			fullScreenBtn = new SmallButton(68);
			addChild(fullScreenBtn);
			fullScreenBtn.registerOnUpFunction(onFullScreenCick);		
			fullScreenBtn.visible = (!Main.self.isPCFullScreen()) && (Main.self.config.platformGroup=="PC")
			
			makeWindowBtn = new SmallButton(70);
			addChild(makeWindowBtn);
			makeWindowBtn.registerOnUpFunction(onMakeWindowCick);		
			makeWindowBtn.visible = (Main.self.isPCFullScreen()) && (Main.self.config.platformGroup=="PC")
			
			//testBtn = Routines.buildBitBtn("TEST1", -1, this, onTest1Cick, 0, 0)
			//testBtn2 = Routines.buildBitBtn("TEST2", -1, this, onTest2Cick, 0, 0)
			
			langBtn = new SmallButton(0);
			langBtn.setIconByCode("langselect")
			langBtn.x = Main.self.sizeManager.gameWidth - 50;
			langBtn.y = 50;
			addChild(langBtn);
			langBtn.registerOnUpFunction(onLangBtnClick);	
			
			soundBtn = new SmallButton(0);
			soundBtn.setIconByCode(SoundPlayer.player.isSound?"sound_on":"sound_off")
			soundBtn.x = Main.self.sizeManager.gameWidth - 50;
			soundBtn.y = 150;
			addChild(soundBtn);
			soundBtn.registerOnUpFunction(onSoundBtnClick);
			
			frndTxt = new ShadowedTextField("TXID_CAP_INVITEFRIENDS", 0, 0, Main.self.sizeManager.fitterWidth * 0.5-50, 1, 1, 0xffffff, 0x000000, "left", "scale", true, true);
			grpTxt = new ShadowedTextField("TXID_CAP_JOINGROUP", 0, 0, Main.self.sizeManager.fitterWidth * 0.5-50, 1, 1, 0xffffff, 0x000000, "right", "scale", true, true);
			addChild(frndTxt);
			addChild(grpTxt);
			
			twiBtn = new SmallButton(0);
			twiBtn.setIconByCode("twitter")
			addChild(twiBtn);
			twiBtn.registerOnUpFunction(onTwiBtnClick);	
			
			fbBtn = new SmallButton(0);
			fbBtn.setIconByCode("facebook")
			addChild(fbBtn);
			fbBtn.registerOnUpFunction(onFBBtnClick);		
			
			discBtn = new SmallButton(0);
			discBtn.setIconByCode("discord")
			addChild(discBtn);
			discBtn.registerOnUpFunction(onDiscordBtnClick);	
			
			rdtBtn = new SmallButton(0);
			rdtBtn.setIconByCode("reddit")
			addChild(rdtBtn);
			rdtBtn.registerOnUpFunction(onRedditBtnClick);
			
			frndTxt.visible = PlayersAccount.account.numLaunches > 2;
			grpTxt.visible = PlayersAccount.account.numLaunches > 2;
			twiBtn.visible = PlayersAccount.account.numLaunches > 2;
			fbBtn.visible = PlayersAccount.account.numLaunches > 2;
			discBtn.visible = PlayersAccount.account.numLaunches > 2;
			rdtBtn.visible = PlayersAccount.account.numLaunches > 2;
		}
		
		public function updateModsButtonFromSelectedMod():void 
		{
			modsBtn.visible = Assets.modsManager.modsObs.length > 0;
			modsDesc.visible = Assets.modsManager.modsObs.length > 0;
			if (Assets.modsManager.selectedModId==-1){
				modsDesc.showText("");
			}else{
				modsDesc.showText(Assets.modsManager.getSelectedModName());
			}
		}
		
		private function onModsCick(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(ModsSelectionPage, {callerStartPage:this});
		}
		
		private function onRedditBtnClick(b:BasicButton):void 
		{
			MenuCommandsPerformer.self.openLinkByCode("reddit")
		}
		
		private function onDiscordBtnClick(b:BasicButton):void 
		{
			MenuCommandsPerformer.self.openLinkByCode("discord")
		}
		
		private function onFBBtnClick(b:BasicButton):void 
		{
			MenuCommandsPerformer.self.shareGame2Facebook()
		}
		
		private function onTwiBtnClick(b:BasicButton):void 
		{
			MenuCommandsPerformer.self.shareGame2Twitter()
		}
		
		private function onSoundBtnClick(b:BasicButton):void 
		{
			SoundPlayer.player.setSound(!SoundPlayer.player.isSound);
			soundBtn.setIconByCode(SoundPlayer.player.isSound?"sound_on":"sound_off")
		}
		
		private function onLangBtnClick(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showPageOfClass(LanguageSelectionPage);
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
			fullScreenBtn.visible = true;
			makeWindowBtn.visible = false;
		}
		
		private function onExitCick(b:BasicButton):void 
		{
			Main.self.exitNativeApplication()
		}		
		
		private function onStartCick(b:BitBtn=null):void 
		{
			SoundPlayer.player.playSteampunkMusic();
			//есть ли 1 мир или несколько
			//var numWorldsInGame:int = NewGameScreen.screen.worldsController.worldData.length;
			//if (numWorldsInGame > 1){
			//	NewGameScreen.screen.hud.showPageOfClass(WorldSelectionPage)
			//}else{
				var uid:int =  NewGameScreen.screen.worldsSaveData.getLastPlayedWorldUID();
				var worldOb:Object = NewGameScreen.screen.worldsController.getObOfId(uid);
				if (!worldOb){
					worldOb = NewGameScreen.screen.worldsController.worldData[0];
				}
				var skid:int = PlayersAccount.account.getIntParamOfName("worldskin_"+uid.toString(), worldOb.defaultSkinId)
				NewGameScreen.screen.startPlayingWorld(worldOb, skid)				
			//}
		}
		
		private function onTest1Cick(b:BasicButton = null):void{
			//Main.self.showConsole();
			//Cc.log(Capabilities.manufacturer);
			//Cc.log(Capabilities.os);
			//Cc.log(Capabilities.pixelAspectRatio);
			//Cc.log(Capabilities.playerType);
			//Cc.log(Capabilities.screenDPI);
			//Cc.log(Capabilities.screenResolutionX);
			//Cc.log(Capabilities.screenResolutionY);
			//Cc.log(Capabilities.version);
			NewGameScreen.screen.hud.showPageOfClass(MapPage, {});
		}
		
		private function onTest2Cick(b:BasicButton = null):void{
			//Main.self.testInteractiveFullScreen();
		}

		private function onCredsCick(b:BitBtn=null):void 
		{
			MenuCommandsPerformer.self.showCreditsMessage();
		}

		private function onAirapportCick(b:BitBtn=null):void 
		{
			MenuCommandsPerformer.self.openLinkByCode("moreGames");
		}
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			bgIm.x = Main.self.sizeManager.gameWidth / 2;
			//будет заполнять без полей
			bgIm.scale = Math.max(Main.self.sizeManager.gameWidth / bgW0, Main.self.sizeManager.gameHeight / bgH0);
			bgIm.y = (Main.self.sizeManager.gameHeight - bgIm.height) / 2;
			
			capIm.x = Main.self.sizeManager.gameWidth / 2;
			capIm.y = 50;
			
			verTxt.x = Main.self.sizeManager.gameWidth - 50;
			verTxt.y = Main.self.sizeManager.gameHeight - 50;
			
			topStripe.width = Main.self.sizeManager.gameWidth;
			botStripe.width = Main.self.sizeManager.gameWidth;
			
			topStripe.x = Main.self.sizeManager.gameWidth / 2;
			botStripe.x = Main.self.sizeManager.gameWidth / 2;
			
			topStripe.height = Main.self.sizeManager.gameHeight/2+2;
			botStripe.height = Main.self.sizeManager.gameHeight/2;
			botStripe.y = Main.self.sizeManager.gameHeight/2;
			
			startBtn.x = Main.self.sizeManager.gameWidth / 2;
			credsBtn.x = Main.self.sizeManager.gameWidth *0.75;
			moreBtn.x = Main.self.sizeManager.gameWidth * 0.25;
			modsBtn.x = Main.self.sizeManager.gameWidth * 0.5;
			
			startBtn.y = Main.self.sizeManager.gameHeight / 2;
			credsBtn.y = startBtn.y + 100;
			moreBtn.y = startBtn.y + 100;
			modsBtn.y = Main.self.sizeManager.gameHeight - 50;
			
			fullScreenBtn.x = 70;
			fullScreenBtn.y = 70;
			fullScreenBtn.visible = (!Main.self.isPCFullScreen()) && (Main.self.config.platformGroup=="PC")
			makeWindowBtn.x = 70;
			makeWindowBtn.y = 70;
			makeWindowBtn.visible = (Main.self.isPCFullScreen()) && (Main.self.config.platformGroup=="PC")
			
			exitDosButton.x = startBtn.x;
			exitDosButton.y = credsBtn.y+100;
			
			modsDesc.x = Main.self.sizeManager.gameWidth * 0.5;
			modsDesc.y = modsBtn.y-70
			//testBtn.x = moreBtn.x;
			//testBtn.y = moreBtn.y+150;
			//testBtn2.x = credsBtn.x;
			//testBtn2.y = credsBtn.y+150;
			
			langBtn.x = Main.self.sizeManager.gameWidth - 50;
			langBtn.y = 50;
			soundBtn.x = Main.self.sizeManager.gameWidth - 50;
			soundBtn.y = 150;
			
			frndTxt.x = 20;
			frndTxt.y = moreBtn.y + 150;	
			
			grpTxt.x = Main.self.sizeManager.gameWidth - 20;
			grpTxt.y = moreBtn.y + 150;
			
			twiBtn.x = 50;
			fbBtn.x = 50 + 80;
			twiBtn.y = fbBtn.y = frndTxt.y + 50;
			
			rdtBtn.x = Main.self.sizeManager.gameWidth -50;
			discBtn.x = Main.self.sizeManager.gameWidth -50 - 80;
			rdtBtn.y = discBtn.y = grpTxt.y + 50;
			
		}
	}

}