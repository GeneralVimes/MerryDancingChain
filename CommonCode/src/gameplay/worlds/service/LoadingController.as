package gameplay.worlds.service 
{
	import com.junkbyte.console.Cc;
	import flash.utils.getTimer;
	import gameplay.worlds.World;
	import globals.StatsWrapper;
	/**
	 * ...
	 * @author ...
	 */
	public class LoadingController 
	{
		private var maxTm4LoadFrame:int = 30;
		private var timeSpent4Loading:uint;
		
		public var isLoading:Boolean = false;
		private var world:World;
		
		private var nowReadIndex:int;
		
		private var bkpAr4Loading:Array=null;
		
		private var ar2Read:Array = null;
		
		private var numBigVecs2Fill:int = 0;
		private var currentlyFilledBigVectorId:int = -1;
		private var numObjectsInVec2Load:int = 0;
		private var currentlyCreatedObjectInVec:int = 0;
		private var preCompletionCallBack:Function;
		private var afterCompletionCallBack:Function;
		
		public function LoadingController(w:World) 
		{
			world = w;
		}
		
		public function startLoadingVectorsOfObjectsFromAr(ar:Array, nxtId:int):void 
		{
			//запускаем процесс загрузки объектов, по окончании вызовем у мира afterLoadFunction
			nowReadIndex = nxtId;
			numBigVecs2Fill = ar[nowReadIndex + 0];
			nowReadIndex++;
		}
		
		public function initializeLoadingfromOb(ob:Object, bkpAr:Array=null, preComplFunc:Function=null, aftComlFunc:Function=null):void {
			ar2Read = ob["vectorsObs"];
			nowReadIndex = 0;
			isLoading = true;
			bkpAr4Loading = bkpAr;	
			
			preCompletionCallBack = preComplFunc;
			afterCompletionCallBack = aftComlFunc;
			
			numBigVecs2Fill = 0;
			currentlyFilledBigVectorId = -1;
			numObjectsInVec2Load = 0;
			currentlyCreatedObjectInVec = 0;
			
			this.world.prepare2LoadNew();
			
			try{
				this.world.startLoadingFromOb(ob);
				startLoadingVectorsOfObjectsFromAr(ar2Read, 0);
			}catch (e:Error){
				StatsWrapper.stats.logTextWithParams('ERROR_IN_LOADING_BEGINNING_OBJECT', "nowReadIndex:" + nowReadIndex + " ID=" + e.errorID + " name=" + e.name+" message=" + e.message+" trace=" + e.getStackTrace(), 3);
				emergencyStopLoading();
			}			
		}
		public function initializeLoading(ar:Array, bkpAr:Array=null, preComplFunc:Function=null, aftComlFunc:Function=null):void 
		{
			ar2Read = ar;
			nowReadIndex = 0;
			isLoading = true;
			bkpAr4Loading = bkpAr;
			
			preCompletionCallBack = preComplFunc;
			afterCompletionCallBack = aftComlFunc;
			
			numBigVecs2Fill = 0;
			currentlyFilledBigVectorId = -1;
			numObjectsInVec2Load = 0;
			currentlyCreatedObjectInVec = 0;	
			
			this.world.prepare2LoadNew();
			
			try{
				nowReadIndex = this.world.startLoadingFromAr(ar,0);
				startLoadingVectorsOfObjectsFromAr(ar, nowReadIndex);
			}catch (e:Error){
				StatsWrapper.stats.logTextWithParams('ERROR_IN_LOADING_BEGINNING', "nowReadIndex:" + nowReadIndex + " ID=" + e.errorID + " name=" + e.name+" message=" + e.message+" trace=" + e.getStackTrace(), 3);
				emergencyStopLoading();
			}
			//this.world.loadFromAr(ar, 0);
		}
		
		public function initializeLoadingFromBackup():void 
		{
			if (bkpAr4Loading){
				initializeLoading(bkpAr4Loading, null);
			}
		}
		
		public function doLoadingStep():void 
		{
			var tm0:uint = getTimer();
			//trace('doLoadingStep',nowReadIndex);
			timeSpent4Loading = 0;
			while (isLoading && (timeSpent4Loading < maxTm4LoadFrame)){
				//Cc.log("while (isLoading || (timeSpent4Loading < maxTm4LoadFrame)){");
				//Cc.log("isLoading=",isLoading);
				//Cc.log("timeSpent4Loading=",timeSpent4Loading);
				if (currentlyCreatedObjectInVec >= numObjectsInVec2Load){
					startLoadingNextVector();
				}else{
					startLoadingNextObject();
				}	
				timeSpent4Loading = getTimer() - tm0;
			}
		}
		
		private function startLoadingNextObject():void 
		{
			//trace('startLoadingNextObject',nowReadIndex);
			try{
				nowReadIndex = world.loadObjectFromSave(ar2Read, nowReadIndex, currentlyCreatedObjectInVec, currentlyFilledBigVectorId);
			}
			catch (e:Error){
				StatsWrapper.stats.logTextWithParams('ERROR_IN_LOADING', "nowReadIndex:" + nowReadIndex + " ID=" + e.errorID + " name=" + e.name+" message=" + e.message+" trace=" + e.getStackTrace(), 3);
				emergencyStopLoading();
			}
			currentlyCreatedObjectInVec++;
		}
		
		public function emergencyStopLoading():void 
		{
			isLoading = false;
			world.emergencyStopLoading(bkpAr4Loading);
		}
		
		public function getCurrentlyLoadedArray():Array 
		{
			return ar2Read
		}

		
		private function startLoadingNextVector():void 
		{
			//Cc.log('startLoadingNextVector',nowReadIndex);
			currentlyFilledBigVectorId++;
			//Cc.log("currentlyFilledBigVectorId=",currentlyFilledBigVectorId);
			
			if (currentlyFilledBigVectorId >= numBigVecs2Fill){
				finishLoading()
			}else{
				numObjectsInVec2Load = ar2Read[nowReadIndex];
				nowReadIndex++;
				currentlyCreatedObjectInVec = 0;
			}
		}
		
		private function finishLoading():void 
		{
			//Cc.log('finishLoading');
			
			//будет 2 коллбека: выполняемые перед afterLoadFunction и после react2LoadingFinished
			//изначально нужда была в функции, что локализует названия стран в циве сразу после загрузки, до того, как создадутся графические объекты на экране
			if (preCompletionCallBack){
				preCompletionCallBack();
			}
			
			world.afterLoadFunction();
			isLoading = false;
			world.react2LoadingFinished();
			
			if (afterCompletionCallBack){
				afterCompletionCallBack();
			}			
		}
		
		public function hasBackup():Boolean 
		{
			return bkpAr4Loading != null;
		}
		
	}

}