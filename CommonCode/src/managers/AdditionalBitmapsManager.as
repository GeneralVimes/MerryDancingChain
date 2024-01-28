package managers 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class AdditionalBitmapsManager 
	{
		private var maps:Vector.<flash.display.Loader>;
		private var files2Load:Array;
		private var currentlyLoadeFileId:int = 0;
		
		public var availableBitmapObjects:Vector.<Object>;
		public function AdditionalBitmapsManager() 
		{
			availableBitmapObjects = new Vector.<Object>();
		}
		
		public function loadBitmapsFromDirectory(path:String):void 
		{
			maps = new Vector.<Loader>();
			var mapsCat:File = File.applicationDirectory.resolvePath(path);
			if (mapsCat.exists){
				mapsCat.addEventListener(FileListEvent.DIRECTORY_LISTING, onMapsListingMade);
				mapsCat.getDirectoryListingAsync();					
			}
		}
		
		private function onMapsListingMade(e:FileListEvent):void 
		{
			files2Load = e.files;
			loadNextFileFromList()
			////trace(ar);
			//for (var i:int = 0; i < ar.length; i++ ){
			//	var mapFile:File = ar[i];
			//	var fs:FileStream = new FileStream();
			//	//fs.addEventListener(Event.COMPLETE
			//	fs.open(mapFile, FileMode.READ);
			//	var bar:ByteArray = new ByteArray();
			//	fs.readBytes(bar);
			//	
			//	var ldr:Loader = new Loader();
			//	ldr.loadBytes(bar);		
			//	maps.push(ldr);
			//}
		}		
		
		private function loadNextFileFromList():void 
		{
			var mapFile:File = files2Load[currentlyLoadeFileId];
			var fs:FileStream = new FileStream();
			fs.addEventListener(Event.COMPLETE, onFileStreamCoplete);
			fs.openAsync(mapFile, FileMode.READ);
			
		}
		
		private function onFileStreamCoplete(e:Event):void 
		{
			var fs:FileStream = e.target as FileStream;
			var bar:ByteArray = new ByteArray();
			fs.readBytes(bar);
			fs.close();
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.INIT, onLoaderComplete);
			ldr.loadBytes(bar);
		}
		
		private function onLoaderComplete(e:Event):void 
		{
			var ldr:Loader = (e.target as LoaderInfo).loader;
			maps.push(ldr);
			
			var bmd:BitmapData = (ldr.content as Bitmap).bitmapData;
			var nm:String = files2Load[currentlyLoadeFileId].name;
			var dotPos:int = nm.lastIndexOf(".");
			if (dotPos !=-1){
				nm = nm.substr(0, dotPos);
			}
			
			var ob:Object = {
				data:bmd,
				width:bmd.width,
				height:bmd.height,
				id:currentlyLoadeFileId, 
				name:nm
			}
			availableBitmapObjects.push(ob);
			
			currentlyLoadeFileId++;
			if (currentlyLoadeFileId < files2Load.length){
				loadNextFileFromList();
			}
		}
	}

}