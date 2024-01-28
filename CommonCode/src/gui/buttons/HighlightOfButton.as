package gui.buttons 
{
	import service.ImageModifier;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class HighlightOfButton extends Sprite
	{
		private var rays:Vector.<Image>;
		private var ima:ImageModifier;
		public function HighlightOfButton() 
		{
			rays = new Vector.<starling.display.Image>();
			for (var i:int = 0; i < 7; i++ ){
				var img:Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_BTN_HIGHLIGHTRAY"], this, 0, 0, null);
				var phi:Number = 2*Math.PI / 14 * (2 * i + 1);
				img.rotation = phi;
				rays.push(img);
			}
			ima = new ImageModifier();
			ima.registerDob(this, 5);
			ima.addAnimNode(0.3, 0, 0, 0.5, 1.2, 0.8);
			ima.addAnimNode(0.7, 0, 0, -0.5, 0.8, 1.2);
			ima.startAnimation( -1, 0);
		}
		
		public function doAnimStep(dt:Number):void 
		{
			ima.doAnimStep(dt);
		}
		
	}

}