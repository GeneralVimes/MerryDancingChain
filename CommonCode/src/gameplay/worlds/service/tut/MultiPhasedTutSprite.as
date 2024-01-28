package gameplay.worlds.service.tut 
{
	import gameplay.basics.BasicGameObject;
	import gameplay.worlds.World;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MultiPhasedTutSprite extends TutorialSprite 
	{
		private var currentPhase:int;
		private var numPhases:int;
		//функции, которые включают следующую фазу и которые откатывают на предыдущую
		private var phasesFunctions:Array;//Function:TutorialSprite
		//проверка, выполнилась ли текущая фаза
		private var nextCheckFunctions:Array;
		private var nextCheckFunctionsParams:Array;
		private var nextCheckFunctionsCallers:Array;
		//или надо откатиться на предыдущую
		private var prevCheckFunctions:Array;
		private var prevCheckFunctionsParams:Array;
		private var prevCheckFunctionsCallers:Array;
		
		private var currentSubTut:TutorialSprite;
		public function MultiPhasedTutSprite(wrl:World, funcsPhases:Array,funcsNext:Array, funcsPrev:Array, paramOb:Object=null, fParamsNext:Array=null, fCallersNext:Array=null, fParamsPrev:Array=null, fCallersPrev:Array=null) 
		{
			super(wrl, null, null, null, null, null, null);
			
			phasesFunctions = funcsPhases;
			nextCheckFunctions = funcsNext;
			nextCheckFunctionsParams = fParamsNext;
			nextCheckFunctionsCallers = fCallersNext;
			prevCheckFunctions = funcsPrev;
			prevCheckFunctionsParams = fParamsPrev;
			prevCheckFunctionsCallers = fCallersPrev;
			
			if (!nextCheckFunctionsParams){
				nextCheckFunctionsParams = [];
				for (var i:int = 0; i < phasesFunctions.length; i++){
					nextCheckFunctionsParams.push(null);
				}
			}
			if (!nextCheckFunctionsCallers){
				nextCheckFunctionsCallers = [];
				for (i = 0; i < phasesFunctions.length; i++){
					nextCheckFunctionsCallers.push(null);
				}
			}
			if (!prevCheckFunctionsParams){
				prevCheckFunctionsParams = [];
				for (i = 0; i < phasesFunctions.length; i++){
					prevCheckFunctionsParams.push(null);
				}
			}
			if (!prevCheckFunctionsCallers){
				prevCheckFunctionsCallers = [];
				for (i = 0; i < phasesFunctions.length; i++){
					prevCheckFunctionsCallers.push(null);
				}
			}
			
			currentPhase = 0;
			numPhases = funcsPhases.length;
			showCurrentPhaseSubTut();
		}
		
		private function showCurrentPhaseSubTut():void 
		{
			currentSubTut = phasesFunctions[currentPhase]();
		}
		//вызывается раз в секунду
		override protected function checkCompletionFunction():void 
		{
			//super.checkCompletionFunction();
			//без супера
			var canGoNext:Boolean = false;
			var canGoPrev:Boolean = false;
			if (nextCheckFunctionsParams[currentPhase]){
				canGoNext = this.nextCheckFunctions[currentPhase].apply(nextCheckFunctionsCallers[currentPhase],nextCheckFunctionsParams[currentPhase])
			}else{
				canGoNext = this.nextCheckFunctions[currentPhase]()
			}
			
			if (!canGoNext){
				if (currentPhase > 0){
					if (this.prevCheckFunctions[currentPhase]){
						if (prevCheckFunctionsParams[currentPhase]){
							canGoPrev = this.prevCheckFunctions[currentPhase].apply(prevCheckFunctionsCallers[currentPhase],prevCheckFunctionsParams[currentPhase])
						}else{
							canGoPrev = this.prevCheckFunctions[currentPhase]()
						}							
					}
				
				}
			}
			
			if (canGoNext||canGoPrev){
				//убираем текущую подсказку
				if (currentSubTut){
					currentSubTut.wasPerformed = true;
				}
				
				if (canGoNext){
					currentPhase++;
				}else{
					currentPhase--;
					///Надо ли ???
					//и проверяем ещё раз, не откатилось ли ещё назад
					//checkCompletionFunction();
				}
				
				//
				if (currentPhase<numPhases){
					//показываем подсказку по currentPhase
					showCurrentPhaseSubTut();
				}else{
					//завершаем всё
					this.wasPerformed = true;
				}
			}
		}
		override public function doAnimStep(dt:Number):void 
		{
			super.doAnimStep(dt);
		}
		override public function getRemoved():void 
		{
			super.getRemoved();
		}
	}

}