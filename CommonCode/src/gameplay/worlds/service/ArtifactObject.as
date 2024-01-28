package gameplay.worlds.service 
{
	/**
	 * ...
	 * @author ...
	 */
	public class ArtifactObject 
	{
		public var uid:int;
		public var code:String;
		public var name:String;
		public var desc:String;
		public var txtKey:String;
		public var quantity:int;
		public var associatedPurchaseCode:String;
		public var alternativeCurrency:String;
		public var alternativeCurrencyPrice:Number;

		public function ArtifactObject(paramsOb:Object) 
		{
				uid = paramsOb.uid;
				code = paramsOb.code;
				name = paramsOb.name;
				desc = paramsOb.desc;
				txtKey = paramsOb.txtKey;
				quantity = paramsOb.quantity
				associatedPurchaseCode = paramsOb.associatedPurchaseCode;
				alternativeCurrency = paramsOb.alternativeCurrency;
				alternativeCurrencyPrice = paramsOb.alternativeCurrencyPrice;
		}
		
	}

}