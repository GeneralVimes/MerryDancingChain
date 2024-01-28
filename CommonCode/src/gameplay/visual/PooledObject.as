package gameplay.visual 
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class PooledObject extends Sprite
	{
		public var isInPool:Boolean;
		public function PooledObject() 
		{
			isInPool = true;
		}
		
		public function back2Pool():void{
			isInPool = true;
			visible = false;
		}
		
		public function setProperties(ax:Number, ay:Number, par:starling.display.DisplayObjectContainer, props:Object):void 
		{
			
		}
		
	}

}