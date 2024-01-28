package gameplay.controllers 
{
	import flash.utils.Dictionary;
	import gameplay.basics.service.PurchasedRecord;
	/**
	 * ...
	 * @author ...
	 */
	public class Purchaser 
	{
		public var purchasedObjects:Vector.<PurchasedRecord>;
		public var purchasePrices:Array;
		public var purchasePricesDict:Dictionary;
		public function Purchaser() 
		{
			purchasedObjects = new Vector.<gameplay.basics.service.PurchasedRecord>();
			purchasePrices = [];
			purchasePricesDict = new Dictionary();
		}
		
		public function getIdOfCode(cd:String):int 
		{
			var res:int =-1;
			for (var i:int = 0; i < purchasedObjects.length; i++ ){
				if (purchasedObjects[i].code == cd){
					res = i;
					break;
				}
			}
			return res;
		}
		
		
		public function getCodeOfId(id:int):String 
		{
			if ((id>=0)&&(id<purchasedObjects.length)){
				return purchasedObjects[id].code;
			}else{
				return "PURCH_CODE";
			}			
		}		
		
		public function getPurchaseCurrency4PurchaseCode(code:String):String 
		{
			var res:String = 'money';
			var ob:Object = purchasePricesDict[code];
			if (ob){
				res = ob.currency;
			}
			return res;
		}
		
		public function getPurchasePrice4PurchaseCode(code:String):Number 
		{
			var res:Number = 0;
			var ob:Object = purchasePricesDict[code];
			if (ob){
				res = ob.price;
			}
			return res;			
		}
		public function getPurchaseCoef4PurchaseCode(code:String):Number 
		{
			var res:Number = 1;
			var ob:Object = purchasePricesDict[code];
			if (ob){
				res = ob.coef;
			}
			return res;			
		}
		
		public function getNextNumberOfPurchase4PurchaseCode(code:String):int 
		{
			return 0;
		}
		
		public function getPurchaseOfCode(code:String):PurchasedRecord 
		{
			var idInPurchaser:int = getIdOfCode(code);
			var purchasedRecord:PurchasedRecord = purchasedObjects[idInPurchaser];
			return purchasedRecord;
		}
		
		public function getNameOfPurchaseId(id:int):String 
		{
			if ((id>=0)&&(id<purchasedObjects.length)){
				return purchasedObjects[id].purchName;
			}else{
				return "PURCH_CODE";
			}					
		}
		
		public function getDescOfPurchaseId(id:int):String 
		{
			if ((id>=0)&&(id<purchasedObjects.length)){
				return purchasedObjects[id].purchDesc;
			}else{
				return "PURCH_CODE";
			}					
		}

		
		public function getIconStrOfPurchaseId(id:int):String 
		{
			if ((id>=0)&&(id<purchasedObjects.length)){
				return purchasedObjects[id].iconTx;
			}else{
				return "";
			}					
		}

		
	}

}