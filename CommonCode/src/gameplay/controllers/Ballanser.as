package gameplay.controllers 
{
	import flash.utils.Dictionary;
	import gameplay.basics.BasicGameObject;
	import gameplay.basics.service.UpgradedParam;

	/**
	 * ...
	 * @author ...
	 */
	public class Ballanser 
	{
		public var entities:Array = [
			//{
			//	cls:Class,
			//	name:String,
			//	desc:String,
			//	layers:Array<int>
			//}
		
		];
		public var entitiesClasses:Array = [];
		
		public var upgradedParamsDict:Dictionary;

		public var config:Object = {};
		public function Ballanser() 
		{
			initEntities();
			for (var i:int = 0; i < entities.length; i++ ){
				var ob:Object = entities[i];
				entitiesClasses.push(ob.cls);
			}
		}
		
		protected function initEntities():void 
		{
			upgradedParamsDict = new Dictionary();
		}		
		
		public function getName4Currency(upgradeCurrency:String):String
		{
			return "TXID_CAP_INF_MONEY"
		}
		
		//управляем контроллером подарков
		public function getDeltaTillNextGift(giftId:int):Number 
		{
			var res:Number = 999999999999;
			switch (giftId){
				case 0:{
					res = 5 * 60;
					break;
				}
				case 1:{
					res = 30 * 60;
					break;
				}
				default:{
					res = 24 * 60 * 60;
					break;
				}
			}
			return res;
		}
		
		public function getIconStrOfClass(cls:Class):String 
		{
			var res:String = "";
			var id:int = entitiesClasses.indexOf(cls);
			if (id !=-1){
				var ob:Object = entities[id];
				if (ob.hasOwnProperty("iconTx")){
					res = ob["iconTx"];
				}
			}
			return res;
		}


	}

}