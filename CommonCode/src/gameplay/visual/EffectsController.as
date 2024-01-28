package gameplay.visual 
{
	import gameplay.visual.effects.SimplePooledEffect;
	import gameplay.worlds.World;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class EffectsController 
	{
		private var myWorld:World;
		private var expls:Vector.<SimplePooledEffect>
		public function EffectsController(w:World) 
		{
			myWorld = w;
			expls = new Vector.<gameplay.visual.effects.SimplePooledEffect>();
		}
		public function doStep(dt:Number):void{
			var len:int = this.expls.length;
			for (var i:int=0; i<len; i++){
				var expl:SimplePooledEffect = this.expls[i];
				if (!expl.isInPool){
					expl.doStep(dt)
				}
			}		
		}
		
		public function showEffect(cx:int, cy:int, cls:Class, propsOb:Object, onScreenNotWorld:Boolean=false):void{
			// console.log('showEffect', this.expls.length);
			var exp:SimplePooledEffect = null;
			for (var i:int=0; i<this.expls.length; i++){
				if (this.expls[i].isInPool){
					if (this.expls[i].myClass==cls){
						exp = this.expls[i];
						break;					
					}

				}
			}
			if (!exp){
				exp = new cls(this);
				exp.myClass = cls;
				this.expls.push(exp);
			}
			if (onScreenNotWorld){
				var parSpr:DisplayObjectContainer = this.myWorld.hud.parSpr;
				var mustAlwaysAdd:Boolean = true;
				cx = this.myWorld.visualization.wrlX2Screen(cx);
				cy = this.myWorld.visualization.wrlY2Screen(cy);
			}else{
				parSpr = this.myWorld.visualization.getLayerOfId(myWorld.visualization.layersAr.length - 1)
				mustAlwaysAdd = true;
			}
			
			if ((exp.parent!=parSpr)||mustAlwaysAdd){
				parSpr.addChild(exp);
			}
			exp.startEffect(cx, cy, propsOb);
		}		
		
		public function clear():void 
		{
			for (var i:int = 0; i < this.expls.length; i++){
				if (!expls[i].isInPool){
					expls[i].back2Pool();
				}
			}
		}
	}

}