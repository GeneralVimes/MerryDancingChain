package managers 
{
	import com.junkbyte.console.Cc;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import globals.PlayersAccount;
	/**
	 * ...
	 * @author General
	 */
	public class ModsManager 
	{
		public var hasCompletedModListing:Boolean;
		
		public var modsObs:Array;
		
		private var currentlyLoadeFileId:int = 0;
		private var files2Load:Array;
		
		public var selectedModId:int = -1;
		public function ModsManager() 
		{
			modsObs = [];
		}
		public function listAllMods():void{
			var modsCat:File = File.applicationDirectory.resolvePath("mods/");
			if (modsCat.exists){
				modsCat.addEventListener(FileListEvent.DIRECTORY_LISTING, onModsListingMade);
				modsCat.getDirectoryListingAsync();					
			}else{
				hasCompletedModListing = true;
			}					
		}
		
		private function onModsListingMade(e:FileListEvent):void 
		{
			files2Load=e.files
			trace(files2Load.length);
			
			for (var i:int = files2Load.length - 1; i >= 0; i-- ){
				if (!e.files[i].isDirectory){
					files2Load.splice(i, 1);
				}
			}
			
			if (files2Load.length>0){
				loadNextFileFromList()
			}else{
				hasCompletedModListing = true;
				defineCurrentModFromPreviouslyPlayed();				
			}
			
			
		}
		
		private function loadNextFileFromList():void 
		{
			var mapFile:File = files2Load[currentlyLoadeFileId].resolvePath("info.json"); 
			if (mapFile.exists){
				var fs:FileStream = new FileStream();
				fs.addEventListener(Event.COMPLETE, onFileStreamCoplete);
				fs.openAsync(mapFile, FileMode.READ);				
			}

			
		}
		
		private function onFileStreamCoplete(e:Event):void 
		{
			var fs:FileStream = e.target as FileStream;
			
			var str:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			
			try{
				var modsOb:Object = JSON.parse(str);
			}catch (e:Error){
				Cc.log('ERROR');
				modsOb = null;
			}
			if (modsOb){
				modsObs.push({
					folder:files2Load[currentlyLoadeFileId].name,
					modname:modsOb.modname,
					author:modsOb.author,
					description:modsOb.description,
					version:modsOb.version			
				})
			}
			
			currentlyLoadeFileId++;
			if (currentlyLoadeFileId < files2Load.length){
				loadNextFileFromList();
			}else{
				hasCompletedModListing = true;
				defineCurrentModFromPreviouslyPlayed();
			}			
		}
		//проверяем, есть ли в текущем списке модов тот, который играли в прошлый раз.
		//если вдргу его удалили, то ставим none
		public function defineCurrentModFromPreviouslyPlayed():void 
		{
			//на старте PlayerAccount ещё не существует. Ну и ОК. Не будем его трогать
			//selectedModId = this.findModIdOfFolder(PlayersAccount.account.getParamOfName("lastModPlayed", "none"));
			//if (selectedModId==-1){
			//	PlayersAccount.account.setParamOfName("lastModPlayed", "none")
			//}
			
		}
		
		public function getSelectedModFolder():String {
			if (selectedModId==-1){
				return "none"
			}else{
				return modsObs[selectedModId].folder;
			}			
		}
		public function getSelectedModDescription():String 
		{
			if (selectedModId==-1){
				return "";
			}else{
				return modsObs[selectedModId].description;
			}
		}
		
		public function getSelectedModName():String 
		{
			if (selectedModId==-1){
				return "TXID_CAP_NOMOD";
			}else{
				return modsObs[selectedModId].modname +" v." + modsObs[selectedModId].version +" by " + modsObs[selectedModId].author;
			}
		}
		public function getSelectedModAuthor():String 
		{
			if (selectedModId==-1){
				return "";
			}else{
				return modsObs[selectedModId].author;
			}
		}
		
		public function setPrevSelectedModId():void{
			selectedModId--;
			if (selectedModId<-1){
				selectedModId = modsObs.length - 1;
			}
		}
		
		public function setNextSelectedModId():void{
			selectedModId++;
			if (selectedModId>=modsObs.length){
				selectedModId = -1;
			}
		}
		
		public function setPreviousSelectedMod(modFolder:String):void 
		{
			selectedModId = this.findModIdOfFolder(modFolder);
		}
		
		private function findModIdOfFolder(fld:String):int 
		{
			var res:int = -1;
			for (var i:int = 0; i < modsObs.length; i++ ){
				if(modsObs[i].folder==fld){
					res = i;
					break;
				}
			}
			return res;
		}
	}
}