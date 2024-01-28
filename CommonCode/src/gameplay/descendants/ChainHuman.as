package gameplay.descendants 
{
	import service.ImageModifier;
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class ChainHuman extends MovingChainObject 
	{
		
		public function ChainHuman() 
		{
			super();
			
		}
		override public function initVisuals():void 
		{
			super.initVisuals();
			var frmId:int = Routines.randomIntNumberFromToIncl(0, Assets.allTextures["TXS_WORKERSIMPLE"].length - 1);
			var im:Image = Routines.buildImageFromTexture(Assets.allTextures["TXS_WORKERSIMPLE"][frmId], this, 0, 0, null);
			//im.scale = 0.5
			//im.color = 0xffff00
			
			var shadowIm:Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_HUMANSHADOW"], null, this.x, this.y, null);
			this.distributedSprites.push(shadowIm);
			
			
			var shadowScl0:Number = 1
			if ([5,27,35,36,39,44].indexOf(frmId)!=-1){
				shadowScl0=1.5
			}
			if ([6,11,16,19,20,25,40,42].indexOf(frmId)!=-1){
				shadowScl0=1.25
			}
			shadowIm.scale = shadowScl0;
			
			var cf1:Number=0.3
			var cf2:Number=0.6
			
			var tm:Number = 0.35+0.1*Math.random()
			var ima:ImageModifier = createImageModifier(im, tm);
			ima.addAnimNode(cf1, im.x,im.y-15);
			ima.addAnimNode(cf2, im.x, im.y);	
			
			ima = createImageModifier(shadowIm, tm);
			ima.addAnimNode(cf1, shadowIm.x, shadowIm.y,0,0.9*shadowScl0,0.9*shadowScl0);
			ima.addAnimNode(cf2, shadowIm.x, shadowIm.y,0,shadowScl0,shadowScl0);
			//ima.startAnimation(-1,0);
		}		
		override protected function startWalkingAnimations():void 
		{
			super.startWalkingAnimations();
			if (!imageModifiers[0].isAnimating){
				imageModifiers[0].startAnimation(-1,0)
				imageModifiers[1].startAnimation(-1,0)
			}else{
				imageModifiers[0].setNewNumCycles(-1)
				imageModifiers[1].setNewNumCycles(-1)
			}
		}
		override protected function stopWalkinAnimations():void 
		{
			super.stopWalkinAnimations();
			if (imageModifiers[0].isAnimating){
				imageModifiers[0].stopAfterThisRun();
				imageModifiers[1].stopAfterThisRun();
			}
		}
	}

}