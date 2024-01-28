package managers 
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import globals.Translator;
	/**
	 * ...
	 * @author ...
	 */
	public class ExternalTranslationsManager 
	{
		private var files2Load:Array;
		private var currentlyLoadeFileId:int = 0;
		
		public function ExternalTranslationsManager() 
		{
			
		}
		public function loadTranslationsFromDirectory(path:String):void{
			var scnCat:File = File.applicationDirectory.resolvePath(path);
			if (scnCat.exists){
				scnCat.addEventListener(FileListEvent.DIRECTORY_LISTING, onScenariosListingMade);
				scnCat.getDirectoryListingAsync();
			}			
		}
		
		private function onScenariosListingMade(e:FileListEvent):void 
		{
			files2Load = e.files;
			currentlyLoadeFileId = 0;
			loadNextFileFromList()
		}
		
		private function loadNextFileFromList():void 
		{
			var scnCat:File = files2Load[currentlyLoadeFileId];
			var mustSkipFile:Boolean = true;
			if (!scnCat.isDirectory){
				var fs:FileStream = new FileStream();
				fs.addEventListener(Event.COMPLETE, onFileStreamCoplete);
				fs.openAsync(scnCat, FileMode.READ);	
				mustSkipFile = false;
			}
			if (mustSkipFile){
				proceed2LoadingNext();
			}
		}
		
		private function proceed2LoadingNext():void 
		{
			currentlyLoadeFileId++;
			if (currentlyLoadeFileId < files2Load.length){
				loadNextFileFromList();
			}else{
				//hasCompletedScenariosListing = true;
				trace("loaded translations!")
				Translator.translator.doOnAllTranslationsLoaded();
			}							
		}
		
		private function onFileStreamCoplete(e:Event):void 
		{
			var fs:FileStream = e.target as FileStream;
			
			var str:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			
			try{
				var scnOb:Object = JSON.parse(str);
			}catch (e:Error){
				//Cc.log('ERROR');
				scnOb = null;
			}
			if (scnOb){
				Translator.translator.addExternatTranslationFromJSON(scnOb);
			}
			
			proceed2LoadingNext();			
		}		
	}

}