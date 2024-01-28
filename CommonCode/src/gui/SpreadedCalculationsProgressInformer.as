package gui 
{
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SpreadedCalculationsProgressInformer extends Sprite 
	{
		private var bgd:NinePartsBgd;
		private var gaugeIm:Image;
		private var percTxt:MultilangTextField;
		public function SpreadedCalculationsProgressInformer() 
		{
			super();
			bgd = new NinePartsBgd();
			bgd.setInnerDims(200, 50);
			bgd.alpha = 0.8;
			addChild(bgd);
			
			
			gaugeIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, -100, 0, "left", "center");
			gaugeIm.height = 20;
			
			percTxt = new MultilangTextField("0%", 0, 50, 200, 1, 1, 0xffffff, "center", "normal", false);
			addChild(percTxt);
		}
		
		public function showFraction(frac:Number):void 
		{
			frac = frac * frac;
			var str:String = (frac*100).toFixed(2) + "%";
			percTxt.showText(str);
			gaugeIm.width = 200 * frac;
		}
		
	}

}