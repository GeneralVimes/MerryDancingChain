package gui 
{
	import gameplay.basics.UnMovedBGD;
	import service.ImageModifier;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class ThunderstormEffect extends Sprite 
	{
		private var sqrtIm:Image;
		private var ligtningIm:Image;
		private var bgdIma:service.ImageModifier;
		
		public function ThunderstormEffect() 
		{
			sqrtIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0,  0, "left","top");
			ligtningIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_THUNDERBOLT"], this, 0,  0, "center","top");
			
			this.sqrtIm.alpha = 0.0
			
			
			this.ligtningIm.alpha = 0.5
			this.ligtningIm.scale = 4;
			
			this.bgdIma = new ImageModifier();
			
			touchable = true;
			touchGroup = true;
		}
		
		public function alignOnScreen():void 
		{
			sqrtIm.width = Main.self.sizeManager.gameWidth;
			sqrtIm.height = Main.self.sizeManager.gameHeight;
			
			this.ligtningIm.x = Main.self.sizeManager.gameWidth/2;
			this.ligtningIm.y = 0;	
		}
		
		public function startAnimating():void 
		{
			visible = true;
			alignOnScreen();
		}
		
		public function doAnimStep(dt:Number, timeTillRestart:Number):void 
		{
			this.sqrtIm.alpha = 1 - timeTillRestart;
			
			if (Math.random()<0.25){
				this.sqrtIm.color=Math.random()<0.5?0x000000:0xffffff
			}
			// console.log('tint=',this.sqrtIm.tint);
			
			if (this.ligtningIm.visible){
				if (Math.random()<0.5){
					this.ligtningIm.visible = false;
				}
			}else{
				if (Math.random()<0.1){
					this.ligtningIm.x = Main.self.sizeManager.gameWidth * (0.5 - 0.3 + 0.6 * Math.random());
					this.ligtningIm.visible = true;
				}			
			}			
		}
		
	}

}