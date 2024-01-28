package gameplay.basics 
{
	import flash.geom.Rectangle;
	import gameplay.worlds.World;
	/**
	 * ...
	 * @author ...
	 */
	public class RectangularUnMovedBGD extends UnMovedBGD
	{
		protected var maxBoundsRectInWorld:Rectangle = new Rectangle();
		protected var maxBoundsRectOnScreen:Rectangle = new Rectangle();
		protected var tmpRct:Rectangle = new Rectangle();
		public function RectangularUnMovedBGD(wrl:World, x0:Number, x1:Number, y0:Number, y1:Number) 
		{
			super(wrl);
			maxBoundsRectInWorld.left = x0;
			maxBoundsRectInWorld.right = x1;
			maxBoundsRectInWorld.top = y0;
			maxBoundsRectInWorld.bottom = y1;
			
			updateMaxBoundsRectOnScreen();
		}
		
		private function updateMaxBoundsRectOnScreen():void 
		{
			maxBoundsRectOnScreen.left = myWorld.visualization.wrlX2Screen(maxBoundsRectInWorld.left);
			maxBoundsRectOnScreen.right = myWorld.visualization.wrlX2Screen(maxBoundsRectInWorld.right);
			maxBoundsRectOnScreen.top = myWorld.visualization.wrlY2Screen(maxBoundsRectInWorld.top);
			maxBoundsRectOnScreen.bottom = myWorld.visualization.wrlY2Screen(maxBoundsRectInWorld.bottom);
		}
		override public function react2ParallaxAndScale(xFrac:Number, yFrac:Number, sFrac:Number):void 
		{
			super.react2ParallaxAndScale(xFrac, yFrac, sFrac);
			updateMaxBoundsRectOnScreen();
			//myWorld.visualization.screenRectInWorld - это какая часть мира сейчас показывается на экране
			maxBoundsRectOnScreen.intersectionToOutput(myWorld.visualization.screenRectOnScreen, tmpRct);
			showRectOfPoints(tmpRct.left, tmpRct.right, tmpRct.top, tmpRct.bottom, myWorld.visualization.scale);
		}
		override public function react2NewVisPos(vx:Number, vy:Number, vs:Number):void 
		{
			super.react2NewVisPos(vx, vy, vs);
			updateMaxBoundsRectOnScreen();
			maxBoundsRectOnScreen.intersectionToOutput(myWorld.visualization.screenRectOnScreen, tmpRct);
			showRectOfPoints(tmpRct.left, tmpRct.right, tmpRct.top, tmpRct.bottom, myWorld.visualization.scale);
		}
		
		protected function showRectOfPoints(x0:Number, x1:Number, y0:Number, y1:Number, scl:Number = 1):void{
			
		}
	}

}