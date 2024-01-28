package gameplay.basics.service 
{
	/**
	 * ...
	 * @author ...
	 */
	public class PurchasedRecord 
	{
		public var code:String;
		public var purchName:String;
		public var purchDesc:String;
		public var iconTx:String;
		public var purchases:Array;
		public function PurchasedRecord(cd:String, nm:String, desc:String, icTx:String, purchs:Array) 
		{
			code = cd;
			purchName = nm;
			purchDesc = desc;
			iconTx = icTx;
			purchases = purchs;
		}
		
	}

}