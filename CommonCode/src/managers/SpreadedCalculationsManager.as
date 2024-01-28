package managers
{
	import com.junkbyte.console.Cc;
	import flash.utils.getTimer;
	import gameplay.worlds.World;
	/**
	 * ...
	 * @author ...
	 */
	public class SpreadedCalculationsManager 
	{
		private var world:World;
		private var funcsAndArgs:Array;
		private var isRunning:Boolean = false;
		
		private var ob4Analytics:Object;
		private var isAnalyzingPerformance:Boolean = false//*/true;
		
		private var arOfUnfoldingFunctions2Register:Array;
		private var isRegisteringUnfoldingFunctions:Boolean = false;
		
		private var numProcessed:int;
		private var numAdded:int;
		public function SpreadedCalculationsManager(wrl:World) 
		{
			world = wrl;
			funcsAndArgs = new Array();
			ob4Analytics = {};
		}
		
		public function hasSomething2Do():Boolean
		{
			return funcsAndArgs.length>0;
		}
		
		public function doCalculationsOnFrame():void 
		{
			var tm:uint = getTimer();
			var timeElapsed:uint = 0;
			while (hasSomething2Do() && (timeElapsed < 30)){
				var tm1:uint = getTimer();
				var ob:Object = funcsAndArgs.shift();
				//trace('calling function ', ob.code)
				numProcessed++;
				if (ob.arOfArgs){
					ob.func.apply(ob.caller, ob.arOfArgs)
				}else{
					ob.func();
				}
				var tm2:uint = getTimer();
				var timeFunction:uint = tm2 - tm1;
				
				timeElapsed += timeFunction;
				
				if (isAnalyzingPerformance){
					var dataOb:Object = ob4Analytics[ob.code];
					if (!dataOb){
						dataOb = {calls:0, time:0};
						ob4Analytics[ob.code] = dataOb;
					}
					dataOb.calls++;
					dataOb.time+= timeFunction;
				}
			}
			world.showSpreadedCalculationsProgress(numProcessed, numAdded);
			//trace('doCalculationsOnFrame', timeElapsed, numProcessed.toString()+"/"+numAdded.toString(), (numProcessed/numAdded).toFixed(3))
			if (!hasSomething2Do()){
				returnCommand2World();
			}
			
		}
		
		private function returnCommand2World():void 
		{
			if (isAnalyzingPerformance){
				var str:String = "=========================\n"
				for (var code:String in ob4Analytics){
					var dataOb:Object = ob4Analytics[code];
					str += '\n' + code+"	calls:	" + dataOb.calls + '	time:	' + dataOb.time;
				}
				str+=("\n-------------------------")					
				
				if (!Main.self.config.isConsoleShowing){
					trace(str);
				}else{
					Cc.log(str)
				}

			}
			world.showSpreadedCalculationsEnd();
			world.continueAfterSpreadedCalculation();
		}
		
		//если мы сейчас набираем массив последовательностей, то достраиваем его, 
		//а если мы при выполнении распределённой функции опять захотели какую-то функцию поставить в очередь
		//то её надо будет ставить в начало
		public function registerFunction(code:String, func:Function, caller:Object = null,  arOfArgs:Array=null):void 
		{
			var ob:Object = {code:code, func:func, caller:caller, arOfArgs:arOfArgs};
			numAdded++;
			if (isRegisteringUnfoldingFunctions){
				arOfUnfoldingFunctions2Register.push(ob)
			}else{
				if (isRunning){
					funcsAndArgs.unshift(ob);
				}else{
					funcsAndArgs.push(ob)
				}				
			}
		}
		
		public function prepare2RegisterFunctions():void 
		{
			isRunning = false;
			funcsAndArgs.length = 0;
			
			numProcessed = 0;
			numAdded = 0;
			world.showSpreadedCalculationsStart();
		}	
		
		public function start2PerformFunctions():void 
		{
			isRunning = true;
			if (isAnalyzingPerformance){
				ob4Analytics = {};
			}
		}
		
		public function prepare2RegisterUnfoldingFunctions():void 
		{
			arOfUnfoldingFunctions2Register = [];
			isRegisteringUnfoldingFunctions = true;
		}
		
		public function finalize2RegisterUnfoldingFunctions():void 
		{
			for (var i:int = arOfUnfoldingFunctions2Register.length - 1; i >= 0; i-- ){
				var ob:Object = arOfUnfoldingFunctions2Register[i];
				funcsAndArgs.unshift(ob);
			}
			
			isRegisteringUnfoldingFunctions = false;
		}
		
		public function stopAllCalculations():void 
		{
			isRunning = false;
			funcsAndArgs.length = 0;
		}

		
	}

}