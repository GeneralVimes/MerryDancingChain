package gui.service 
{
	
	import gui.text.MultilangTextField;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Console extends Sprite 
	{
		private var cap:MultilangTextField;
		private var bgd:Image;
		
		public function Console() 
		{
			bgd = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0, 0, "left", "top");
			bgd.alpha = 0.5;
			cap = new MultilangTextField('', 50, 50, 500, -1, 0.5, 0x000000, 'left', 'normal', false);
			addChild(cap);
			
			touchable = false; 
			touchGroup = true;
			
			alignOnScreen();
		}
		
		public function showText(txt:String):void{
			cap.showText(txt);
			
			bgd.height = cap.y + cap.getTextHeight();
		}
		
		public function alignOnScreen():void 
		{
			cap.setMaxTextWidth(Main.self.sizeManager.gameWidth - 100);
			bgd.width = Main.self.sizeManager.gameWidth
		}
	}

}