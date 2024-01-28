package globals.controllers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CurrenciesController  extends PlayersDataController
	{
		private var currencies:Array = [];
		private var hasOb:Object = {};
		public function CurrenciesController() 
		{
			
		}
		
		public function initCurrenciesAr(ar:Array, purchaseController:globals.controllers.PurchaseController):void 
		{
			this.currencies = ar;
			hasOb = {};
			for (var i:int = 0; i < this.currencies.length; i++ ){
				hasOb[this.currencies[i].code] = this.currencies[i];
				
				purchaseController.loadListOfPurchasesWhichGiveCurrency2Ar(this.currencies[i].code, this.currencies[i].associatedPurchaseObjects)
			}			
		}
		
		public function updatePurchasedCurrencyOfCode(code:String):void 
		{
			var curr:CurrencyObject = this.findCurrencyOfCode(code);
			if (curr){
				curr.updateCurrencyGainsFromPurchases();
			}
		} 		

		public function findCurrencyOfCode(cd:String):CurrencyObject 
		{
			var res:CurrencyObject = null;
			if (hasOb.hasOwnProperty(cd)){
				res = hasOb[cd] as CurrencyObject;
			}
			return res;
		}
		
		private function findCurrencyOfUID(uid:int):CurrencyObject 
		{
			var res:CurrencyObject = null;
			for (var i:int = 0; i < this.currencies.length; i++ ){
				if (this.currencies[i].uid == uid){
					res = this.currencies[i];
					break;
				}
			}
			return res;			
		}
		
		public function countCurrencyOfCode(code:String):Number
		{
			var res:Number = 0;
			var curr:CurrencyObject = this.findCurrencyOfCode(code);
			if (curr){
				res = curr.getCurrentVal();
			}
			return res;
		}
		
		public function spendCurrency(code:String, val:Number):void 
		{
			var curr:CurrencyObject = this.findCurrencyOfCode(code);
			if (curr){
				curr.spendValue(val)
			}
		}				
		
		public function gainCurrency(code:String, val:Number):void 
		{
			var curr:CurrencyObject = this.findCurrencyOfCode(code);
			if (curr){
				curr.gainValue(val)
			}			
		}	
		
		public function getCurrencyName(code:String):String{
			var res:String = "";
			var curr:CurrencyObject = this.findCurrencyOfCode(code);
			if (curr){
				res = curr.name;
			}
			return res;
		}
		
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			ar[nxtId + 0] = 0;
			ar[nxtId + 1] = 0;
			ar[nxtId + 2] = 0;
			ar[nxtId + 3] = 0;
			
			var len:int = this.currencies.length;
			ar[nxtId + 4] = len;
			nxtId = nxtId + 5;
			for (var i:int = 0; i < len; i++ ){
				nxtId = this.currencies[i].save2Ar(ar, nxtId);
			}
			
			return nxtId;
		}
		
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			var len:int = ar[nxtId + 4];
			nxtId = nxtId + 5;
			for (var i:int = 0; i < len; i++ ){
				var uid:int = ar[nxtId];
				var curr:CurrencyObject = this.findCurrencyOfUID(uid);
				if (curr==null){
					curr = new CurrencyObject(null);//создаём объект, чтоб он мог вычитать сейв, но в массив его не кладём
				}
				nxtId = curr.loadFromAr(ar, nxtId);
			}
			
			for (i = 0; i < currencies.length; i++ ){
				this.currencies[i].updateCurrencyGainsFromPurchases();
			}
			return nxtId;
		}



	}

}