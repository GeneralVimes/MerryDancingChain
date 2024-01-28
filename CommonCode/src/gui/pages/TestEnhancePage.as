package gui.pages 
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	/**
	 * ...
	 * @author General
	 */
	public class TestEnhancePage extends InterfacePage 
	{
		private var bgd:NinePartsBgd;
		private var closeBtn:SmallButton;
		private var cap:MultilangTextField;
		private var txt:gui.text.MultilangTextField;
		private var ads1Btn:BitBtn;
		private var ads2Btn:BitBtn;
		private var buyBtn:BitBtn;		
		private var restoreBtn:BitBtn;
		private var consumeBtn:BitBtn;
		
		private var purchCode:String = "test_purch"
		public function TestEnhancePage() 
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
			
			this.cap = new MultilangTextField("Test Enhance", 0, 40, sizeWidth-20, 1, 1, 0xffffff, "center", "scale", true, true);
			addChild(cap);
			
			this.txt = new MultilangTextField("", 0, 140, sizeWidth-20, 14, 1, 0xffffff, "center", "scale", true, true);
			addChild(txt);
			updateCreditsCaption();
			
			//contactBtn = Routines.buildBitBtn("TXID_MSGANS_CONTACT", -1, this, this.onCreditsContactClick, 200, this.txt.y + this.txt.getTextHeight() + 50);
			ads1Btn = Routines.buildBitBtn("Interstitial", -1, this, this.onAdsInterClick, -200, this.txt.y + this.txt.getTextHeight() + 50);
			ads2Btn = Routines.buildBitBtn("Rewarded", -1, this, this.onAdsRewClick, 200, this.txt.y + this.txt.getTextHeight() + 50);
			buyBtn = Routines.buildBitBtn("Buy", -1, this, this.onBuyClick, -300, this.txt.y + this.txt.getTextHeight() + 150);
			restoreBtn = Routines.buildBitBtn("Restore", -1, this, this.onRestoreClick, 300, this.txt.y + this.txt.getTextHeight() + 150);
			consumeBtn = Routines.buildBitBtn("Consume", -1, this, this.onConsumeClick, 0, this.txt.y + this.txt.getTextHeight() + 150);
		}
		
		private function onConsumeClick(b:BasicButton):void 
		{
			EnhanceWrapper.consumePurchase(purchCode, onConsumeSuccess, onConsumeFail);
		}
		
		private function onConsumeFail():void 
		{
			NewGameScreen.screen.hud.showMessage("Consume fail", "", ["OK"]);
		}
		
		private function onConsumeSuccess():void 
		{
			NewGameScreen.screen.hud.showMessage("Consume success", "", ["OK"]);
			updateCreditsCaption()
		}
		
		private function onRestoreClick(b:BasicButton):void 
		{
			EnhanceWrapper.manuallyRestorePurchases(onRestoreSuccess, onRestoreFail);
		}
		
		private function onRestoreSuccess():void 
		{
			NewGameScreen.screen.hud.showMessage("Restore success", "", ["OK"]);
			updateCreditsCaption()
		}
		
		private function onRestoreFail():void 
		{
			NewGameScreen.screen.hud.showMessage("Restore fail", "", ["OK"]);
		}
		
		private function onBuyClick(b:BasicButton):void 
		{
			EnhanceWrapper.attemptPurchase(purchCode, onPurchSuccess, onPurchFail, onPurchPend);
		}
		
		private function onPurchPend():void 
		{
			NewGameScreen.screen.hud.showMessage("Purchase pending", "", ["OK"]);
			updateCreditsCaption()
		}
		
		private function onPurchFail():void 
		{
			NewGameScreen.screen.hud.showMessage("Purchase Fail", "", ["OK"]);
		}
		
		private function onPurchSuccess():void 
		{
			NewGameScreen.screen.hud.showMessage("Purchase success", "", ["OK"]);
			updateCreditsCaption()
		}
		
		private function onAdsRewClick(b:BasicButton):void 
		{
			EnhanceWrapper.showRewardedAd(onGranted, onDeclined, onUnavailable);
		}
		
		private function onGranted(type:String, value:int):void 
		{
			NewGameScreen.screen.hud.showMessage("Granted", "", ["OK"]);
		}
		
		private function onDeclined():void 
		{
			NewGameScreen.screen.hud.showMessage("Declined", "", ["OK"]);
		}
		
		private function onUnavailable():void 
		{
			NewGameScreen.screen.hud.showMessage("Unavailable", "", ["OK"]);
		}
		
		private function onAdsInterClick(b:BasicButton):void 
		{
			EnhanceWrapper.showInterstitialAd();
		}
		

		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			updateCreditsCaption()
		}
		
		
		private function updateCreditsCaption():void 
		{
			var str:String = 
			EnhanceWrapper.getDisplayTitle(purchCode, "test purchase") + " price: " +
			EnhanceWrapper.getDisplayPrice(purchCode, "$0.10") + " owned: " +
			EnhanceWrapper.getOwnedItemCount(purchCode);
			if (EnhanceWrapper.isProductStatusPending(purchCode)){
				str+=" - Pending"
			}
			str += "\n";
			str += "Purchases supported: "+EnhanceWrapper.isPurchasesSupported().toString();
			str += "\n";
			str += "Interstitial ready: "+EnhanceWrapper.isInterstitialReady().toString();
			str += "\n";
			str += "Rewarded ready: " + EnhanceWrapper.isRewardedAdReady().toString();
			this.txt.showText(str);	
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
			updateCreditsCaption()
			var cy:int = this.txt.y + this.txt.getTextHeight() + 50;
			//contactBtn.y =cy
			ads1Btn.y = cy;
			ads2Btn.y = cy;
			buyBtn.y = cy + 100;
			restoreBtn.y = cy + 100;
			consumeBtn.y = cy + 100;
			bgd.setDims(sizeWidth, cy+150);
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