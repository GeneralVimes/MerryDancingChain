package gui.elements 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LineOfSegments extends Sprite 
	{
		private var imgs:Vector.<Image>;
		private var defaultSymbolLength:Number = 100;
		private var segmentTexture:Texture;
		private var segmentHorzAlign:String=null;
		private var segmentVertAlign:String=null;
		private var mustScaleSegment:Boolean=true;
		public function LineOfSegments(defLen:Number, tx:Texture, hzAl:String = "left", vrAl:String = "bottom", mustScl:Boolean = true) 
		{
			super();
			imgs = new Vector.<starling.display.Image>();
			defaultSymbolLength = defLen;
			segmentTexture = tx;
			segmentHorzAlign = hzAl;
			segmentVertAlign = vrAl;
			mustScaleSegment = mustScl;
		}
		
		public function showLineOfLength(len:Number):void{
			var numSymbols:int = Math.ceil(len / defaultSymbolLength);
			var step:Number = len / numSymbols;
			var maxI:int = Math.max(imgs.length, numSymbols);
			//trace('showLineOfLength',"len=",len,"numSymbols=",numSymbols,"step=",step,"maxI=",maxI)
			for (var i:int = 0; i < maxI; i++ ){
				if (i < numSymbols){
					if (i < imgs.length){
						var im:Image = imgs[i];
					}else{
						im = Routines.buildImageFromTexture(segmentTexture, this, 0, 0, segmentHorzAlign, segmentVertAlign);
						imgs.push(im);
					}
					im.visible = true;
					if (mustScaleSegment){
						im.x = step * i;
						im.width = Math.ceil(step+1);//делаем небольшой нахлёст
					}else{
						im.x = step * (i + 0.5);
					}
				}else{
					imgs[i].visible = false;
				}
				
			}
		}
		
	}

}