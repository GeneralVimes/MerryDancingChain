package gameplay.visual.anims 
{
	import gameplay.visual.PooledObject;
	import service.ImageModifier;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class SparklesLineAnim extends BasicParticlesAnimation 
	{
		
		public function SparklesLineAnim(par:DisplayObjectContainer, cx:int, cy:int) 
		{
			super(par, cx, cy);
			
		}
		
		override protected function initParticlesPool():void 
		{
			super.initParticlesPool();
			for (var i:int = 0; i < 5; i++){
				var im :PooledObject = new PooledObject();
				Routines.buildImageFromTexture(Assets.allTextures["TEX_STARWITHTRACK"], im, 0,  0, "right","center");
				addChild(im);
				particlesPool.push(im);
				im.isInPool = true;
				im.visible = false;

				var ima:ImageModifier = createImageModifier(im, 1);
				ima.addAnimNode(0.0, im.x, im.y, im.rotation, 0,1,0,0,0);
				ima.addAnimNode(0.2, im.x+67, im.y, im.rotation, 1,1,0,0,1);
				ima.addAnimNode(1.0, im.x+130, im.y, im.rotation, 1,1,0,0,0);
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
				im.x = Math.random()*20-10;
				im.y = Math.random()*20-10;
				var deltaPhi:Number = Math.random()*0.2-0.1;
				ima.modNodeProperty(0,'x', im.x);
				ima.modNodeProperty(0,'y', im.y);

				ima.modNodeProperty(1,'x', im.x+67);
				ima.modNodeProperty(1,'y', im.y-Math.sin(deltaPhi)*67);
				ima.modNodeProperty(1,'rotation', deltaPhi);

				ima.modNodeProperty(2,'x', im.x+130);
				ima.modNodeProperty(2,'y', im.y-Math.sin(deltaPhi)*130);
				ima.modNodeProperty(2,'rotation', deltaPhi);

				ima.setCycle(0, 0.1+0.1*Math.random());
				ima.startAnimation(1,0);
			}			
		}		
	}

}