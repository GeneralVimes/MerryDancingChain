package gameplay.visual.anims 
{
	import gameplay.visual.PooledObject;
	import service.ImageModifier;
	import starling.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author ...
	 */
	public class DustCloudsAnim extends BasicParticlesAnimation 
	{
		
		public function DustCloudsAnim(par:DisplayObjectContainer, cx:int, cy:int) 
		{
			super(par, cx, cy);
			
		}
		
		override protected function initParticlesPool():void 
		{
			super.initParticlesPool();
			for (var i:int=0; i<5; i++){
				var im :PooledObject = new PooledObject();
				Routines.buildImageFromTexture(Assets.allTextures["TEX_CLOUDPART"], im, 0,  0,"center","center");
				im.rotation = Math.random()*Math.PI;
				
				addChild(im);
				
				particlesPool.push(im);
				im.isInPool = true;
				im.visible=false;

				var ima:ImageModifier = createImageModifier(im, 1);
				ima.addAnimNode(0.0, im.x, im.y, im.rotation, 0,0,0,0,0);
				ima.addAnimNode(0.3, im.x, im.y, im.rotation+1, 1,1,0,0,1);
				ima.addAnimNode(1.0, im.x, im.y, im.rotation+2, 2,2,0,0,0);
				particleModifiers.push(ima);
			}
		}
		override protected function startSingleParticleAnimation(id:int):void 
		{
			super.startSingleParticleAnimation(id);
			if (Math.random()<0.1){
				var im:PooledObject = particlesPool[id];
				var ima:ImageModifier = particleModifiers[id];
				im.isInPool = false;
				im.visible = true;
				im.x = Math.random()*60-30;
				im.y = Math.random()*60-30;
				ima.modNodeProperty(0,'x', im.x);
				ima.modNodeProperty(0,'y', im.y);

				ima.modNodeProperty(2,'x', -im.x);
				ima.modNodeProperty(2,'y', -im.y);

				ima.setCycle(0, 0.2+0.3*Math.random());
				ima.startAnimation(1,0);
			}			
		}
	
	}

}