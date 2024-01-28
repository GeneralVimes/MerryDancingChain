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
	public class TutPointingHand extends TutorialSprite 
	{
		private var handIm:Image;
		private var handShadeIm:Image;
		private var deltaX:Number = 0;
		private var deltaY:Number = 0;
		
		private var movDir:Number = -0.75*Math.PI;
		public function TutPointingHand(wrl:World, par:DisplayObjectContainer, ob:BasicGameObject, func:Function,fParams:Array,fCaller:*, paramOb:Object) 
		{
			super(wrl, par, ob, func, fParams, fCaller, paramOb);
			
			this.handShadeIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_TUTHAND"], this, 5, 5, null);
			this.handShadeIm.scale = 1.05;
			this.handShadeIm.alpha = 0.3
			this.handShadeIm.color = 0x333333;
			
			this.handIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_TUTHAND"], this, 0, 0, null);
			
			if (paramOb){
				if (paramOb.hasOwnProperty("deltaX")){
					deltaX = paramOb.deltaX;
				}
				if (paramOb.hasOwnProperty("deltaY")){
					deltaY = paramOb.deltaY;
				}
				if (paramOb.hasOwnProperty("movDir")){
					movDir = paramOb.movDir;
				}
			}
			
			if (this.myObject){
				this.x = this.myObject.getX()
				this.y = this.myObject.getY();				
			}else{
				this.x = deltaX
				this.y = deltaY;				
			}
			

			this.rotation = movDir;
		}
		
		override public function doAnimStep(dt:Number):void 
		{
			super.doAnimStep(dt);
			
			if (this.myObject){
				this.x = this.myObject.getX()+deltaX+50*(1.5+0.5*Math.cos(this.lifeTime*5))*Math.sin(movDir+Math.PI);
				this.y = this.myObject.getY()+deltaY-50*(1.5+0.5*Math.cos(this.lifeTime*5))*Math.cos(movDir+Math.PI);				
			}else{
				this.x = deltaX+50*(1.5+0.5*Math.cos(this.lifeTime*5))*Math.sin(movDir+Math.PI);
				this.y = deltaY-50*(1.5+0.5*Math.cos(this.lifeTime*5))*Math.cos(movDir+Math.PI);					
			}

		}
		override public function getRemoved():void 
		{
			super.getRemoved();
		}
	}

}