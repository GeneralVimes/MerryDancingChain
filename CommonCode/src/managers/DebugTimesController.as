package managers  
{
	import com.junkbyte.console.Cc;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author General
	 */
	public class DebugTimesController 
	{

		private var debugMachineTypesTimes:Array = [];
		private var debugMachineTypesCalls:Array = [];		
		
		private var phasesNames:Array = [];
		
		private var nowLoggedFunctionId:int = 0;
		private var tm0:uint;
		
		private var timeOfStart:uint = getTimer();
		private var timeOfLastLog:uint;
		private var timeBetweenLogs:Number = 5;//sec;
		
		private var timesOfPhasesStarts:Array = [];
		private var IDsOfPhases:Array = [];
		
		private var enabledLogTime:uint = 0;
		private var isLogEnabled:Boolean = true;
		
		private var timeOfLastReset:uint = 0;
		
		public var lastActionDeltaTime:int = 0;
		public function DebugTimesController() 
		{
			timeOfLastLog = timeOfStart;
		}
		
		public function prepare2LogTimeOfFunction(fid:int, str:String = ''):void{
			if (!isLogEnabled){	return;	}
			//trace('prepare2LogTimeOfFunction', fid, IDsOfPhases.length);
			//trace('stack now: ',IDsOfPhases);
			tm0 = getTimer();
			timesOfPhasesStarts.push(tm0);
			IDsOfPhases.push(fid);
			if (fid >= debugMachineTypesCalls.length){
				debugMachineTypesCalls[fid] = 0;
				debugMachineTypesTimes[fid] = 0;
				phasesNames[fid] = str;
			}else{
				if (debugMachineTypesCalls[fid] == null){
					debugMachineTypesCalls[fid] = 0;
					debugMachineTypesTimes[fid] = 0;
					phasesNames[fid] = str;
				}
			}
			nowLoggedFunctionId = fid;
		}
		
		public function copleteLogTimeOfFunction():void{
			if (!isLogEnabled){	return;	}
			//trace('copleteLogTimeOfFunction');
			//trace('stack now: ',IDsOfPhases);			
			var tm:uint = getTimer();
			var myTm0:uint = timesOfPhasesStarts.pop();
			var myId:int = IDsOfPhases.pop();
			
			lastActionDeltaTime = tm - myTm0
			//trace('extracting',myId);
			debugMachineTypesCalls[myId]++;
			debugMachineTypesTimes[myId] += lastActionDeltaTime;
			
			if (tm - timeOfLastLog >= timeBetweenLogs * 1000){
				if (timesOfPhasesStarts.length == 0){
					logTimes();
					timeOfLastLog = tm;					
				}

			}
		}
		
		public function logTimes():void{
			if (!Main.self.config.isConsoleShowing){
				//trace('---------------------------------------');
				for (var i:int = 0; i < debugMachineTypesCalls.length; i++){
					if (debugMachineTypesCalls[i] != null){
						trace(i, phasesNames[i], ' calls:', debugMachineTypesCalls[i], 'times:', debugMachineTypesTimes[i], 'ratio:', debugMachineTypesTimes[i] / debugMachineTypesCalls[i]);
					}
				}
				//trace('=======================================');				
			}else{
				Cc.log('---------------------------------------');
				for (i = 0; i < debugMachineTypesCalls.length; i++){
					if (debugMachineTypesCalls[i] != null){
						Cc.log(i, phasesNames[i], ' calls:', debugMachineTypesCalls[i], 'times:', debugMachineTypesTimes[i], 'ratio:', debugMachineTypesTimes[i] / debugMachineTypesCalls[i]);
					}
				}
				Cc.log('=======================================');									
			}
			

		}
		
		public function enableLoggingAfter(tm:Number):void 
		{
			if (getTimer() > tm * 1000){
				isLogEnabled = true;
			}
		}
		
		public function setLogEnabled(b:Boolean):void{
			isLogEnabled = b;
		}
		
		
		public function resetAggregatesSumsEvery(dt:Number):void{
			var tm1:uint = getTimer();
			if (tm1 - timeOfLastReset > dt * 1000){
				doReset();
				timeOfLastReset = tm1;
			}
		}
		
		private function doReset():void 
		{
			phasesNames.length = 0;
			IDsOfPhases.length = 0;
			timesOfPhasesStarts.length = 0;
			debugMachineTypesCalls.length = 0;
			debugMachineTypesTimes.length = 0;
		}
	}

}