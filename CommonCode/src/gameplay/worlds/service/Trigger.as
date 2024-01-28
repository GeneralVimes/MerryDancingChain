package gameplay.worlds.service 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Trigger 
	{
		private var checkCompletionFunction:Function;
		private var checkCompletionFunctionParams:Array;
		private var checkCompletionFunctionCaller:*;
		private var resultFunction:Function;
		private var resultFunctionParams:Array;
		private var resultFunctionCaller:*;
		public var uid:int;
		public var wasCompleted:Boolean = false;
		public var controller:TriggerController;
		
		public function Trigger(propsObj:Object) 
		{
			this.checkCompletionFunction = propsObj.checkCompletionFunction;
			this.checkCompletionFunctionParams=propsObj.checkCompletionFunctionParams;
			this.checkCompletionFunctionCaller =propsObj.checkCompletionFunctionCaller;
			
			this.resultFunction = propsObj.resultFunction;
			this.resultFunctionParams = propsObj.resultFunctionParams;
			this.resultFunctionCaller = propsObj.resultFunctionCaller;
			
			this.uid = propsObj.uid;
			
		}
		
		public function checkCompletionCondition():void 
		{
			if (this.checkCompletionFunctionParams){
				var res:int = this.checkCompletionFunction.apply(this.checkCompletionFunctionCaller, this.checkCompletionFunctionParams)
			}else{
				res = this.checkCompletionFunction();
			}
			
			if (res == 1){//выполняем условие
				this.wasCompleted = true;
				if (this.resultFunctionParams){
					this.resultFunction.apply(this.resultFunctionCaller, this.resultFunctionParams)
				}else{
					this.resultFunction();
				}
			}
			
			if (res == 2){//просто убираем
				this.wasCompleted = true;
			}
			
		}
		
	}

}