package globals.controllers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class PurchaseObject 
	{
		public var uid:int;
		public var code:String;
		public var name:String;
		public var desc:String;
		public var txtKey:String;
		public var price:String;
		public var quantity:int;
		public var isUnlockable:Boolean;
		
		public var providedCurrencies:Array=[];//[{code, value}]
		
		public function PurchaseObject(paramsOb:Object) 
		{
				uid = paramsOb.uid;
				code = paramsOb.code;
				name = paramsOb.name;
				desc = paramsOb.desc;
				txtKey = paramsOb.txtKey;
				price = paramsOb.price;
				quantity = paramsOb.quantity;
				isUnlockable = paramsOb.isUnlockable;
				
				if (paramsOb.providedCurrencies){
					providedCurrencies = paramsOb.providedCurrencies.slice();
				}else{
					providedCurrencies = [];
				}
				
				
		}
		public function getCurrencyValueInPurchase(curCode:String):Number{
			var res:Number = 0;
			for (var i:int = 0; i < providedCurrencies.length; i++ ){
				var ob:Object = providedCurrencies[i];
				if (ob.code == curCode){
					res = ob.value;
				}
			}
			return res;
		}
		
	}

}