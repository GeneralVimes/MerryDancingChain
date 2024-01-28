package gameplay.worlds.service.tut 
{
	import gameplay.basics.BasicGameObject;
	import gameplay.worlds.World;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TutDragHand extends TutorialSprite 
	{
		protected var handIm:Image;
		protected var handShadeIm:Image;
		protected var x0:Number = 0;
		protected var y0:Number = 0;
		
		protected var x1:Number = 0;
		protected var y1:Number = 0;
		
		private var movDir:Number = -0.75*Math.PI;
		public function TutDragHand(wrl:World, par:DisplayObjectContainer, ob:BasicGameObject, func:Function, fParams:Array, fCaller:*, paramOb:Object) 
		{
			super(wrl, par, ob, func, fParams, fCaller, paramOb);
			this.handShadeIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_TUTHAND"], this, 5, 5, null);
			this.handShadeIm.scale = 1.05;
			this.handShadeIm.alpha = 0.3
			this.handShadeIm.color = 0x333333;
			this.handIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_TUTHAND"], this, 0, 0, null);
			
			
			
			if (paramOb){
				if (paramOb.hasOwnProperty("x0")){
					x0 = paramOb.x0;
				}
				if (paramOb.hasOwnProperty("y0")){
					y0 = paramOb.y0;
				}
				if (paramOb.hasOwnProperty("x1")){
					x1 = paramOb.x1;
				}
				if (paramOb.hasOwnProperty("y1")){
					y1 = paramOb.y1;
				}
			}
		}
		
		override public function doAnimStep(dt:Number):void 
		{
			super.doAnimStep(dt);
			var appearPhase:Number = 0.5;
			var disappearPhase:Number = 0.5;
			var dragPeriod:Number = 5;
			var totalPeriod:Number = appearPhase+disappearPhase+dragPeriod;
			var rem:Number = this.lifeTime % totalPeriod;
			
			if (rem < appearPhase){
				this.lambda = rem / appearPhase;
				showAppearVisuals(lambda);

			}else{
				rem -= appearPhase;
				if (rem<dragPeriod){
					lambda = rem / dragPeriod;
					
					showDragVisuals(lambda);
				}else{
					rem -= dragPeriod;
					lambda = rem / disappearPhase;
					
					showHideVisuals(lambda)
				}
			}

			
			if (this.myObject){
				this.x += this.myObject.getX()
				this.y += this.myObject.getY()
			}
		}
		
		protected function showHideVisuals(lambda:Number):void 
		{
			this.x = x1;
			this.y = y1;
			
			this.handIm.scale = 1 + lambda;
			this.handShadeIm.scale = 1 + lambda;
			this.alpha = 1 - lambda;			
		}
		
		protected function showDragVisuals(lambda:Number):void 
		{
			this.x = x0 + lambda * (x1 - x0);
			this.y = y0 + lambda * (y1 - y0);
			this.alpha = 1;
			this.handIm.scale = 1 
			this.handShadeIm.scale = 1
		}
		
		protected function showAppearVisuals(lambda:Number):void 
		{
			this.x = x0;
			this.y = y0;
			
			this.alpha = lambda;
			this.handIm.scale = 1 
			this.handShadeIm.scale = 1		
		}
		override public function getRemoved():void 
		{
			super.getRemoved();
		}		
		
	}

}