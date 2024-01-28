package gui.text 
{
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author General
	 */
	public class LetterMC extends MovieClip
	{
		public var isEuro:Boolean;
		public function LetterMC(textures:Vector.<Texture>,fps:Number=12) 
		{
			super(textures, fps);
		}
		
		public function setCurrentFrame(lid:int):void 
		{
			if ((lid < this.numFrames)&&(lid>0)){
				currentFrame = lid;
			}else{
				currentFrame = 0//
			}
		}
		
	}

}