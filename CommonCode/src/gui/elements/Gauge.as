package gui.elements 
{
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author General
	 */
	public class Gauge extends Sprite
	{
		private var maxWidth:Number;
		private var im:Image;
		private var bgIm:Image;
		
		public function Gauge(cx:int, cy:int, mxw:Number=100, h0:int = 20) 
		{
			x = cx;
			y = cy;
			im = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0, 0, "left");
			im.height = h0;
			im.width = 0;
			
			maxWidth = mxw;
		}
		
		public function setColor(cl:uint):void{
			im.color = cl;
		}
		
		public function setBg(cl:uint):void{
			if (!bgIm){
				bgIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, -3, 0, "left");
				addChild(im);
			}
			bgIm.visible = true;
			bgIm.color = cl;
			bgIm.x = -3;
			bgIm.width = maxWidth + 6;
			bgIm.height = im.height + 4;
		}
		
		public function showPercentage(perc:Number ):void{
			if (perc<0){
				perc = 0;
			}
			if (perc>1){
				perc = 1;
			}
			im.width = perc * maxWidth;
		}
	}

}