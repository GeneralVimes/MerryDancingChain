package gui.pages 
{
	import com.junkbyte.console.Cc;
	import gameplay.worlds.service.ArtifactObject;
	import globals.Translator;
	import globals.controllers.CurrencyObject;
	import globals.controllers.PurchaseObject;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.pages.BabelArtifactsPanel;
	import gui.text.MultilangTextField;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class ArtifactInformer extends Sprite
	{
		private var iconIm:Image;
		private var capTxt:gui.text.MultilangTextField;
		private var descTxt:gui.text.MultilangTextField;
		private var ownTxt:gui.text.MultilangTextField;
		private var buyBtn:gui.buttons.SmallButton;
		private var resetBtn:gui.buttons.SmallButton;
		private var priceTxt:gui.text.MultilangTextField;
		public var myArtifact:ArtifactObject;
		private var currsTxt:gui.text.MultilangTextField;
		
		public var myPanel:BabelArtifactsPanel;
		public function ArtifactInformer(p:BabelArtifactsPanel) 
		{
			myPanel = p;
			this.myArtifact = null;
			
			var bgdIm :Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0, -50, "center", "top");
			bgdIm.scaleX = 400 / 100
			bgdIm.scaleY = 260 / 100
			bgdIm.alpha = 0.8;
			bgdIm.color = 0x1e76b1;

			var im1 :Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_CORNERIM"], this, -200, -50, "left","top")
			im1  = Routines.buildImageFromTexture(Assets.allTextures["TEX_CORNERIM"], this, 200, -50, "left", "top")
			im1.scaleX =-1;
			im1  = Routines.buildImageFromTexture(Assets.allTextures["TEX_CORNERIM"], this, -200, 210, "left","top")
			im1.scaleY =-1;
			im1  = Routines.buildImageFromTexture(Assets.allTextures["TEX_CORNERIM"], this, 200, 210, "left","top")
			im1.scale =-1;


			iconIm = Routines.buildImageFromTexture(Assets.allTextures["TXS_ARTIFACTSSYMBOLS"][0], this, -140, 110, "center", "center");
			
			capTxt = new MultilangTextField('', 0, 0, 400, 1, 1, 0xffffff, 'center', 'scale');
			addChild(capTxt);
			descTxt = new MultilangTextField('', 0, 50, 380, 1, 1, 0xffffff, 'center', 'scale');
			addChild(descTxt);
			ownTxt = new MultilangTextField('', 0, 130, 400, 1, 1, 0xffffff, 'center', 'scale');
			addChild(ownTxt);
			
			
			buyBtn = new SmallButton(1);
			buyBtn.setIconByCode("buy");
			buyBtn.x = 160;
			buyBtn.y = 110;
			addChild(buyBtn);
			buyBtn.registerOnUpFunction(onBuyClick);
			
			resetBtn = new SmallButton(1);
			resetBtn.setIconByCode("recycle");
			resetBtn.x = 160;
			resetBtn.y = 110;
			addChild(resetBtn);
			resetBtn.registerOnUpFunction(onResetClick);
			resetBtn.visible = false;
			
			priceTxt = new MultilangTextField('', -75, 130, 190, 1, 1, 0x66ff66, 'left', 'scale');
			addChild(priceTxt);
			
			currsTxt = new MultilangTextField('', -180, 200, 360, 1, 1, 0xffffff, 'left', 'scale');
			addChild(currsTxt);
			currsTxt.visible = false;
		}
		
		private function onResetClick(b:BasicButton):void {
			var purchOb:PurchaseObject = NewGameScreen.screen.purchaseController.findGoodyOfCode(this.myArtifact.associatedPurchaseCode);
			if (purchOb){
				NewGameScreen.screen.purchaseController.consumePurchase(purchOb, NewGameScreen.screen.currenciesController);
			}
		}
		
		private function onBuyClick(b:BasicButton):void 
		{
			trace('buy')
			if (myPanel.myWorld.hasEnoughResources2BuyArtifact(this.myArtifact)){
				myPanel.myWorld.artifactsController.buyArtifact(this.myArtifact);
				myPanel.myWorld.react2ImmediateArtifactPurchase(myArtifact);
			}else{
				var purchOb:PurchaseObject = NewGameScreen.screen.purchaseController.findGoodyOfCode(myArtifact.associatedPurchaseCode)
				if (purchOb){
					NewGameScreen.screen.purchaseController.attemptPurchaseOfObject(purchOb, onPurchaseSuccess, onPurchaseFail, onPurchasePending);
				}
			}
		}
		
		private function onPurchasePending():void 
		{
			myPanel.updateView();
		}
		
		private function onPurchaseFail():void 
		{
			myPanel.myWorld.showMessage("TXID_PURCHASEFAILED", "TXID_TRYAGAIN", ["TXID_MSGANS_OK"]);
		}
		
		private function onPurchaseSuccess():void 
		{
			myArtifact.quantity++;
			//myPanel.myWorld.artifactsController.actualizeArtifactsFromPurchaser();
			myPanel.updateView();
			
			myPanel.myWorld.react2ImmediateArtifactPurchase(myArtifact);
		}
		
		public function showForArtifact(aft:gameplay.worlds.service.ArtifactObject):void 
		{
			Cc.log('showForArtifact');
			myArtifact = aft;
			this.capTxt.showText( this.myArtifact.name)
			this.descTxt.showText( this.myArtifact.desc)
			this.iconIm.texture = Assets.manager.getTexture(this.myArtifact.txtKey);
			this.iconIm.readjustSize();
			
			this.ownTxt.showText( 'TXID_PHRASE_OWNED:' + this.myArtifact.quantity);
			
			var priceStr:String = '';
			if (myArtifact.alternativeCurrency){
				priceStr = Routines.showNumberInAAFormat(myArtifact.alternativeCurrencyPrice) + ' ' + myPanel.myWorld.ballanser.getName4Currency(myArtifact.alternativeCurrency);
			}
			priceTxt.setMaxTextLines(1,false)
			var purchOb:PurchaseObject = NewGameScreen.screen.purchaseController.findGoodyOfCode(this.myArtifact.associatedPurchaseCode);
			if (purchOb){
				if (priceStr != ""){
					priceStr += '\n TXID_OR '
					priceTxt.setMaxTextLines(2,false)
				}
				priceStr += EnhanceWrapper.getDisplayPrice(purchOb.code, purchOb.price);
			}
			Cc.log('testing Enhance Calls with default_val', this.myArtifact.code);
			
			//EnhanceWrapper.getDisplayTitle(this.myArtifact.associatedPurchaseCode, "default_val");
			//EnhanceWrapper.getDisplayDescription(this.myArtifact.associatedPurchaseCode, "default_val");
			//EnhanceWrapper.getDisplayPrice(this.myArtifact.associatedPurchaseCode, "default_val")
			
			this.priceTxt.showText( priceStr);

			this.resetBtn.visible = false;
			if (this.myArtifact.quantity>0){
				this.priceTxt.showText('')
				this.ownTxt.visible = true;
				this.buyBtn.visible = false;
				this.descTxt.setTextColor(0x66ff66)
				
				if (purchOb){
					//this.myArtifact.associatedPurchaseCode)
					if (!purchOb.isUnlockable){
						this.resetBtn.visible = true;
					}
				}
			}else{
				this.priceTxt.visible = true;
				this.ownTxt.showText('')
				this.buyBtn.visible = true;	
				this.descTxt.setTextColor(0xffffff)			
			}
			if (purchOb){
				if (EnhanceWrapper.isProductStatusPending(purchOb.code)){
					this.ownTxt.showText("TXID_CAP_PENDING")
					this.buyBtn.visible = false;
				}
			}
			
			currsTxt.visible = false;
			if (purchOb){
				if (purchOb.providedCurrencies.length > 0){
					currsTxt.visible = true;
					var str:String = "TXID_CAP_NOWCURRENCIES:"
					for (var i:int = 0; i < purchOb.providedCurrencies.length; i++ ){
						var ob:Object = purchOb.providedCurrencies[i];
						var curr:CurrencyObject = NewGameScreen.screen.currenciesController.findCurrencyOfCode(ob.code);
						if (curr){
							str += ' '+Routines.showNumberInAAFormat(curr.getCurrentVal()) + " " + curr.name;
							if (i<purchOb.providedCurrencies.length-1){
								str+=","
							}
						}
					}
					currsTxt.showText(str);
				}
			}
			
			
			this.visible = true;			
		}
		
	}

}