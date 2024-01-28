package gui.elements 
{
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class NinePartsBgd extends Sprite
	{
		private var imTopLeft:Image
		private var imTop:Image
		private var imTopRight:Image
		private var imLeft:Image
		private var imMid:Image
		private var imRight:Image
		private var imBotLeft:Image
		private var imBot:Image
		private var imBotRight:Image
		
		private var img:Image
		
		public var horzField:Number = 0;
		public var vertField:Number = 0;
		public function NinePartsBgd() 
		{

			img = Routines.buildImageFromTexture(Assets.allTextures["TEX_NINEPARTALL"], this, 0, 0, "center", "center");
			img.scale9Grid = new Rectangle(45,45,66,80)
			horzField = 45
			vertField = 45
		}
		
		public function setDims(aw:Number, ah:Number):void{
			setInnerDims(aw - 2 * horzField, ah - 2 * vertField+1*vertField);
			//setInnerDims(aw , ah);
		}		
		
		public function setInnerDims(aw:Number, ah:Number):void{
		//	Main.self.sizeManager.screenPixelsInGameRatio
			//зачем мы это делаем: нам важно, чтобы кординаты обектов оказались целыми именно на экране. А coef - это как раз к-т перевода игровых в реальные экранные координаты
			var coef:Number = Main.self.sizeManager.screenPixelsInGameRatio
			aw = 2*Math.round(0.5*aw*coef)/coef
			ah = 2*Math.round(0.5*ah*coef)/coef
			
			img.width = aw+90;
			img.height = ah+90;
			img.y = ah/2
		}
		
	}

}