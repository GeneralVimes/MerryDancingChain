package globals.controllers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CurrencyObject 
	{
		public var uid:int;
		public var code:String;
		public var associatedPurchaseObjects:Array = [];
		public var gainsFromPurchasesVal:Number = 0;
		public var additionalGainsVal:Number = 0;
		public var totalSpendsVal:Number = 0;
		public var name:String = "";
		public var desc:String = "";
		public function CurrencyObject(currOb:Object) 
		{
			if (currOb){
				uid = currOb.uid;
				code = currOb.code;				
				name = currOb.name;				
				desc = currOb.desc
			}

		}
		
		public function getCurrentVal():Number{
			return gainsFromPurchasesVal + additionalGainsVal - totalSpendsVal;
		}
		
		
		public function movePurchaseCurrency2Additional(val:Number):void 
		{
			gainsFromPurchasesVal -= val;
			additionalGainsVal += val;			
		}
		
		public function spendValue(val:Number):void{
			totalSpendsVal += val;
			
			//смотрим, может, сделать консюм какой-то покупке
			//var needs1More:Boolean = true;
			//while (needs1More){
				//needs1More = false;
				//сначала отнимаем дополнительные
				var decVal:Number = Math.min(additionalGainsVal, totalSpendsVal);
				additionalGainsVal -= decVal;
				totalSpendsVal -= decVal;
				
				//if (totalSpendsVal > 0){//пробуем роллбекнуть покупку
				//	for (var i:int = 0; i < associatedPurchaseObjects.length; i++ ){
				//		var purch:PurchaseObject = associatedPurchaseObjects[i];
				//		if (purch.quantity > 0){
				//			var curVal:Number = purch.getCurrencyValueInPurchase(this.code);
				//			if (totalSpendsVal >= curVal * 0.5){
				//				NewGameScreen.screen.purchaseController.consumePurchase(purch, NewGameScreen.screen.currenciesController);
				//				//break;
				//			}
				//		}
				//	}					
				//}
					
			//}
		}
		
		public function gainValue(val:Number):void 
		{
			additionalGainsVal += val;
		}
		
		
		public function updateCurrencyGainsFromPurchases():void 
		{
			this.gainsFromPurchasesVal = 0;
			for (var i:int = 0; i < associatedPurchaseObjects.length; i++ ){
				var purch:PurchaseObject = associatedPurchaseObjects[i];
				if (purch.quantity > 0){
					this.gainsFromPurchasesVal += purch.getCurrencyValueInPurchase(this.code);
				}
			}
		}		
		
		public function save2Ar(ar:Array, nxtId:int):int{
			ar[nxtId + 0] = uid;
			//ar[nxtId + 1] = gainsFromPurchasesVal;
			ar[nxtId + 2] = additionalGainsVal;
			ar[nxtId + 3] = totalSpendsVal;
			ar[nxtId + 4] = 0;
			ar[nxtId + 5] = 0;
			
			return nxtId + 6;
		}
		public function loadFromAr(ar:Array, nxtId:int):int{
			//gainsFromPurchasesVal=ar[nxtId + 1];
			additionalGainsVal=ar[nxtId + 2];
			totalSpendsVal = ar[nxtId + 3];
			ar[nxtId + 4] = 0;
			ar[nxtId + 5] = 0;
			
			return nxtId + 6;			
		}

	}

}