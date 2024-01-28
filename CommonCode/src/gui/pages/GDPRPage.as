package gui.pages 
{
	import globals.MenuCommandsPerformer;
	import globals.PlayersAccount;
	import globals.StatsWrapper;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.pages.InterfacePage;
	import gui.text.MultilangTextField;
	import EnhanceWrapper;
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class GDPRPage extends InterfacePage
	{
		private var bgd:Image;
		private var txt:MultilangTextField;
		private var acceptBtn:BitBtn;
		private var policyBtn:BitBtn;
		private var settingsBtn:BitBtn;
		
		private var capTf:MultilangTextField;
		private var txtTf:MultilangTextField;
		private var opaqueBgd:Image;
		
		public function GDPRPage() 
		{
			mustBClosedWhenAnotherOpens = false;
			
			
			bgd = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0, 0, "left", "top");
			bgd.alpha = 0.8;
			bgd.touchable = true;
			
			opaqueBgd = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0, 0, "left", "top");
			opaqueBgd.color = 0x00a2e8;
			
			capTf = new gui.text.MultilangTextField('TXID_GDPR_CAP', 0, 0, Main.self.sizeManager.gameWidth * 0.9, -1, 1, 0xffffff, "center","normal",true,true);
			addChild(capTf);
			
			txtTf = new gui.text.MultilangTextField('TXID_GDPR_EXPLANATION'+((Main.self.config.platform=="Apple")?"\nTXID_GDPR_APPLE_ADD_ALT":""), 0, 0, Main.self.sizeManager.gameWidth * 0.9, -1, 0.75, 0xffffff, "center","normal",true,true);
			addChild(txtTf);
			
			acceptBtn = new BitBtn();
			acceptBtn.setIconTextMode("text");
			acceptBtn.setBaseWidth(550);
			acceptBtn.setBaseHeight(130);
			acceptBtn.setCaption((Main.self.config.platform == "Apple")?"TXID_CAP_ACCEPTCONT":"TXID_CAP_ACCEPT");
			addChild(acceptBtn);
			acceptBtn.setViewMode("highlighted")
			acceptBtn.registerOnUpFunction(this.onAcceptClick);
			
			policyBtn = new BitBtn();
			policyBtn.setIconTextMode("text");
			policyBtn.setCaption("TXID_CAP_POLICY");
			addChild(policyBtn);
			policyBtn.registerOnUpFunction(this.onPolicyClick);
			
			settingsBtn = Routines.buildBitBtn("", 6, this, onSettingsClick);
			settingsBtn.setBaseWidth(50);
		}
		
		private function onSettingsClick(b:BasicButton):void 
		{
			NewGameScreen.screen.hud.showMessage("TXID_CAP_ASKALLOWPERSADS", "TXID_CAP_ASKALLOWPERSADSEXPL", ["TXID_MSGANS_YES", "TXID_MSGANS_NO"], [{func:onAllowPersAds}, {func:onDenyPersAds}],null, {screenPos:"bottom"});
		}
		
		private function onAllowPersAds():void 
		{
			PlayersAccount.account.setParamOfName("allowPeronalizedAds", "allow")
			PlayersAccount.account.doFlush();
		}
		
		private function onDenyPersAds():void 
		{
			PlayersAccount.account.setParamOfName("allowPeronalizedAds", "deny")
			PlayersAccount.account.doFlush();
		}
		
		private function onPolicyClick(btn:BasicButton=null):void 
		{
			MenuCommandsPerformer.self.openLinkByCode("privacy");
			StatsWrapper.stats.logTextWithParams("GDPR", "policy", 2);
		}
		
		private function onAcceptClick(btn:BasicButton=null):void 
		{
			PlayersAccount.account.setParamOfName("dataOptInResult", "consentGiven");
			PlayersAccount.account.doFlush();
			EnhanceWrapper.serviceTermsOptIn();
			this.hide();
			StatsWrapper.stats.logTextWithParams("GDPR", "accepted", 2);
			NewGameScreen.screen.hud.closeAllMessages();
		}
		
		override public function alignOnScreen():void 
		{
			bgd.width = Main.self.sizeManager.gameWidth;
			bgd.height = Main.self.sizeManager.gameHeight;
			capTf.x = Main.self.sizeManager.gameWidth / 2;
			txtTf.x = Main.self.sizeManager.gameWidth / 2;
			
			capTf.setMaxTextWidth(Main.self.sizeManager.gameWidth * 0.9);
			txtTf.setMaxTextWidth(Main.self.sizeManager.gameWidth * 0.9);
			
			acceptBtn.x =  Main.self.sizeManager.gameWidth / 2;
			policyBtn.x =  Main.self.sizeManager.gameWidth / 2;	
			settingsBtn.x =  policyBtn.x+170;	
			
			capTf.y = 50;
			txtTf.y = capTf.y + capTf.getTextHeight() + 50;
			
			acceptBtn.y = txtTf.y + txtTf.getTextHeight() + 50;
			policyBtn.y =  Main.self.sizeManager.gameHeight - 50;
			settingsBtn.y =  policyBtn.y;
			
			var deltaY:int = policyBtn.y - acceptBtn.y - 150;
			if (deltaY > 0){
				acceptBtn.y += deltaY;
				capTf.y += deltaY;
				txtTf.y += deltaY;
			}
			
			opaqueBgd.width = Main.self.sizeManager.gameWidth*0.96;
			opaqueBgd.x = Main.self.sizeManager.gameWidth*0.02;
			opaqueBgd.y = capTf.y - 100;
			opaqueBgd.height = Main.self.sizeManager.gameHeight - opaqueBgd.y;
		}
		
	}

}