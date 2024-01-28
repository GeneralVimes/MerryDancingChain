package gameplay.visual.effects 
{
	import gameplay.visual.EffectsController;
	import gui.text.MultilangTextField;
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class EffectMoney extends SimplePooledEffect 
	{
		private var iconIm:Image;
		private var txt:gui.text.MultilangTextField;
		
		public function EffectMoney(cont:EffectsController) 
		{
			super(cont)
			txt = new MultilangTextField('', 30, 0, 200, 1, 1, 0xffffff, "left", "normal", false);
			addChild(txt);
			
			iconIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_EFTCOINSPACK"], this, 0,  0)
			
		}
		override public function doStep(dt:Number):void 
		{
			super.doStep(dt);
			this.y -= dt * 50;
			if (this.timeExisting>1.0){
				this.alpha = 1-2*(this.timeExisting-1)
			}			
			if (this.timeExisting>2.0){
				this.back2Pool();
			}			
		}
		override public function startEffect(cx:int, cy:int, propsOb:Object):void 
		{
			super.startEffect(cx, cy, propsOb);
			this.txt.showText(propsOb.txt);

			this.alpha = 1;
		}
	}

}