package gameplay.descendants 
{
	import starling.display.DisplayObject;
	import gameplay.basics.BasicGameObject;
	import gameplay.visual.BasicMachineVisual;
	import gameplay.worlds.ChainWorld;
	import gameplay.worlds.World;
	import service.ImageModifier;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChainObject extends BasicGameObject 
	{
		protected var myChainWorld:ChainWorld;		
		
		public var sortedId:int=0;
		
		private var specialVal4ImageModifiersAnimation:Number=0;
		
		protected var imageModifiers:Vector.<ImageModifier>;
		protected var embeddedViss:Vector.<BasicMachineVisual>;
		public function ChainObject() 
		{
			super();
			
		}
		override public function registerMyWorld(world:gameplay.worlds.World):void 
		{
			super.registerMyWorld(world);
			myChainWorld = myWorld as ChainWorld;
		}

		override public function initVisuals():void 
		{
			super.initVisuals();
			imageModifiers = new Vector.<ImageModifier>();
			embeddedViss = new Vector.<BasicMachineVisual>();
		}
		
		override public function changePos(newX:Number, newY:Number):void 
		{
			//trace("changePos",this.y, newY)
			var dy:Number = newY - this.y;
			super.changePos(newX, newY);
			if (dy!=0){
				this.myChainWorld.adjustDepth(this, dy)
			}
			//trace("now",this.y, newY)
		}
		
		
		
		override public function actualizeVisuals():void 
		{
			super.actualizeVisuals();
			for (var i:int = 0; i < this.imageModifiers.length; i++ ){
				var ac:ImageModifier = this.imageModifiers[i];
				if (ac.isPhiBased){
					ac.doAnimStep(Math.abs(this.specialVal4ImageModifiersAnimation));
				}else{
					ac.doAnimStep(this.timePassedSinceLastCheck);
				}
				//
			}	
			
			for (i = 0; i < embeddedViss.length; i++ ){
				var vis:BasicMachineVisual = embeddedViss[i];
				if (vis.isPhaseBased){
					embeddedViss[i].doAnimStep(this.specialVal4ImageModifiersAnimation);
				}else{
					embeddedViss[i].doAnimStep(this.timePassedSinceLastCheck);
				}
				
			}
		}
		
		public function setAnimLength(id:int, ph:Number):void{
			if (id<this.imageModifiers.length){
				this.imageModifiers[id].setCycle(0, ph);
			}
		}
		public function setAnimLambda(id:int, lbd:Number):void{
			if (id<this.imageModifiers.length){
				this.imageModifiers[id].setLambdaDirectly(lbd);
			}
		}		
		public function interpolateAnimLambda(id:int, lmb:Number, coef:Number):void{
			if (id<this.imageModifiers.length){
				this.imageModifiers[id].interpolate2Lambda(lmb, coef);
			}
		}		
		public function runAnimId(id:int, num:int, ph0:Number):void{
			if (id<this.imageModifiers.length){
				this.imageModifiers[id].startAnimation(num, ph0);
			}
		}
		
		public function stopAnimId(id:int):void{
			if (id<this.imageModifiers.length){
				this.imageModifiers[id].isAnimating = false;
			}
		}
		
		public function finalizeAnimId(id:int):void{
			if (id<this.imageModifiers.length){
				this.imageModifiers[id].stopAfterThisRun();
			}
		}

		
		protected function removeVisual(vis:BasicMachineVisual, isPh:Boolean = false):void{
			var id:int = embeddedViss.indexOf(vis);
			if (id!=-1){
				embeddedViss.splice(id,1);
			}
		}
		protected function embedVisual(vis:BasicMachineVisual, isPh:Boolean = false):void{
			vis.isPhaseBased = isPh;
			embeddedViss.push(vis);
		}
		protected function embedExternalIma(ima:ImageModifier, isPh:Boolean=false):void{
			imageModifiers.push(ima);
			ima.isPhiBased = isPh;
		}
		
		protected function createImageModifier(dob:DisplayObject, phTot:Number, isPh:Boolean=false, isRel:Boolean=false):ImageModifier 
		{
			var ima:ImageModifier = new ImageModifier();
			ima.isRelative = isRel;
			ima.registerDob(dob, phTot);
			ima.isPhiBased = isPh;
			imageModifiers.push(ima);
			return ima;
		}			
	}

}