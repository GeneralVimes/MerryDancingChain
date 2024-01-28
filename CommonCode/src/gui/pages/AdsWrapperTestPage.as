package gui.pages 
{
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	/**
	 * ...
	 * @author ...
	 */
	public class AdsWrapperTestPage extends UpdatedInterfacePage 
	{
		private var bgd:NinePartsBgd;
		private var closeBtn:SmallButton;
		private var cap:MultilangTextField;
		private var txt:MultilangTextField;
		
		private var adsInterBtn:BitBtn;
		private var adsRewBtn:BitBtn;
		private var adsUMPInitBtn:BitBtn;
		public function AdsWrapperTestPage() 
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
			
			this.cap = new MultilangTextField("Test Adverts", 0, 40, sizeWidth-20, 1, 1, 0xffffff, "center", "scale", true, true);
			addChild(cap);
			
			this.txt = new MultilangTextField("", 0, 140, sizeWidth-20, 14, 1, 0xffffff, "center", "scale", true, true);
			addChild(txt);
			//updateCreditsCaption();
			
			adsInterBtn = Routines.buildBitBtn("Interstitial", -1, this, this.onAdsInterClick, -200, this.txt.y + this.txt.getTextHeight() + 50);
			adsRewBtn = Routines.buildBitBtn("Rewarded", -1, this, this.onAdsRewClick, 200, this.txt.y + this.txt.getTextHeight() + 50);
			adsUMPInitBtn = Routines.buildBitBtn("Reset UMP", -1, this, this.onResetUMPClick, 0, this.txt.y + this.txt.getTextHeight() + 150);
		}
		
		private function onResetUMPClick(b:BasicButton):void 
		{
			AdvertsWrapper.self.reInitGoogleUMPForm();
		}
		
		private function onAdsRewClick(b:BasicButton):void 
		{
			if (AdvertsWrapper.self.isRewardedVideoReady()){
				AdvertsWrapper.self.showRewardedAd(onGranted);
			}else{
				if (AdvertsWrapper.self.isRewardedAdsUnavailableBecauseOfNetwork()){
					NewGameScreen.screen.hud.showMessage("Please check your internet connection", "", ["OK"]);
				}else{
					if (AdvertsWrapper.self.isRewardedAdsUnavailableBecauseOfGoogleUMP()){
						NewGameScreen.screen.hud.showMessage("Action required to gain reward", "Please accept ads preferences to view ads and gain reward", ["OK"],[{func:onUMPResetRequested}]);
					}
				}
			}
		}
		
		private function onUMPResetRequested():void 
		{
			AdvertsWrapper.self.reInitGoogleUMPForm();
		}

		private function onGranted(type:String, value:int):void 
		{
			NewGameScreen.screen.hud.showMessage("Reward granted", "", ["OK"]);
		}
		
		private function onAdsInterClick(b:BasicButton):void 
		{
			if (AdvertsWrapper.self.isInterstitialReady()){
				AdvertsWrapper.self.showInterstitialAd();
			}
		}
		override public function updateView():void 
		{
			super.updateView();
			adsInterBtn.visible = AdvertsWrapper.self.isInterstitialReady();
			
			adsRewBtn.visible = AdvertsWrapper.self.isRewardedVideoReady() || AdvertsWrapper.self.isRewardedAdsUnavailableBecauseOfNetwork() || AdvertsWrapper.self.isRewardedAdsUnavailableBecauseOfGoogleUMP();
			
			var str:String = ""
			str += AdvertsWrapper.self.isInterstitialReady()?"Interstitial: available":"Interstitial: NOT available"
			str+="\n"
			str += AdvertsWrapper.self.isRewardedVideoReady()?"Rewarded: available":"Rewarded: NOT available";
			if (!AdvertsWrapper.self.isRewardedVideoReady()){
				str += "\n"
				if (AdvertsWrapper.self.isRewardedAdsUnavailableBecauseOfNetwork()){
					str+="Reason: Network"
				}else{
					if (AdvertsWrapper.self.isRewardedAdsUnavailableBecauseOfGoogleUMP()){
						str+="Reason: Google UMP"
					}
				}
			}
			this.txt.showText(str);
			
			adsInterBtn.y = this.txt.y + this.txt.getTextHeight() + 50;
			adsRewBtn.y = this.txt.y + this.txt.getTextHeight() + 50;
			adsUMPInitBtn.y = this.txt.y + this.txt.getTextHeight() + 150;
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
			this.txt.setMaxTextWidth(sizeWidth - 20);
			
			
			adsInterBtn.y = this.txt.y + this.txt.getTextHeight() + 50;
			adsRewBtn.y = this.txt.y + this.txt.getTextHeight() + 50;
			adsUMPInitBtn.y = this.txt.y + this.txt.getTextHeight() + 150;
			
					
			bgd.setDims(sizeWidth, this.txt.y + this.txt.getTextHeight() +350);			
			
			
			
		
		}
	}

}