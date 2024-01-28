package gameplay.visual.effects 
{
	import gameplay.visual.EffectsController;
	import service.ImageModifier;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class SimplePooledEffect extends Sprite
	{
		protected var timeExisting:Number;
		protected var imageModifiers:Vector.<service.ImageModifier>;
		protected var myController:EffectsController;
		public var myClass:Class;
		public var isInPool:Boolean;
		public function SimplePooledEffect(cont:EffectsController) 
		{
			this.myController = cont;
			this.isInPool = true;
			this.timeExisting = 0;
			this.imageModifiers = new Vector.<ImageModifier>()
			
			touchable = false;
			touchGroup = true;
			
		}
		public function doStep(dt:Number):void{
			this.timeExisting+=dt;
			
			for (var i:int=0; i<this.imageModifiers.length; i++){
				if (this.imageModifiers[i].isAnimating){
					this.imageModifiers[i].doAnimStep(dt);
				}
			}
			//when back2Pool
		}
		
		public function startEffect(cx:int, cy:int, propsOb:Object):void{
			//propsOb.txt, etc
			this.isInPool=false;
			this.timeExisting = 0;
			this.x = cx;
			this.y = cy;
			this.visible = true;
			//this.visObjects...
			//this.ima.startAnimation(1,0);
		}
		
		public function back2Pool():void{
			for (var i:int=0; i<this.imageModifiers.length; i++){
				this.imageModifiers[i].isAnimating = false;
			}
			
			this.isInPool = true;
			visible = false;
		}
		
		protected function createImageModifier(dob:DisplayObject, phi:Number, isRel:Boolean=false):ImageModifier{
			var ima:ImageModifier = new ImageModifier();
			ima.isRelative = isRel;
			ima.registerDob(dob, phi);
			this.imageModifiers.push(ima);
			return ima;       
		}		
	}

}