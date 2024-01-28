package
{
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import starling.display.MeshBatch;
	import starling.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import globals.SoundPlayer;
	import globals.StatsWrapper;
	import managers.DebugTimesController;
	import managers.MultiplatformManager;
	import managers.StageSizeManager;

	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;

	import starling.core.Starling;
	import flash.display3D.Context3DRenderMode;
	
	import com.junkbyte.console.Cc;
	
	/**
	 * ...
	 * @author Alexey Izvalov
	 */
	public class Main extends Sprite 
	{	
		public static var _starling:Starling;		
		public static var self:Main;
		
		public var config:MainConfig;
		public var sizeManager:managers.StageSizeManager;
		public var multiplatformManager:managers.MultiplatformManager;
		
		public var debugTimesController:DebugTimesController = new managers.DebugTimesController();
		public function Main()
		{			
			self = this;
			config = new MainConfig();
			sizeManager = new managers.StageSizeManager();
			multiplatformManager = new managers.MultiplatformManager();

			if (config.isConsoleShowing){
				showConsole();
			}
			
			Cc.log(Capabilities.os);
			Cc.log('starting...');			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.addEventListener(flash.events.Event.DEACTIVATE, deactivate);
			stage.addEventListener(flash.events.Event.RESIZE, onStageResized);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Starling.multitouchEnabled = true;
			// entry point
			
			if (config.platformGroup=='PC'){
				stage.scaleMode = StageScaleMode.SHOW_ALL;
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;				
			}
			
			var starlingTimer:Timer = new Timer(1000, 1);
			starlingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, initSizesAfterDelay);
			starlingTimer.start();
			
			startListening2UncaughtErrors();
		}

		private function startListening2UncaughtErrors():void 
		{
			try{
				var uncaughtErrorEvents:IEventDispatcher = this.loaderInfo["uncaughtErrorEvents"];
				if(uncaughtErrorEvents){
					uncaughtErrorEvents.addEventListener("uncaughtError", uncaughtErrorHandle, false, 0, true);
				}
			}catch(err:Error){
				// seems uncaughtErrorEvents is not avaviable on this player/target, which is fine.
			}			
		}
		
		private function uncaughtErrorHandle(e:flash.events.Event):void 
		{
			if (StatsWrapper.stats){
				//Code from CC to submit via stats
				var error:* = e.hasOwnProperty("error")?e["error"]:e; // for flash 9 compatibility
				var str:String;
				if (error is Error){
					str = error.hasOwnProperty("getStackTrace")?error.getStackTrace():error.toString();		
				}else if (error is ErrorEvent){
					str = ErrorEvent(error).text;
				}
				if(!str){
					str = String(error);
				}
				
				StatsWrapper.stats.logTextWithParams('ERROR_UNCAUGHT', str, 3);
			}
			
		}
		
		private function initSizesAfterDelay(e:TimerEvent):void 
		{
			//Моя функция подгонки под разные размеры экрана
			setupScales();
			
			//задаём порт вывода для Старлинга - он будет показываться на весь экран реального устройства
			var port:Rectangle = new Rectangle(0, 0, sizeManager.screenW, sizeManager.screenH);
			
			//Pixel 6 workaround
			if (Capabilities.os.indexOf("Pixel 6")!=-1){
				MeshBatch.MAX_NUM_VERTICES = 400;
			}
			
			
			// entry point
			//StarApp - класс самого приложения
			_starling = new Starling(StarApp, this.stage, port, null, Context3DRenderMode.AUTO);
			Cc.log(buidCapabilitiesString());

			
			_starling.addEventListener(starling.events.Event.FATAL_ERROR, onStarlingFatalError)
			_starling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onStarlingContextCreated)
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onStarlingRootCreated)
			Starling.painter.stage3D.addEventListener(ErrorEvent.ERROR, onStage3DError);
			
			_starling.showStats = false;//*/true;//показывать ли ФПС
			_starling.simulateMultitouch = (config.platformGroup=='PC')?false:true;
			//adaptive screen:
			
			_starling.stage.stageWidth = sizeManager.gameWidth;
			_starling.stage.stageHeight = sizeManager.gameHeight;			
			
			
			
			_starling.start();
			Cc.log("_starling.context=",  _starling.context); 
			if (_starling.context){
				Cc.log("driveInfo:",_starling.context.driverInfo);			
			}
			
			// new to AIR? please read *carefully* the readme.txt files!		
		}
		
		public function setupScales():void 
		{
			sizeManager.setupScales(stage);	
		}

		
		private function onStage3DError(e:ErrorEvent):void 
		{
			var str:String = this.buidCapabilitiesString(); 
			var error:* = e.hasOwnProperty("error")?e["error"]:e; // for flash 9 compatibility
			if (error is Error){
				str += error.hasOwnProperty("getStackTrace")?error.getStackTrace():error.toString();		
			}else if (error is ErrorEvent){
				str += ErrorEvent(error).text;
			}
			if(!str){
				str += String(error);
			}			
			StatsWrapper.stats.logTextWithParams('ERROR_STARLING_STAGE3D_ERROR', str, 3);
		}		
		
		private function onStarlingFatalError(e:starling.events.Event):void 
		{
			//Code from CC to submit via stats
			var str:String = this.buidCapabilitiesString(); 
						
			
			var error:* = e.hasOwnProperty("error")?e["error"]:e; // for flash 9 compatibility
			if (error is Error){
				str += error.hasOwnProperty("getStackTrace")?error.getStackTrace():error.toString();		
			}else if (error is ErrorEvent){
				str += ErrorEvent(error).text;
			}
			if(!str){
				str += String(error);
			}
			
			StatsWrapper.stats.logTextWithParams('ERROR_STARLING_FATAL_ERROR', str, 3);
			Cc.log('Starling Fatal Error')
			Cc.log(e.toString())
			Cc.log(e.type);
		}
		
		public function buidCapabilitiesString():String 
		{
			var str:String = "";
			str += " OS: " + Capabilities.os;
			str += " cpuAddressSize: " + Capabilities.cpuAddressSize;
			str += " cpuArchitecture: " + Capabilities.cpuArchitecture;
			str += " manufacturer: " + Capabilities.manufacturer;
			str += " pixelAspectRatio: " + Capabilities.pixelAspectRatio.toString();
			str += " playerType: " + Capabilities.playerType;
			str += " screenDPI: " + Capabilities.screenDPI;
			str += " screenResX: " + Capabilities.screenResolutionX;
			str += " screenResY: " + Capabilities.screenResolutionY;
			str += " screenColor: " + Capabilities.screenColor;
			str += " supports32BitProcesses: " + Capabilities.supports32BitProcesses;
			str += " supports64BitProcesses: " + Capabilities.supports64BitProcesses;
			str += " version: " + Capabilities.version;		
			
			str += "\nDiag: " + sizeManager.deviceDiag;
			str += " width: " + sizeManager.screenW;
			str += " height: " + sizeManager.screenH;
			str += " screenInGame: " + sizeManager.screenPixelsInGameRatio;
			
			if (Starling.context){
				str += "\nStarling.context: "+Starling.context;		
				str += " driverInfo: "+Starling.context.driverInfo;		
				str += " totalGPUMemory: "+Starling.context.totalGPUMemory;		
				str += " profile: "+Starling.context.profile;		
				str += " maxBackBufferWidth: "+Starling.context.maxBackBufferWidth;		
				str += " maxBackBufferHeight: "+Starling.context.maxBackBufferHeight;		
				str += " backBufferWidth: "+Starling.context.backBufferWidth;		
				str += " backBufferHeight: "+Starling.context.backBufferHeight;		
			}else{
				str += "\nStarling.context: null";		
			}
			return str;
		}
		private function onStarlingContextCreated(e:starling.events.Event):void 
		{
			Cc.log('Context 3D created')
			Cc.log(e.toString())
			Cc.log(e.type);
		}
		private function onStarlingRootCreated(e:starling.events.Event):void 
		{
			Cc.log('Root created')
			Cc.log(e.toString())
			Cc.log(e.type);
		}		
		
		private function onStageResized(e:flash.events.Event):void 
		{
			
			//trace('stage resized!');
			//trace(this.stage.stageWidth);
			//trace(this.stage.stageHeight);
			if (_starling){
				setupScales();
				
				//trace('Screen:',sizeManager.screenW,sizeManager.screenH)
				//trace('Game:',sizeManager.gameWidth,sizeManager.gameHeight)
				
				//задаём порт вывода для Старлинга - он будет показываться на весь экран реального устройства
				var port:Rectangle = new Rectangle(0, 0, sizeManager.screenW, sizeManager.screenH);
				_starling.viewPort = port;
				_starling.stage.stageWidth = sizeManager.gameWidth;
				_starling.stage.stageHeight = sizeManager.gameHeight;			
				
				if (StarApp.app){
					StarApp.app.react2Resize();
				}				
			}

		}
		
		public function showConsole():void 
		{
			Cc.config.style.menuFontSize = 24;
			Cc.config.style.traceFontSize = 22;
			Cc.startOnStage(this);
			
			Cc.width = this.sizeManager.screenW * 0.67;
			Cc.height = this.sizeManager.screenH*0.75;
			Cc.listenUncaughtErrors(this.loaderInfo);							
			
			Cc.visible = true;
			Cc.log(buidCapabilitiesString());
		}
		
		public function hideConsole():void{
			Cc.visible = false;
		}
		public function isPCFullScreen():Boolean{
			trace("stage.displayState = ", stage.displayState)
			return stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE;				
		}
		
		public function startPCWindowScreen():void {
			stage.displayState = StageDisplayState.NORMAL;
		}
		public function startPCFullScreen():void 
		{
			//stage.scaleMode = StageScaleMode.SHOW_ALL;
			trace("stage.displayState = ", stage.displayState)
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;				
		}
		
		public function exitNativeApplication():void 
		{
			NativeApplication.nativeApplication.exit();
		}

		
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (StarApp.app) {
				var b:Boolean = StarApp.app.handleMouseWheel(e);
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			//TODO: продавливать событие выше, в приложение, чтобы для ПК было нормальное управление с клавы
			//Cc.log('onKeyDown', e.keyCode, e.charCode);
			//if (e.keyCode == Keyboard.BACK) {
			//	//Cc.log('backDown');
			//	if (StarApp.app) {
			//		if (StarApp.app.handleBack()) {
			//			e.preventDefault();
			//		}					
			//	}
			//}
			
			//trace(stage.displayState)
			
			//if (e.keyCode == Keyboard.BACK) {
			//	e.preventDefault();
			//}			
			
			
			if (StarApp.app) {
				var b:Boolean = StarApp.app.handleKeyDown(e);
				if (e.keyCode == Keyboard.BACK) {
					if (b){
						//чтобы работал мобильный Back
						e.preventDefault();
					}
				}	
				
				if (e.keyCode == Keyboard.ESCAPE) {
					if (b){
						//чтобы AIR не сворачивался
						e.preventDefault();
					}
				}
			}			
			
			//это для возврата в полноэкранный режим
			//if (e.keyCode == Keyboard.SPACE)
			//{
			//	stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			//	//e.preventDefault();
			//}
		}
		
		
		private function deactivate(e:flash.events.Event):void 
		{
			Cc.log('onDeactivate');
			
			if (NewGameScreen.screen){
				NewGameScreen.screen.onSaveTimer(null);
				if (Main.self.config.platformGroup == 'Mobile'){
					NewGameScreen.screen.stopTimers();
				}
			}
			
			if (Main.self.config.platformGroup=='Mobile'){
				if (_starling){
					_starling.stop(true);
					//if (config.platform != 'iOS'){
					//	stage.displayState = StageDisplayState.NORMAL
					//}					
				}				
			}

			stage.removeEventListener(flash.events.Event.DEACTIVATE, deactivate);
			stage.addEventListener(flash.events.Event.ACTIVATE, activate);	
			
			
			if (SoundPlayer.player) {
				SoundPlayer.player.handleDeactivate();
			}

			if (StatsWrapper.stats) {
				StatsWrapper.stats.react2Deactivation();
			}
		}
		
		private function activate(e:flash.events.Event):void 
		{
			Cc.log('activate');
			
			if (Main.self.config.platformGroup=='Mobile'){
				if (_starling){
					_starling.start();
					
					//if (config.platform != 'iOS'){
					//	var frameRate:int =	Starling.current.nativeStage.frameRate;
					//	Starling.current.nativeStage.frameRate = 10;	
					//	_starling.juggler.delayCall(function():void{Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE}, 0.5);
					//	_starling.juggler.delayCall(function():void{Starling.current.nativeStage.frameRate=frameRate},1);
					//}					
				}
			}
			
			stage.removeEventListener(flash.events.Event.ACTIVATE, activate);
			stage.addEventListener(flash.events.Event.DEACTIVATE, deactivate);	
			
			
			if (SoundPlayer.player) {
				SoundPlayer.player.handleActivate();
			}
			
			if (StatsWrapper.stats) {
				StatsWrapper.stats.react2Activation();
			}	
			
			if (NewGameScreen.screen){
				if (Main.self.config.platformGroup=='Mobile'){
					NewGameScreen.screen.runTimers();
				}
			}
		}
		
	}
	
}