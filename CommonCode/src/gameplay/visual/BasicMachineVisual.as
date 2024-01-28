package gameplay.visual 
{
	import service.ImageModifier;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class BasicMachineVisual extends Sprite
	{
		protected var imageModifiers:Vector.<ImageModifier>;
		private var embeddedVisuals:Vector.<BasicMachineVisual>;
		public var isPhaseBased:Boolean = false;
		public function BasicMachineVisual(ax:int, ay:int, par:DisplayObjectContainer) 
		{
			this.x = ax;
			this.y = ay;
			
			this.imageModifiers = new Vector.< ImageModifier>();
			this.embeddedVisuals=new Vector.<BasicMachineVisual>();
			if (par){
				par.addChild(this);
			}
			touchGroup = true;
		}
		
		public function doAnimStep(dt):void{
			for (var i:int = 0; i < this.imageModifiers.length; i++) {
				var ima:ImageModifier = this.imageModifiers[i];
				if (ima.isAnimating) {
					ima.doAnimStep(dt);
				}
			} 
			for (i = 0; i < this.embeddedVisuals.length; i++) {
				var vis:BasicMachineVisual = this.embeddedVisuals[i];
				vis.doAnimStep(dt);
			}			
		}
		
		
		public function embedVisual(vis:BasicMachineVisual):void{
			this.embeddedVisuals.push(vis);
		}

		public function setAnimLength(id:int, ph:Number):void{
			if (id<this.imageModifiers.length){
				this.imageModifiers[id].setCycle(0, ph);
			}
		}

		public function setAnimLambda(id:int, lmb:Number):void{
			if (id<this.imageModifiers.length){
				this.imageModifiers[id].setLambdaDirectly(lmb);
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

		public function createImageModifier(dob:DisplayObject, phi:Number, isRel:Boolean=false):ImageModifier{
			var ima:ImageModifier = new ImageModifier();
			ima.isRelative = isRel;
			ima.registerDob(dob, phi);
			this.imageModifiers.push(ima);
			return ima;       
		}

		public function setCoords(cx:Number, cy:Number):void{
			this.x = cx;
			this.y = cy;
		}
		
		public function getAnimOfId(id:int):ImageModifier{
			if (id<this.imageModifiers.length){
				return this.imageModifiers[id];
			}else{
				return null;
			}
		}
		
		public function getVecOfImageModifiers():Vector.<ImageModifier> 
		{
			return imageModifiers;
		}
		
	}

}