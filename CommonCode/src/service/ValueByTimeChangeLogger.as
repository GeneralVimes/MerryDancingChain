package service 
{
	/**
	 * ...
	 * @author ...
	 */
	public class ValueByTimeChangeLogger 
	{
		public var isLogging:Boolean = false;

		//private var numRecords:int = 0;
		
		private var timeOfThisContainerStart:Number = 0;
		private var timeOfThisContainerEnd:Number = 0;
		private var timeDelta:Number = 1;
		
		private var lastContainerVal:Number = 0;
		private var lastContainerDuration:Number = 1;
		private var thisContainerVal:Number = 0;
		
		private var lastRes:Number = 0;
		private var arOrResults:Array = [];
		private var res2Show:Number = 0;
		public function ValueByTimeChangeLogger(num:int=10, dt:Number=1) 
		{
			timeDelta = dt;
			for (var i:int = 0; i < num; i++ ){
				arOrResults.push(0);
			}
		}
		
		public function setNewLogParams(num:int = 10, dt:Number = 1):void{
			timeDelta = dt;
			while (num > arOrResults.length){
				arOrResults.push(0);
			}
			arOrResults.length = num;
		}
		
		public function recordDelta(val:Number, time:Number):void{
			if (isLogging){
				trace('recordDelta val=', val, 'time=', time);
			}
			var mustShiftAr:Boolean = false;
			if (time<timeOfThisContainerStart+timeDelta){
				thisContainerVal += val;
				timeOfThisContainerEnd = time;
			}else{
				mustShiftAr = true;
				lastContainerDuration = timeDelta;
				if (time < timeOfThisContainerStart + timeDelta + timeDelta){
					timeOfThisContainerStart = timeOfThisContainerStart + timeDelta;
					timeOfThisContainerEnd = time;
					
					lastContainerVal = thisContainerVal;
					thisContainerVal = val;
				}else{
					timeOfThisContainerStart = time;
					timeOfThisContainerEnd = time;
					
					lastContainerVal = 0;
					thisContainerVal = val;
				}
				//lastRes = this.getCurrentSpeed();
			}
			
			
			if (mustShiftAr){

				
				//var res:Number = (lastContainerVal + thisContainerVal) / (lastContainerDuration + timeOfThisContainerEnd - timeOfThisContainerStart);
				var res:Number = (lastContainerVal) / (lastContainerDuration);
				//res = res * 0.9 + lastRes * 0.1;
				lastRes = res;
				
				var removedRes:Number = arOrResults[0]
				for (var i:int = 0; i < arOrResults.length - 1; i++ ){
					arOrResults[i] = arOrResults[i + 1];
				}
				arOrResults[arOrResults.length - 1] = lastRes;
				res2Show += (lastRes - removedRes) / arOrResults.length;	
							
			}

			
			
			
			if (isLogging){
				trace('lastContainerVal=', lastContainerVal, 'lastContainerDuration=', lastContainerDuration, 'thisContainerVal=', thisContainerVal, 'thisContainerDuration=', timeOfThisContainerEnd - timeOfThisContainerStart)
				trace(arOrResults)
				trace(removedRes)
				trace('removedRes=',removedRes,'lastRes=',lastRes,'res2Show=',res2Show)
			}
		}
		
		public function getCurrentSpeed(tm:Number):Number{
			recordDelta(0, tm);
			
			
			
			
			return res2Show;
		}
	}

}