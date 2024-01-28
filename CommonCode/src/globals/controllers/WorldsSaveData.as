package globals.controllers
{
	import globals.controllers.WorldMetaDataRecord;
	import globals.controllers.PlayersDataController;
	/**
	 * ...
	 * @author General
	 */
	public class WorldsSaveData extends PlayersDataController
	{
		public var allVals:Array;
		
		private var worldsMetaData:Vector.<globals.controllers.WorldMetaDataRecord>;
		private var lastPlayedWorldUID:int =-1;
		public function WorldsSaveData() 
		{
			allVals = new Array();
			worldsMetaData = new Vector.<globals.controllers.WorldMetaDataRecord>();
			
			//Object:{
			//	worldId:int,
			//	isVisible:Boolean,
			//	maxDicoveryPercentage:Number,
			//	isUnlocked:Boolean
			//}
			//pairs: code, val
			//с одним кодом пар может быть много (анлоченные миры в игре) или единственая (последняя сохранённая игра в игре)
		}
		
		public function updateWorldsRecord(wid:int, perc:Number):void 
		{
			var wmd:WorldMetaDataRecord = findOrCreateMetaData4World(wid);
			wmd.maxDicoveryPercentage = Math.max(wmd.maxDicoveryPercentage, perc)
			wmd.isUnlocked = true;
			wmd.isVisible = true;
		}
		
		public function isWorldUnlockedInRecords(wid:int):Boolean{
			var wmd:WorldMetaDataRecord = findOrCreateMetaData4World(wid);
			return wmd.isUnlocked
		}
		
		public function setWorldUnlockedInRecords(wid:int):void 
		{
			var wmd:WorldMetaDataRecord = findOrCreateMetaData4World(wid);
			wmd.isUnlocked = true;		
		}		
		private function findOrCreateMetaData4World(wid:int):WorldMetaDataRecord 
		{
			var res:WorldMetaDataRecord = null;
			for (var i:int = 0; i < worldsMetaData.length; i++ ){
				if (worldsMetaData[i].worldId == wid){
					res = worldsMetaData[i];
					break;
				}
			}
			if (!res){
				res = new WorldMetaDataRecord();
				res.worldId = wid;
				worldsMetaData.push(res);
			}
			
			return res;
		}
		

		public function getLastPlayedWorldUID():int
		{
			return lastPlayedWorldUID;
		}		
		
		public function setCurrentlyPlayedWorldUID(wid:int):void 
		{
			lastPlayedWorldUID = wid;
		}
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			ar[nxtId+0] = lastPlayedWorldUID;
			ar[nxtId+1] = 0;
			ar[nxtId+2] = 0;
			ar[nxtId + 3] = 0;
			var len:int = this.worldsMetaData.length;
			ar[nxtId + 4] = len;			
			nxtId = nxtId + 5;
			
			for (var i:int = 0; i < len; i++ ){
				nxtId = this.worldsMetaData[i].save2Ar(ar, nxtId);
			}
			
			return nxtId;
		}
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			lastPlayedWorldUID = ar[nxtId + 0];
			var len:int = ar[nxtId + 4];
			nxtId = nxtId + 5;
			
			this.worldsMetaData.length = 0;
			for (var i:int = 0; i < len; i++ ){
				var rct:WorldMetaDataRecord = new WorldMetaDataRecord();
				nxtId = rct.loadFromAr(ar, nxtId);
				this.worldsMetaData.push(rct);
			}
			return nxtId;
		}

		

		//newDefaultWorld->
		//lastSavedWorldInGame
		//availableWorldInGame
		
		//e():int{
		//ameId;
		//
		//2){
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//e(wid:int):void{
		//ameId;
		//
		//2){
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//id:int):void{
		//ameId;
		//
		//2){
		//
		//уже записан
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//d:int):Boolean{
		//
		//ameId;
		//
		//2){
		//
		//уже записан
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//ntGame(wid:int, perc:Number):void{
		//onfig.gameId + wid;//
		//
		//2){
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//ntGame(wid:int):Number{
		//
		//onfig.gameId + wid;
		//
		//2){
		//
		//
		//
		//
		//
		//
		//
		//
		//ublic function save2Ar(ar:Array, nxtId:int):int 
		//
		//n:int = worldsMetaData.length;
		//Id + 0] = len;
		//+;
		//
		//ar i:int = 0; i < len; i++ ){
		//tId = worldsMetaData[i].save2Ar(ar, nxtId);
		//
		//Id + 0] = 0;
		//Id + 1] = 0;
		//Id + 2] = 0;
		//Id + 3] = 0;
		//Id + 4] = 0;
		// nxtId+5;			
		//
		//
		//override public function loadFromAr(ar:Array, nxtId:int):int 
		//{
		//	var len:int = ar[nxtId + 0];
		//	nxtId++;
		//	worldsMetaData.length = 0;
		//	for (var i:int = 0; i < len; i++ ){
		//		var dt:WorldMetaDataRecord = new WorldMetaDataRecord();
		//		nxtId = dt.loadFromAr(ar, nxtId);
		//		worldsMetaData.push(dt);
		//	}
		//	
		//	return nxtId+5;
		//}
		///=====================================диапазон ключей от 3000 до 3000+1000*999+999ы		
	}
}