package gameplay.worlds.service.tut 
{
	import gameplay.basics.BasicGameObject;
	import gameplay.worlds.World;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class TutorialSprite extends Sprite
	{
		
		public var completionFunction:Function;
		public var completionFunctionParams:Array;
		public var completionFunctionCaller:*;

		public var myObject:BasicGameObject;
		public var myWorld:World;
		public var wasPerformed:Boolean = false;
		public var lifeTime:Number = 0;
		private var nextCheckTime:Number = 0;
		
		public var cycleLength:Number = 1;
		public var lambda:Number = 0;		
		public function TutorialSprite(wrl:World, par:DisplayObjectContainer, ob:BasicGameObject, func:Function,fParams:Array,fCaller:*, paramOb:Object) 
		{
			this.myWorld = wrl;
			this.myObject = ob;
			this.completionFunction = func;
			this.completionFunctionParams = fParams;
			this.completionFunctionCaller = fCaller;
			if (par){
				par.addChild(this);
			}
			
			
			touchable = false;
			touchGroup = true;
		}
		
		public function doAnimStep(dt:Number):void 
		{
			lifeTime+= dt;
			this.lambda = (this.lifeTime % this.cycleLength) / this.cycleLength;
			
			if (lifeTime >= nextCheckTime){
				checkCompletionFunction();
				nextCheckTime+= 1;		
			}
		}
		
		protected function checkCompletionFunction():void 
		{
			if (completionFunction){
				var b:Boolean = false;
				if (completionFunctionParams){
					b = this.completionFunction.apply(completionFunctionCaller,completionFunctionParams)
				}else{
					b = this.completionFunction()
				}
				
				if (b){
					this.wasPerformed = true;
				}
			}			
		}
		
		public function getRemoved():void 
		{
			removeFromParent();
		}
		
	}

}