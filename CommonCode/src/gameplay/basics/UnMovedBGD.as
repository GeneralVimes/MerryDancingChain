package gameplay.basics 
{
	import gameplay.worlds.World;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class UnMovedBGD extends Sprite
	{
		protected var myWorld:World;
		public function UnMovedBGD(wrl:World) 
		{
			this.myWorld = wrl;
		}
		//эта функция, похоже,ниоткуда не вызывается...
		public function react2ParallaxAndScale(xFrac:Number, yFrac:Number, sFrac:Number):void 
		{
			
		}
		
		public function react2NewVisPos(vx:Number, vy:Number, vs:Number):void 
		{
			
		}		
	}

}