package gameplay.visual.anims 
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import gameplay.visual.BasicMachineVisual;
	import gameplay.visual.PooledObject;
	import service.ImageModifier;
	/**
	 * ...
	 * @author ...
	 */
	public class BasicParticlesAnimation extends BasicMachineVisual
	{
		public var isAnimating:Boolean;
		private var animationTimeLeft:Number;
		private var mustImmediatelyStopAnimationAfterTimeOver:Boolean;
		protected var particlesPool:Vector.<PooledObject>;
		protected var particleModifiers:Vector.<ImageModifier>;
		
		public function BasicParticlesAnimation(par:DisplayObjectContainer, cx:int, cy:int) 
		{
			super(cx, cy, par);
			
			isAnimating = false;
			animationTimeLeft = 0;
			
			mustImmediatelyStopAnimationAfterTimeOver = false;
			
			particlesPool = new Vector.<PooledObject>();
			particleModifiers = new Vector.<ImageModifier>();
			initParticlesPool();
		}
		
		protected function initParticlesPool():void 
		{
			
		}
		
		
		public function doAnimations(dt:Number) :void{
			
			super.doAnimStep(dt);
			if (this.isAnimating){
				this.doParticleAnimations(dt);
				
				this.animationTimeLeft-=dt;
				if (this.animationTimeLeft<=0){
					this.isAnimating=false;
					
					if (this.mustImmediatelyStopAnimationAfterTimeOver){
						this.immediatelyStopAnimations();
					}
				}
			}
		}		
		
		protected function immediatelyStartAnimation():void 
		{
			
		}
		protected function immediatelyStopAnimations():void 
		{
			
		}
		
		override public function doAnimStep(dt):void 
		{
			super.doAnimStep(dt);
			doAnimations(dt);
		}
		
		protected function doParticleAnimations(dt:Number):void 
		{
			for (var i:int=0; i<this.particlesPool.length; i++){
				var im:PooledObject = this.particlesPool[i];
				if (im.isInPool){
					this.startSingleParticleAnimation(i);
				}else{
					var ima:ImageModifier = this.particleModifiers[i];
					if (!ima.isAnimating){
						im.back2Pool();
					}
				}
			}			
		}
		
		protected function startSingleParticleAnimation(id:int):void 
		{
			
		}
		
		public function stopAnimations():void{
			this.animationTimeLeft=0;
			this.isAnimating=false;
		}
		
		public function startAnimations(x0:int, y0:int, tmLen:Number, mustStop:Boolean):void{
			this.x = x0;
			this.y = y0;
			this.animationTimeLeft = tmLen;
			this.mustImmediatelyStopAnimationAfterTimeOver = mustStop;
			this.isAnimating = true;
			this.immediatelyStartAnimation();
		}		

		
		
	}

}