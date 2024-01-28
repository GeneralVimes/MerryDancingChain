package globals.controllers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class WorldMetaDataRecord 
	{
		public var worldId:int;
		public var isVisible:Boolean;
		public var maxDicoveryPercentage:Number = 0;
		public var isUnlocked:Boolean;
		public function WorldMetaDataRecord() 
		{
			
		}
		
		public function loadFromAr(ar:Array, nxtId:int):int{
			worldId = ar[nxtId + 0];
			isVisible = ar[nxtId + 1] == 1;
			maxDicoveryPercentage = ar[nxtId + 2];
			isUnlocked = ar[nxtId + 3] == 1;
			
			return nxtId + 8;
		}
		
		public function save2Ar(ar:Array, nxtId:int):int{
			ar[nxtId + 0] = worldId;
			ar[nxtId + 1] = isVisible?1:0
			ar[nxtId + 2] = maxDicoveryPercentage
			ar[nxtId + 3] = isUnlocked?1:0;
			ar[nxtId + 4] = 0
			ar[nxtId + 5] = 0
			ar[nxtId + 6] = 0
			ar[nxtId + 7] = 0
			
			return nxtId + 8;
		}
		
	}

}