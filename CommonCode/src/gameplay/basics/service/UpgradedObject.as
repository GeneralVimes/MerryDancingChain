package gameplay.basics.service 
{
	/**
	 * ...
	 * @author ...
	 */
	public class UpgradedObject 
	{
		public var uid:int = 0;
		public var currentLevel:int = 0;
		public var strCode:String
		public var param:UpgradedParam
		public var lvlCap:int
		public var priceFunc:Function
		public function UpgradedObject(ob:Object) 
		{
			uid = ob.uid;
			currentLevel = ob.currentLevel
			strCode = ob.strCode
			param = ob.param
			lvlCap = ob.lvlCap
			priceFunc = ob.priceFunc
		}
		
	}

}