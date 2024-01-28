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
	public class PurchasesWrapperTestPage extends UpdatedInterfacePage 
	{
		private var bgd:NinePartsBgd;
		private var closeBtn:SmallButton;
		private var cap:MultilangTextField;
		private var txt:MultilangTextField;
		
		private var buy1Btn:BitBtn;
		private var buy2Btn:BitBtn;
		private var buy3Btn:BitBtn;		
		private var buy4Btn:BitBtn;		
		private var buy5Btn:BitBtn;		
		private var consume1Btn:BitBtn;		
		private var consume2Btn:BitBtn;		
		private var restorePurchBtn:BitBtn;		
		private var view1Btn:BitBtn;		
		private var view2Btn:BitBtn;		
		public function PurchasesWrapperTestPage() 
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
			
			this.cap = new MultilangTextField("Test Purchases", 0, 40, sizeWidth-20, 1, 1, 0xffffff, "center", "scale", true, true);
			addChild(cap);
			
			this.txt = new MultilangTextField("", 0, 140, sizeWidth-20, 14, 1, 0xffffff, "center", "scale", true, true);
			addChild(txt);
			//updateCreditsCaption();
			
			buy1Btn = Routines.buildBitBtn("Buy A", -1, this, this.onBuyAClick, -200, this.txt.y + this.txt.getTextHeight() + 50);
			buy2Btn = Routines.buildBitBtn("Buy B", -1, this, this.onBuyBClick, 0, this.txt.y + this.txt.getTextHeight() + 50);
			buy3Btn = Routines.buildBitBtn("Buy C", -1, this, this.onBuyCClick, 200, this.txt.y + this.txt.getTextHeight() + 50);			
			buy4Btn = Routines.buildBitBtn("Buy D", -1, this, this.onBuyDClick, -400, this.txt.y + this.txt.getTextHeight() + 50);			
			buy5Btn = Routines.buildBitBtn("Buy E", -1, this, this.onBuyEClick, 400, this.txt.y + this.txt.getTextHeight() + 50);			
			consume1Btn = Routines.buildBitBtn("Consume A", -1, this, this.onConsumeAClick, -200, this.txt.y + this.txt.getTextHeight() + 150);			
			consume2Btn = Routines.buildBitBtn("Consume B", -1, this, this.onConsumeBClick, 0, this.txt.y + this.txt.getTextHeight() + 150);			
			restorePurchBtn = Routines.buildBitBtn("Restore purchases", -1, this, this.onRestoreClick, 200, this.txt.y + this.txt.getTextHeight() + 150);	
			view1Btn = Routines.buildBitBtn("View E", -1, this, this.onViewEClick, -400, this.txt.y + this.txt.getTextHeight() + 150);	
			view2Btn = Routines.buildBitBtn("View A", -1, this, this.onViewAClick, 400, this.txt.y + this.txt.getTextHeight() + 150);	
		}
		
		private function onViewAClick(b:BasicButton):void 
		{
			PurchasesWrapper.self.showProductView("ads_skips");
		}
		
		private function onViewEClick(b:BasicButton):void 
		{
			PurchasesWrapper.self.showProductView("golden_pickaxe");
		}
		
		private function onBuyAClick(b:BasicButton):void 
		{
			PurchasesWrapper.self.attemptPurchase("purch_rubies_100", 1, onPurchaseSuccess,onPurchaseFail, onPurchasePending);
		}
		
		private function onBuyBClick(b:BasicButton):void 
		{
			PurchasesWrapper.self.attemptPurchase("purch_rubies_1000", 1, onPurchaseSuccess,onPurchaseFail, onPurchasePending);
		}
		
		private function onBuyCClick(b:BasicButton):void 
		{
			PurchasesWrapper.self.attemptPurchase("golden_pickaxe", 1, onPurchaseSuccess,onPurchaseFail, onPurchasePending);
		}
		
		private function onBuyDClick(b:BasicButton):void 
		{
			PurchasesWrapper.self.attemptPurchase("golden_lightning", 1, onPurchaseSuccess,onPurchaseFail, onPurchasePending);
		}
		
		private function onBuyEClick(b:BasicButton):void 
		{
			
			
			PurchasesWrapper.self.attemptPurchase("ads_skips", 1, onPurchaseSuccess,onPurchaseFail, onPurchasePending);
		}
		
		private function onConsumeAClick(b:BasicButton):void 
		{
			PurchasesWrapper.self.consumePurchase("purch_rubies_100", onConsumeSuccess, onConsumeFail);
		}
		
		private function onConsumeBClick(b:BasicButton):void 
		{
			PurchasesWrapper.self.consumePurchase("purch_rubies_1000", onConsumeSuccess, onConsumeFail);
		}
		
		private function onRestoreClick(b:BasicButton):void 
		{
			PurchasesWrapper.self.manuallyRestorePurchases(onRestoreSuccess, onRestoreFail);
		}
		
		private function onPurchaseSuccess():void{
			NewGameScreen.screen.hud.showMessage("Purchase success", "", ["OK"]);
		}
		private function onPurchaseFail():void{
			NewGameScreen.screen.hud.showMessage("Purchase failed", "", ["OK"]);
		}
		private function onPurchasePending():void{
			NewGameScreen.screen.hud.showMessage("Purchase pending", "", ["OK"]);
		}
		
		private function onRestoreSuccess():void{
			NewGameScreen.screen.hud.showMessage("Restore success", "", ["OK"]);
		}
		private function onRestoreFail():void{
			NewGameScreen.screen.hud.showMessage("Restore failed", "", ["OK"]);
		}
		private function onConsumeSuccess():void{
			NewGameScreen.screen.hud.showMessage("Consume success", "", ["OK"]);
		}
		private function onConsumeFail():void{
			NewGameScreen.screen.hud.showMessage("Consume failed", "", ["OK"]);
		}
		
		override public function updateView():void 
		{
			super.updateView();

			var str:String = "Inventory:\n" + PurchasesWrapper.self.listInventory();
			str += "\n\nPending Inventory:\n"+ PurchasesWrapper.self.listPendingInventory();
			this.txt.showText(str);
			
			buy1Btn.y = this.txt.y + this.txt.getTextHeight() + 50;
			buy2Btn.y = this.txt.y + this.txt.getTextHeight() + 50;
			buy3Btn.y = this.txt.y + this.txt.getTextHeight() + 50;
			buy4Btn.y = this.txt.y + this.txt.getTextHeight() + 50;
			buy5Btn.y = this.txt.y + this.txt.getTextHeight() + 50;
			consume1Btn.y = this.txt.y + this.txt.getTextHeight() + 150;
			consume2Btn.y = this.txt.y + this.txt.getTextHeight() + 150;
			restorePurchBtn.y = this.txt.y + this.txt.getTextHeight() + 150;
			view1Btn.y = this.txt.y + this.txt.getTextHeight() + 150;
			view2Btn.y = this.txt.y + this.txt.getTextHeight() + 150;			
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
			
			
			buy1Btn.y = this.txt.y + this.txt.getTextHeight() + 50;
			buy2Btn.y = this.txt.y + this.txt.getTextHeight() + 50;
			buy3Btn.y = this.txt.y + this.txt.getTextHeight() + 50;
			buy4Btn.y = this.txt.y + this.txt.getTextHeight() + 50;
			buy5Btn.y = this.txt.y + this.txt.getTextHeight() + 50;			
			consume1Btn.y = this.txt.y + this.txt.getTextHeight() + 150;
			consume2Btn.y = this.txt.y + this.txt.getTextHeight() + 150;
			restorePurchBtn.y = this.txt.y + this.txt.getTextHeight() + 150;
			view1Btn.y = this.txt.y + this.txt.getTextHeight() + 150;
			view2Btn.y = this.txt.y + this.txt.getTextHeight() + 150;
					
			bgd.setDims(sizeWidth, this.txt.y + this.txt.getTextHeight() +350);			
		}		
	}

}