package managers 
{
	import flash.display.Stage;
	import flash.display.Screen;	
	import flash.display.StageDisplayState;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author General
	 */
	public class StageSizeManager 
	{
		//проще всего - задаём в размерах квадрат. Это будет гарантированный размер наименьше стороны
		public var W0:int = 960;//под какой размер проектируется игра	
		public var H0:int = 960;//размер высоты на экране - гарантиоьван
								//а реальная ширина - какая получится
								//или наоборот - гарантирована ширина, а высота подстраивается (тако вариант лушче на мобильных)
		//учитываем, что для ПК эти величины поменяются  наоборот
								
		public var sideField:Number = 0;//на сколько внутреннюю часть отступаем слева
		public var topField:Number = 0;//на сколько внутреннюю часть отступаем сверху (вроде бы, этого не нужно)
		
		public var fitterWidth:Number = 0;//у вертикальных частей внутри альбомного экрана
		public var screenW:int = 720;//реальный размер экрана устройства
		public var screenH:int = 720//960;		
		
		public var deviceDiag:Number = 5;//диагональ в дюймах, будем вычислять исходя из dpi
		
		public var oldGameWidth:int = 0;//а это - сколько будет в наши пикселях
		public var oldGameHeight:int = 0;		
		public var gameWidth:int = 0;//а это - сколько будет в наши пикселях
		public var gameHeight:int = 0;
		
		public var ratio:Number = 1.3333;//соотношение между высотой и шириной, поменяется при инициализации
		public var screenPixelsInGameRatio:Number = 1;//сколько экранных пикселей в игровом
		
		public var isMonobrow:Boolean = false;
		public var topMenuDelta:Number = 0;
		public var bottomLineDelta:Number = 0;//надо ли? У айфонов тут полосочка внизу экрана. Она что-то закрывает?
		public var cornersRadius:Number = 0;//вот это радиус закругления экрана, который надо учитывать у айфонов
		
		public var isPortrait:Boolean = true;
		
		public function StageSizeManager() 
		{
			
		}

		public function setupScales(stg:Stage):void 
		{
			oldGameWidth = gameWidth;
			oldGameHeight = gameHeight;
			
			//trace('setupScales');
			//trace('stg.fullScreenWidth:',stg.fullScreenWidth);
			//trace('stg.fullScreenHeight:',stg.fullScreenHeight);
			
			//if (Main.self.config.platformGroup != 'Mobile'){
			//	if (W0<H0){
			//		var t:int = W0;
			//		W0 = H0;
			//		H0 = t;					
			//	}
			//}
			
			if (Main.self.config.platformGroup!='Mobile'){
				screenW = stg.stageWidth;
				screenH = stg.stageHeight;	
				
				if (Main.self.config.platformGroup == 'PC'){
					if ((stg.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)||(stg.displayState == StageDisplayState.FULL_SCREEN)){
						screenW = stg.fullScreenWidth;
						screenH = stg.fullScreenHeight;							
					}else{
						screenW = stg.stageWidth;
						screenH = stg.stageHeight;							
					}
					
				}
			}else{
				if ((Screen.mainScreen.visibleBounds.y > 0)||(Screen.mainScreen.visibleBounds.x > 0)){
					screenW = Screen.mainScreen.visibleBounds.width// stg.fullScreenWidth;
					screenH = Screen.mainScreen.visibleBounds.height// stg.fullScreenHeight;					
				}else{
					screenW = stg.fullScreenWidth;
					screenH = stg.fullScreenHeight;					
				}		
			}
			
			ratio = screenH / screenW;
			
			//физический размер
			if (Capabilities.screenDPI > 0){
				var inchW:Number = screenW / Capabilities.screenDPI;
				var inchH:Number = screenH / Capabilities.screenDPI;
				deviceDiag = Math.sqrt(inchW * inchW + inchH * inchH);
				trace("diag=",deviceDiag)
			}			
			
			//теперь, зная диагональ экрана можно и вносить изменения в W0, H0, чтоб, например, на компе было всё мельче (тогда их надо ставить больше)
			
			//у нас W0==H0 и fitterWidth подбирается под квадрат
			if (ratio >= 1){//экран вертикальный
				isPortrait = true;
				gameWidth = W0;//гарантируем ширину экрана
				gameHeight = gameWidth * ratio;	
				fitterWidth = gameWidth;
			}else{//экран горизонтальный
				isPortrait = false;
				gameHeight = H0;//гарантируем высоту экрана
				gameWidth = gameHeight / ratio;
				fitterWidth = W0;// gameHeight / 4 * 3;
			}
			
			if (fitterWidth > gameWidth){
				fitterWidth = gameWidth;
			}
			
			sideField = (gameWidth - fitterWidth) / 2;	
			
			screenPixelsInGameRatio = screenH / gameHeight;//узнаём, сколько пикселей на один пиксель нашего размера
			
			isMonobrow = false;
			topMenuDelta = 0;
			cornersRadius = 0;
			bottomLineDelta = 0;
			
			if (Main.self.config.platform == 'Apple'){
				if (screenH / screenW  > 2.16){
					isMonobrow = true;
					topMenuDelta = 0.046 * gameHeight;
					
					cornersRadius = 0.0311 * gameHeight;
					bottomLineDelta = 0.0138 * gameHeight;
				}
			}
		}		
	}
}