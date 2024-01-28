package 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author General
	 */
	public class AppPreloader extends Sprite
	{
		private var bgImg:Image;
		private var airImg:Image;
		private var gauge:Image;
		private var ukrImg:Image;
		
		//public var gameLogo:Image;
		//public var airapportLogo:Image;
		
		public function AppPreloader() 
		{

			[Embed(source="../start_img/redBGD_init.png")]//изображение вшивается в программу, в свф-файл
			var startupBG:Class;
			bgImg = new Image(Texture.fromBitmap(new startupBG(), false));//создаётся картинка
			bgImg.width = Main.self.sizeManager.gameWidth;
			bgImg.height = Main.self.sizeManager.gameHeight;
			this.addChild(bgImg);
			
			//Airapport
			[Embed(source="../start_img/logo_init.png")]
			var startupLogo:Class;
			airImg = new Image(Texture.fromBitmap(new startupLogo(), false));
			//trace('logo created');
			airImg.alignPivot();//чтобы точка привязки была в центре.
			airImg.x = Main.self.sizeManager.gameWidth / 2;
			airImg.y = Main.self.sizeManager.gameHeight * 0.5;
			//trace(img2.x, img2.y);
			//img2.scaleX = img2.scaleY = ConstLibrary.gameWidth / ConstLibrary.screenW;
			this.addChild(airImg);		
			
			//Ukraine
			[Embed(source="../start_img/logo_Ukraine.png")]
			var ukrLogo:Class;
			ukrImg = new Image(Texture.fromBitmap(new ukrLogo(), false));
			ukrImg.alignPivot();//чтобы точка привязки была в центре.
			ukrImg.x = Main.self.sizeManager.gameWidth / 2;
			ukrImg.y = Main.self.sizeManager.gameHeight * 0.85;
			this.addChild(ukrImg);		
			
			//gauge
			[Embed(source="../start_img/gauge_init.png")]
			var startupGauge:Class;			
			gauge = new Image(Texture.fromBitmap(new startupGauge(), false));
			gauge.x = Main.self.sizeManager.gameWidth * 0.05;
			gauge.y = Main.self.sizeManager.gameHeight * 0.95;
			gauge.alignPivot("left", "top");
			gauge.width = 0;
			this.addChild(gauge);
				
		}
		
		public function showPercentage(perc:Number):void{
			//trace(perc)
			gauge.width = perc*perc * 0.9 * Main.self.sizeManager.gameWidth;
			//trace(gauge.width)
		}
		
		public function react2Resize():void 
		{
			bgImg.width = Main.self.sizeManager.gameWidth;
			bgImg.height = Main.self.sizeManager.gameHeight;
			
			airImg.x = Main.self.sizeManager.gameWidth / 2;
			airImg.y = Main.self.sizeManager.gameHeight * 0.5;	
			
			ukrImg.x = Main.self.sizeManager.gameWidth / 2;
			ukrImg.y = Main.self.sizeManager.gameHeight * 0.85;			
			
			gauge.x = Main.self.sizeManager.gameWidth * 0.05;
			gauge.y = Main.self.sizeManager.gameHeight * 0.95;			
			
		}
	}

}