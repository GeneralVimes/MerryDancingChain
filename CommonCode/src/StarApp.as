package 
{
	import com.junkbyte.console.Cc;
	import globals.*;
	import AppPreloader;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author General
	 */
	public class StarApp extends Sprite //обрати внимание - starling.display.Sprite, не flash.display.Sprite;
	{
		//синглтон - ссылка на единственный экземпляр класса StarApp. Потом можно обратиться StarApp.app
		public static var app:StarApp;
		
		//индикация загрузки
		public var preloader:AppPreloader;
		public var nxtWorldId2Switch:int = -1;
		public var nxtSkin2Switch:Object = null;
		
		private var newGameScreen:NewGameScreen;		

		public function StarApp() 
		{
			app = this;//чтобы другие объекты могли достучаться до нашего через StarApp.app
			trace('starApp created');
			
			makePreloader();
			Cc.log('app');		

			
			Assets.init(-1)//lastSavedWorldId);//подгружаем общую графику, не относящуюся к конкретному миру
			
		}
		
		private function makePreloader():void 
		{
			preloader = new AppPreloader();
			addChild(preloader);
			
		}
		
		public function showLoadProgress(ratio:Number):void{
			preloader.showPercentage(ratio);
		}	
		
		public function react2FullLoad():void{
			Cc.log('react2FullLoad');
			continueLoading();
		}
		
		public function onAssetsLoadProgress(ratio:Number):void {
			preloader.showPercentage(ratio);
		}		
		public function onAssetsLoadError(error:String):void {
			
		}
		public function onAssetsLoadComplete():void {
			continueLoading();
		}
		
		public function onAdditionalAssetsLoadProgress(ratio:Number):void {
			preloader.showPercentage(ratio);
			//Cc.log('onAdditionalAssetsLoadProgress',ratio)
		}		
		public function onAdditionalAssetsLoadError(error:String):void {
			trace('onAdditionalAssetsLoadError', error)
			//Cc.log('onAdditionalAssetsLoadError',error)
		}		
		public function onAdditionalAssetsLoadComplete():void {
			//Cc.log('onAdditionalAssetsLoadComplete')
			continueAfterTextureSwapping();
		}

		private function continueLoading():void 
		{
			Main.self.setupScales();//снова актуализируем константы размеров экрана, на всякий случай
			//по-моему, теперь, после секундной задержки, она не нужна
			Cc.log('continueLoading');
			//return;
			Assets.setVariables();
			
			
			//GlobalControllers
			var acc:PlayersAccount = new PlayersAccount();//тут класс работы с настройками пользователя
			Assets.modsManager.setPreviousSelectedMod(acc.getParamOfName("lastPlayedMod","none"));
			var sts:StatsWrapper = new StatsWrapper();//отправка статистики гуглу
			sts.init();				
			var pl:SoundPlayer = new SoundPlayer();
			pl.init();
			var mcp:MenuCommandsPerformer = new MenuCommandsPerformer();
			
			var tr:globals.Translator = new globals.Translator();//вот тут надо убрать пул с 
			var mp:MyPool = new MyPool();
			
			//ConstLibrary.setupLang(PlayersAccount.account.getLangId());
			//Cc.log('Assets.init')			
			
			newGameScreen = new NewGameScreen();
			
			addChild(newGameScreen);
			
			newGameScreen.checkGDPRAndStartSession();
			
			Cc.log('after startSession');
			
			removeChild(preloader);
			Cc.log('OKOKOK');
		}
		
		public function continueAfterTextureSwapping():void{
			Cc.log('continueAfterTextureSwapping')
			
			Assets.setVariables();
			
			
			//вот тут надопересоздавать все пулы. Или сделать как раньше: просто удалить и создать NewGameScreen
			
			
			//newGameScreen = new screens.NewGameScreen();
			//addChild(newGameScreen);
			//пулы пересоздём
			var mp:MyPool = new MyPool();
			Translator.translator.unregisterAllTexts();			
			newGameScreen.rebuildPools();
			newGameScreen.createListeners();

			newGameScreen.startPreloadedWorld();
			
			removeChild(preloader);
			//preloader = null;			
		}
		
		public function switchMergedArt4World(wid:int, skinOb:Object):void 
		{
			StarApp.app.nxtWorldId2Switch = wid;
			StarApp.app.nxtSkin2Switch = skinOb;
			
			preloader.showPercentage(0);
			addChild(preloader);
			
			newGameScreen.removeListeners();
			newGameScreen.removeChildren();
			newGameScreen.clearCurrentWorld();
			//removeChild(newGameScreen, true);
			Assets.switchMergedArt4World(wid, skinOb);			
		}		
		
		public function react2Resize():void 
		{
			preloader.react2Resize()
			if (newGameScreen){
				newGameScreen.react2Resize();
			}
		}
		
		public function handleKeyDown(e:flash.events.KeyboardEvent):Boolean 
		{
			if (newGameScreen){
				return newGameScreen.handleKeyDown(e);
			}else{
				return false;
			}
		}
		
		public function handleMouseWheel(e:flash.events.MouseEvent):Boolean 
		{
			if (newGameScreen){
				return newGameScreen.handleMouseWheel(e);
			}else{
				return false;
			}			
		}
		
	}

}