package gameplay.worlds.service.tut 
{
	import gameplay.basics.BasicGameObject;
	import gameplay.civ.visuals.AttackArrow;
	import gameplay.worlds.World;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TutDragArrow extends TutDragHand 
	{
		private var arr:AttackArrow;
		public function TutDragArrow(wrl:World, par:DisplayObjectContainer, ob:BasicGameObject, func:Function, fParams:Array, fCaller:*, paramOb:Object) 
		{
			super(wrl, par, ob, func, fParams, fCaller, paramOb);
			arr = new AttackArrow();
			arr.setRootPoint(0, 0)
			if (paramOb.hasOwnProperty("color")){
				arr.setColor(paramOb["color"])
			}
			
			this.addChild(arr);
			this.addChild(handShadeIm);
			this.addChild(handIm);
		}
		override protected function showAppearVisuals(lambda:Number):void 
		{
			super.showAppearVisuals(lambda);
			arr.pointFromTo(0, 0, 0,0)
		}
		
		override protected function showDragVisuals(lambda:Number):void 
		{
			super.showDragVisuals(lambda);
			arr.pointFromTo(x0-this.x, y0-this.y, 0,0)
		}
		
		override protected function showHideVisuals(lambda:Number):void 
		{
			super.showHideVisuals(lambda);
		}
	}

}