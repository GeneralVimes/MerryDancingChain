package  globals
{
	import com.junkbyte.console.Cc;
	import flash.display.BitmapData;
	import flash.events.NetStatusEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.system.Security;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.ByteArray;
	import saves.NewSavedGame;

	import globals.controllers.PlayersDataController;
	
	//import Date;
	/**
	 * ...
	 * @author General
	 */
	public class PlayersAccount 
	{
		public static var account:PlayersAccount;
		
		private var savePath:String;//
		private var GameData:SharedObject;
		
		private var cachedNumLaunches:int=-1;
		
		public var playerNewUID:String;
		public var playerName4Score:String;
		public var playerId4Network:String;//25 symbols
		
		//public var dataOptInResult:String = 'unknown';//consentGiven, "consentWithdrawn"
		//not EU
		//ok with personalized ads
		//ok with nonpersonalized ads
		//denied
		
		public var hasJustCreatedNewUid:Boolean;
		public var newSavedGame:NewSavedGame;
		
		public var currentlyLoadedSaveVersion:String;//версия сейва, загружаемая в данный момент - 	OBSOLETE
		public var currentlyLoadedIntSaveVersion:int;//версия сейва, загружаемая в данный момент - вот это как раз сипользуется
		public function PlayersAccount()
		{
			account = this;
			
			//very first path: 'Spinner2/Saves';
			//pathBefore refactoring: "Engineer2/Saves";
			savePath = "G_" + Main.self.config.gameId.toString() + "_P_" + Main.self.config.platformGroup + "/Saves";
			
			initSaves();
			numLaunches = numLaunches + 1;
		}

		//public function hadPlayedSpinner():Boolean{+
		//	if (LocalParams.platform == 'GooglePlay'){
		//		var spinnerPath:String = 'Spinner2/Saves';
		//		var SpinnerGameData:SharedObject = SharedObject.getLocal(spinnerPath, '/');
		//		if (!SpinnerGameData.data.playerUID) {
		//			return false;
		//		}else{
		//			return true;
		//		}
		//	}else{
		//		return false;
		//	}
		//}
		
		public function getIntParamOfName(nm:String, defVal:int):int{
			if (nm in GameData.data){
				return GameData.data[nm]
			}else{
				GameData.data[nm] = defVal;
				return defVal;
			}
		}
		
		
		public function setIntParamOfName(nm:String, val:int):void{
			GameData.data[nm] = val;
		}
		
		
		public function getParamOfName(nm:String, defVal:String):String{
			if (GameData.data[nm]){
				return GameData.data[nm];
			}else{
				GameData.data[nm] = defVal;
				return defVal;
			}
		}
		
		public function setParamOfName(nm:String, val:String):void{
			GameData.data[nm] = val;
		}
		
		private function initSaves():void 
		{
			// получает сохранённые данные пользователя
			GameData = SharedObject.getLocal(savePath,'/');
			
			//если данных нет (играем в 1й раз) - создаём
			if (!GameData.data.UserInfo) {
				GameData.data.UserInfo = [0,0,0]
			}
			
			hasJustCreatedNewUid = false;
			if (!GameData.data.playerNewUID) {
				var dt:Date = new Date();
				var tm1:Number = dt.time;//просто берём текущий момент, не обрезая его в uint
				var rnd:int = Math.random() * 1000;
				var tmStr:String = tm1.toFixed(0);
				var str0:String = 'PL_'+Main.self.config.platform+'_G_'+Main.self.config.gameId+'_';
				
				//1554794849623 - вот такая строка выдаётся 9 апреля 2019
				for (var i:int = 0; i < 13 - tmStr.length; i++) {
					str0 += '0';
				}	
				str0 += tmStr+'_';//и плюс случайное трёхзначное число
				var rndStr:String = rnd.toString();
				for (i = 0; i < 3 - rndStr.length; i++) {
					str0 += '0';
				}
				str0 += rndStr;
				GameData.data.playerNewUID = str0;//записали	
				
				hasJustCreatedNewUid = true;
			}
			playerNewUID = GameData.data.playerNewUID;
			
			playerName4Score = GameData.data.playerName4Score;
			if (!playerName4Score){
				playerName4Score = "Player_" + playerNewUID.substr(playerNewUID.length - 8)
				GameData.data.playerName4Score = playerName4Score;
			}
			
			playerId4Network = "P"+Main.self.config.platform.charAt(0)+playerNewUID.substr(playerNewUID.length - 17)
			
			
			if (!GameData.data.dataOptInResult){
				GameData.data.dataOptInResult = "unknown";
			}
			if (!GameData.data.allowPeronalizedAds){
				GameData.data.allowPeronalizedAds = "allow";
			}
			
			if (!GameData.data.newsave1) {
				GameData.data.newsave1 = new NewSavedGame(null);
			}
			newSavedGame = new saves.NewSavedGame(GameData.data.newsave1);				
			
			if (!GameData.data.additionalVals) {
				GameData.data.additionalVals = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			}
			
			//чтобы созранить изменения в SharedObject
			doFlush();
			
		}
		
		public function getGlobalDataAr():Array{
			return GameData.data.additionalVals;
		}
		
		public function loadGlobalData(controllersVec:Vector.<PlayersDataController>):void{
			var ar:Array = getArray2LoadGlobalData()
			
			var nxtId:int = 0;
			var len:int = ar[nxtId + 0];
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				var cont:PlayersDataController = controllersVec[i];
				nxtId = cont.loadFromAr(ar, nxtId);
			}
		}
		
		private function getArray2LoadGlobalData():Array 
		{
			var ar:Array = GameData.data.additionalVals;
			var res:Array = ar;
			var ar2:Array = getGlobalArrayFromFile();
			res = getBestArOf2(ar, ar2);
			return res;
		}
		
		public function getBestArOf2(defaultAr:Array, possibleAr:Array):Array{
			var res:Array = defaultAr;
			if (possibleAr){
				if (possibleAr.length > defaultAr.length){
					res = possibleAr;
				}else{
					if (possibleAr.length == defaultAr.length){
						if (Routines.calcNonZeroElems(possibleAr)>Routines.calcNonZeroElems(defaultAr)){
							res = possibleAr;
						}
					}
				}
			}			
			return res;
		}
		
		public function loadArFromFile(path:String):Array
		{
			var res:Array = null;
			Cc.log("loadArFromFile", path);
			var fl:File = File.applicationStorageDirectory.resolvePath(path);
			if (fl.exists){
				try{
					var fs:FileStream = new FileStream();
					fs.open(fl, FileMode.READ);
					var bar:ByteArray = new ByteArray();
					fs.readBytes(bar);
					
					var ar:Array = []
					Routines.readArrayFromByteArray(ar, bar);
					res = ar;
					fs.close();	
				}
				catch (e:Error){
					Cc.log("Error with File loading:",path, e.errorID, e.name, e.message, e.getStackTrace())
					StatsWrapper.stats.logTextWithParams("ERROR_FILE_LOAD",  "PATH:"+path+" ID=" + e.errorID + " name=" + e.name+" message=" + e.message+" trace=" + e.getStackTrace(),3);
				}
			}
			return res;
		}
		
		public function getFileProperties(path:String):Object{
			var res:Object = {};
			
			var fl:File = File.applicationStorageDirectory.resolvePath(path);
			if (fl.exists){
				res.exists = true;
				res.creationDate = fl.creationDate
				res.modificationDate = fl.modificationDate
				res.size = fl.size
			}else{
				res.exists = false;
			}
			
			return res;
		}
		
		
		private function getGlobalArrayFromFile():Array 
		{
			return loadArFromFile(getSavePath4Global());
		}
		
		public function saveGlobalData(controllersVec:Vector.<PlayersDataController>):void{
			var ar:Array = GameData.data.additionalVals;
			var nxtId:int = 0;
			var len:int = controllersVec.length;
			ar[nxtId + 0] = len;
			nxtId++;
			
			for (var i:int = 0; i < controllersVec.length; i++ ){
				var cont:PlayersDataController = controllersVec[i];
				nxtId = cont.save2Ar(ar, nxtId);
			}
			ar[nxtId + 0] = 0;
			ar[nxtId + 1] = 0;
			ar[nxtId + 2] = 0;
			ar[nxtId + 3] = 0;
			ar[nxtId + 4] = 0;
			//doFlush();
			
			saveAr2File(ar, getSavePath4Global())
		}
		
		public function saveAr2File(ar:Array, filePath:String):void 
		{
			Cc.log("saveAr2File", filePath);
			var fl:File = File.applicationStorageDirectory.resolvePath(filePath);
			try{			
				var fs:FileStream = new FileStream();
				fs.open(fl, FileMode.WRITE);
				var bar:ByteArray = new ByteArray();
				Routines.writeArray2ByteArray(ar, bar);
				fs.writeBytes(bar);
				fs.close();	
			}
			catch (e:Error){
				Cc.log("Error with File saving:",filePath, e.errorID, e.name, e.message, e.getStackTrace())
				StatsWrapper.stats.logTextWithParams("ERROR_FILE_SAVE", "PATH:"+filePath+" ID=" + e.errorID + " name=" + e.name+" message=" + e.message+" trace=" + e.getStackTrace(),3);
			}
		}

		public function doFlush():void 
		{
			try
			{
				var flushResult:String = GameData.flush();
				if (flushResult == SharedObjectFlushStatus.PENDING)
				{
					GameData.addEventListener(NetStatusEvent.NET_STATUS, onStatus1);
				}
				else if (flushResult == SharedObjectFlushStatus.FLUSHED)
				{
					//trace('а¦аАаНаНб”аЕ б†б„аПаЕб‘аНаО б„аОб€б‚аАаНаЕаНб”.');
				}
			}
			catch (аЕ:Error)
			{
				//trace('а¶аЕаДаОб„б…аАб…аОб‹аНаО аПаАаМбб…аИ аДаЛб б„аОб€б‚аАаНаЕаНаИб аДаАаНаНб”б€. а¤аНаЕб„аИб…аЕ аИаЗаМаЕаНаЕаНаИб аВ аНаАб„б…б‚аОаЙаКаИ б‡аЛаЕб‘-аПаЛаЕаЕб‚аА.');
				Security.showSettings("localStorage");
			}
			function onStatus1(event:NetStatusEvent):void
			{
				if (event.info.code == "SharedObject.Flush.Success")
				{
					//trace('а¦аАаНаНб”аЕ б†б„аПаЕб‘аНаО б„аОб€б‚аАаНаЕаНб”.');
				}
				else if (event.info.code == "SharedObject.Flush.Failed")
				{
					//trace('а¶аЕ б†аДаАаЛаОб„б• б„аОб€б‚аАаНаИб…б• аДаАаНаНб”аЕ.');
				}
				GameData.removeEventListener(NetStatusEvent.NET_STATUS, onStatus1);
			}			
		}	
		
		//вызывается при деактивации приложения
		static public function safeStore():void 
		{
			if (account) {
				account.doFlush();
			}
		}
		
		public function save2DiscNew():void 
		{
			newSavedGame.replicate2Object(GameData.data.newsave1);
			
			//doFlush();
		}
		
		public function crearSaves(sid:int=0):void 
		{
			if (newSavedGame){
				newSavedGame.clearSave(sid);
			}
		}
		
		public function setCurrentlyLoadedSaveVersion(sv:String):void 
		{
			currentlyLoadedSaveVersion = sv;
		}
		
		public function isCurrentPlayersCodeEqualTo(receiverId:int):Boolean 
		{
			return getMyOwnReceiverId() == receiverId;
		}
		
		public function getMyOwnReceiverId():int{
			//var str:String = playerNewUID;
			var str2:String = playerNewUID.charAt(playerNewUID.length - 5) + playerNewUID.substr(playerNewUID.length - 3, 3);
			trace('str2=',str2)
			trace('int(str2)=',int(str2))
			return int(str2);
		}
		
		public function getSavePath4World(wid:int):String 
		{
			return "worldSave" + "_G_" + Main.self.config.gameId.toString() + '_W_' + wid.toString() +"_P_"+Main.self.config.platformGroup+ ".sav"
		}
		
		public function getBkpSavePath4World(wid:int, slotId:int):String 
		{
			return "worldBackup" + "_G_" + Main.self.config.gameId.toString() + '_W_' + wid.toString()+"_S_"+slotId.toString() +"_P_"+Main.self.config.platformGroup+ ".sav"
		}
		
		private function getSavePath4Global():String 
		{
			return "globalFile" + "_G_" + Main.self.config.gameId.toString()+"_P_"+Main.self.config.platformGroup + ".sav"
		}
		
		public function get numLaunches():int 
		{
			if (cachedNumLaunches==-1){
				cachedNumLaunches = int(getParamOfName("numLaunches", "0"));
			}
			return cachedNumLaunches
		}
		
		public function set numLaunches(value:int):void 
		{
			cachedNumLaunches = value;
			setParamOfName("numLaunches", value.toString());
		}
		
		//public function saveConsent():void 
		//{
		//	GameData.data.dataOptInResult = dataOptInResult;
		//	doFlush();
		//}	
		//указать, что сценарий для данного игрока проёден
		public function setScenarioCompletion(scnCode:String, playerId:int):void{
			var code:String = "scenario_" + scnCode;
			
			var currentCompletions:String = getParamOfName(code, "");
			var ar:Array = currentCompletions.split(",");
			
			var playerStr:String = playerId.toString();
			if (ar.indexOf(playerStr)==-1){
				ar.push(playerStr);
				setParamOfName(code, ar.join(","));
			}
		}
		//пройден ли сценарий для данного игрока
		public function isScenarioCompleted(scnCode:String, playerId:int=-1):Boolean{
			var code:String = "scenario_" + scnCode;
			var currentCompletions:String = getParamOfName(code, "");
			if (currentCompletions==""){
				return false;
			}else{
				if (playerId==-1){
					return true;
				}else{
					var playerStr:String = playerId.toString();
					var ar:Array = currentCompletions.split(",");
					return ar.indexOf(playerStr) !=-1;
				}
			}
		}
	}
}