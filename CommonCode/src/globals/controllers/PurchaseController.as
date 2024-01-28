package globals.controllers 
{
	import com.junkbyte.console.Cc;
	import flash.system.Capabilities;
	import globals.controllers.PlayersDataController;
	import mx.resources.Locale;
	/**
	 * ...
	 * @author ...
	 */
	public class PurchaseController extends PlayersDataController
	{
		public var purchases:Array=[];
		private var hasOb:Object={};
		private var currentlyAttempterPurchObject:globals.controllers.PurchaseObject;
		private var currentlyAttempterSuccessFunction:Function;
		private var currentlyAttempterFailFunction:Function;
		private var currentlyAttempterPendingFunction:Function;
		public function PurchaseController() 
		{

		}
		
		public function initPurchasesAr(ar:Array):void{
			this.purchases = ar;
			hasOb = {};
			for (var i:int = 0; i < this.purchases.length; i++ ){
				hasOb[this.purchases[i].code] = this.purchases[i];
			}
		}
		
		public function actualizePurchases():void 
		{
			Cc.log("actualizePurchases")
			for (var i:int = 0; i < this.purchases.length; i++ ){
				var gd:PurchaseObject = this.purchases[i];
				Cc.log(gd.code, 'isOwned:', EnhanceWrapper.isItemOwned(gd.code), 'count:', EnhanceWrapper.getOwnedItemCount(gd.code), 'q=', gd.quantity);
				
				var q1:Number = EnhanceWrapper.isItemOwned(gd.code)?1:0;
				var q2:Number = EnhanceWrapper.getOwnedItemCount(gd.code);
				gd.quantity = Math.max(q1, q2, gd.quantity)
				//if (gd.isUnlockable){
				//	gd.quantity = Math.max(EnhanceWrapper.isItemOwned(gd.code)?1:gd.quantity, gd.quantity);
				//}else{
				//	gd.quantity = Math.max(EnhanceWrapper.getOwnedItemCount(gd.code),gd.quantity);
				//}
				Cc.log("gd.quantity=", gd.quantity, findGoodyOfCode(gd.code)==gd);
			}
		}
		public function hasPurchase(purchCode):Boolean{
			return countGoodiesOfCode(purchCode) > 0;
		}
		
		public function loadListOfPurchasesWhichGiveCurrency2Ar(curCode:String, resAr:Array):void{
			for (var i:int = 0; i < purchases.length; i++ ){
				var purch:PurchaseObject = purchases[i];
				for (var j:int = 0; j < purch.providedCurrencies.length; j++ ){
					var rec:Object = purch.providedCurrencies[j];
					if (rec.code==curCode){
						resAr.push(purch);
					}
				}
			}
		}
		
		public function incQuantityOfGoody(code:String, delta:int=1):void 
		{
			var gd:PurchaseObject = this.findGoodyOfCode(code);
			if (gd){
				gd.quantity+= delta;
			}
		}
		
		private function findGoodyOfUid(id:int):PurchaseObject 
		{
			var res:PurchaseObject = null;
			for (var i:int = 0; i < this.purchases.length; i++ ){
				var gd:PurchaseObject = this.purchases[i];
				if (gd.uid==id){
					res = gd;
					break;
				}
			}
			return res;
		}
		
		public function findGoodyOfCode(cd:String):PurchaseObject{
			var res:PurchaseObject = null;
			
			if (hasOb.hasOwnProperty(cd)){
				res = hasOb[cd] as PurchaseObject;
			}
			
			return res;
		}
		
		public function countGoodiesOfCode(cd:String):int{
			var gd:PurchaseObject = this.findGoodyOfCode(cd);
			if (gd){
				return gd.quantity;
			}else{
				return 0;
			}
		}
		
		//public function updateFromStore():void 
		//{
		//	if (EnhanceWrapper.isItemOwned("purch_noads")){
		//		incQuantityOfGoody("purch_noads")
		//	}
		//}		
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			
			var len:int = 0;
			var id2WriteLen:int = nxtId;
			nxtId++;
			for (var i:int = 0; i < purchases.length; i++ ){
				var gd:PurchaseObject = purchases[i];
				if (gd.quantity>0){
					len++;
					ar[nxtId + 0] = gd.uid;
					ar[nxtId + 1] = gd.quantity;
					nxtId += 2;
				}
			}
			ar[id2WriteLen] = len;
			return nxtId;		
		}
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			var len:int = ar[nxtId + 0];
			nxtId++;
			
			for (var i:int = 0; i < len; i++ ){
				var gd:PurchaseObject = findGoodyOfUid(ar[nxtId + 0]);
				if (gd){
					gd.quantity = ar[nxtId + 1];
				}
				nxtId += 2;
			}
			
			this.actualizePurchases();
			
			return nxtId;				
		}		
		
		public function attemptPurchaseOfObject(purchOb:globals.controllers.PurchaseObject, onCallersSuccess:Function, onCallersFail:Function, onCallersPend:Function):void 
		{
			currentlyAttempterPurchObject = purchOb
			currentlyAttempterSuccessFunction = onCallersSuccess
			currentlyAttempterFailFunction = onCallersFail
			currentlyAttempterPendingFunction = onCallersPend
			EnhanceWrapper.attemptPurchase(purchOb.code, onSuccess, onFail, onPend);
		}
		
		public function consumePurchase(purch:globals.controllers.PurchaseObject, currenciesController:globals.controllers.CurrenciesController):void 
		{
			var cd:String = purch.code;
			EnhanceWrapper.consumePurchase(cd, 
											function():void{
												Cc.log('Consume successful')
												NewGameScreen.screen.purchaseController.onSuccessfullyConsumedPurchase(cd);
											},
											function():void{
												Cc.log("Consume insuccessful");
											}
			)
		}
		
		public function onSuccessfullyConsumedPurchase(cd:String):void 
		{
			var purch:PurchaseObject = findGoodyOfCode(cd);
			if (purch){
				purch.quantity = 0;
				
				for (var i:int = 0; i < purch.providedCurrencies.length; i++ ){
					var ob:Object = purch.providedCurrencies[i];
					var curr:CurrencyObject = NewGameScreen.screen.currenciesController.findCurrencyOfCode(ob.code);
					if (curr){
						curr.movePurchaseCurrency2Additional(ob.value);
					}
				}	
				NewGameScreen.screen.react2PurchaseConsumption(purch);
			}
			
		}
		
		private function onPend():void 
		{
			currentlyAttempterPendingFunction();
			NewGameScreen.screen.hud.showMessage(
				"TXID_CAP_PENDINGCAP",
				"TXID_CAP_PENDINGMSG",
				["TXID_MSGANS_OK"]
			)
		}
		
		private function onFail():void 
		{
			currentlyAttempterFailFunction();
		}
		
		private function onSuccess():void 
		{
			currentlyAttempterPurchObject.quantity++;
			currentlyAttempterSuccessFunction();
			Cc.log("providedCurrencies:",currentlyAttempterPurchObject.providedCurrencies)
			for (var i:int = 0; i < currentlyAttempterPurchObject.providedCurrencies.length; i++ ){
				var ob:Object = currentlyAttempterPurchObject.providedCurrencies[i];

				NewGameScreen.screen.currenciesController.updatePurchasedCurrencyOfCode(ob.code)
			}
			NewGameScreen.screen.hud.showMessage("TXID_PURCH_SUCCESS", currentlyAttempterPurchObject.name +": "+currentlyAttempterPurchObject.desc,["TXID_MSGANS_OK"]);
		}
	}

}