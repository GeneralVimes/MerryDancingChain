package 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import gameplay.controllers.TouchController;
	import gameplay.visual.VisibleWorld;
	import gameplay.worlds.World;
	import globals.MyPool;
	import globals.PlayersAccount;
	import globals.Translator;
	import globals.controllers.CurrenciesController;
	import globals.controllers.PurchaseObject;
	import gui.buttons.BasicButton;
	import gui.pages.GDPRPage;
	import gui.MainHUD;
	import gui.service.Console;
	import gui.text.MultilangTextField;
	import gui.buttons.BitBtn;
	import gui.FancyGuiController;
	import gui.pages.PreStartPage;
	import gui.pages.MapPage;
	import gui.pages.WorldSelectionPage;
	import gui.buttons.SmallButton;
	import managers.ContentAvailabilityController;
	import managers.GameOptionsController;
	import managers.WorldsController;
	import globals.controllers.NewsController;
	import globals.controllers.PlayerRankController;
	import globals.controllers.PlayerRequestsController;
	import globals.controllers.PlayersDataController;
	import globals.controllers.PurchaseController;
	import globals.controllers.WorldsSaveData;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	/**
	 * ...
	 * @author General
	 */
	public class NewGameScreen extends Sprite
	{
		static public var screen:NewGameScreen;
		
		public var currentWorld:World;
		public var touchController:TouchController;
		
		public var worldsController:managers.WorldsController;
		
		public var fgc:gui.FancyGuiController;
		public var hud:MainHUD;

		
		public var purchaseController		:PurchaseController;
		public var newsController			:NewsController;
		public var playerRankController	:PlayerRankController;
		public var playerRequestsController	:PlayerRequestsController;
		public var worldsSaveData			:WorldsSaveData;
		public var currenciesController			:CurrenciesController;
		public var contentController			:ContentAvailabilityController
		public var optionsController			:GameOptionsController//чтобы хранить разные настройки не в PlayerAccount
		private var allControllers:Vector.<globals.controllers.PlayersDataController>;
		
		private var console:Console;
		private var sensitiveIm:Image;
		private var saveTimer:Timer;
		public function NewGameScreen() 
		{
			screen = this;
			worldsController = new managers.WorldsController();
			EnhanceWrapper.init(null);
			
			saveTimer = new Timer(30000, 0);
			
			
			purchaseController		 = new PurchaseController();
			newsController			 = new NewsController();
			playerRankController	 = new PlayerRankController();
			playerRequestsController = new PlayerRequestsController();
			worldsSaveData			 = new WorldsSaveData();
			currenciesController	 = new CurrenciesController();
			contentController		 = new ContentAvailabilityController();
			optionsController		 = new GameOptionsController();
			
			
			allControllers = new Vector.<globals.controllers.PlayersDataController>();
			
			allControllers.push(purchaseController		)
			allControllers.push(newsController			)
			allControllers.push(playerRankController	)
			allControllers.push(playerRequestsController)
			allControllers.push(worldsSaveData			)
			allControllers.push(currenciesController			)
			allControllers.push(contentController			)
			allControllers.push(optionsController			)
		
			purchaseController.initPurchasesAr(worldsController.purchasesData);
			currenciesController.initCurrenciesAr(worldsController.consumableCurrencies, purchaseController);//фиксируем связь, какие покупки какую валюту дают
			
			doLoading();
			
			newsController.loadNews();
			
			touchController = new TouchController();
			touchController.registerSenstitiveSprite(this);
			
			
			
			//public var miscSaveData:WorldsSaveData;
			//вот сюда по идее, надо контроллеров ачивок, покупок, просилок голосовалок, новостей
			//т.к. они должны выгружать данные из общего массива
			
			//или тогда miscSaveData унести в NewGamesScreens			
			
			
			
			hud = new MainHUD(this);
			
			fgc = new FancyGuiController();
			
			
			createListeners();
			
			
			hud.showPageOfClass(PreStartPage);
			//унесли popup отсюда глубже, чтобы Эппл не ругался
			//EnhanceWrapper.showInitialPopupIfNeeded(); - теперь внутри EnhanceWrapper.serviceTermsOptIn();
		}
		
		public function consoleText(txt:String):void{
			console.showText(txt);
			if (!console.parent){
				addChild(console);
			}
		}
		
		//private function testMsgBox(btn:BasicButton=null):void 
		//{
		//	hud.showMessage('Test', 'Text', ["OK", "Cancel"], [{func:this.testMsgBox2}], null, {statsCode:"2vars"});
		//}	
		//private function testMsgBox2(btn:BasicButton=null):void 
		//{
		//	hud.showMessage('Test', 'Text', ["OK", "Cancel", "V2", "V3", "V4", "V5"], null, null, {statsCode:"5vars"});
		//}
		
		private function moveBitBtn(btn:BasicButton, pt:Point):void 
		{
			btn.x = pt.x;
			btn.y = pt.y;
		}
		
		private function onFrame(e:Event):void 
		{
			//trace('Frame');
			if (currentWorld){
				currentWorld.makeAMoveOnFrame();
			}
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			//trace('Touch');
			fgc.handleTouch(e, this);//это чисто стейты батонов
			
			if (currentWorld){
				if (currentWorld.playStatus==1){
					//здесь тачи на самом экране
					touchController.react2Touch(e);				
				}				
			}				
		}
		
		public function checkGDPRAndStartSession():void 
		{
			var needsGDPR:Boolean = (Main.self.config.platformGroup == 'Mobile');
			if (needsGDPR){
				if (PlayersAccount.account.getParamOfName("dataOptInResult", "unknown") != 'consentGiven'){
					hud.showPageOfClass(GDPRPage);
				}else{
					EnhanceWrapper.serviceTermsOptIn();
				}
			}else{
				EnhanceWrapper.serviceTermsOptIn();
			}
			
		}
		
		public function react2Resize():void 
		{
			hud.react2Resize();
			if (sensitiveIm){
				sensitiveIm.width = Main.self.sizeManager.gameWidth;
				sensitiveIm.height = Main.self.sizeManager.gameHeight;
			}
			if (console){
				console.alignOnScreen();
			}
			
			if (currentWorld){
				currentWorld.react2Resize()
			}
			touchController.cheatController.react2Resize()
		}
		
		public function stopTimers():void 
		{
			saveTimer.stop();
			hud.stopUpdateTimers();
		}
		
		public function onSaveTimer(e:TimerEvent=null):void 
		{
			//return;
			if (currentWorld){
				if (currentWorld.canBSaved()){
						PlayersAccount.account.newSavedGame.defaultLoadedWorldId = currentWorld.worldTypeId - 1;
						PlayersAccount.account.newSavedGame.setSaveVersion(PlayersAccount.account.newSavedGame.defaultLoadedWorldId, Main.self.config.saveVersion);
						var ar:Array=PlayersAccount.account.newSavedGame.getBigSaveArOfId(
								PlayersAccount.account.newSavedGame.defaultLoadedWorldId,
								false
							)						
						var newArLen:int = currentWorld.save2Ar(ar,0);
						ar.length = newArLen;

						//trace("save length:",ar.length)
						//var ob:Object = {};
						//currentWorld.save2Ob(ob);
						//trace(ob);
						//var str:String = JSON.stringify(ob);
						//trace(str);
						
						PlayersAccount.account.newSavedGame.backupSave2File(PlayersAccount.account.newSavedGame.defaultLoadedWorldId);
						PlayersAccount.account.newSavedGame.fixSavedInitialization(PlayersAccount.account.newSavedGame.defaultLoadedWorldId)
						worldsSaveData.updateWorldsRecord(currentWorld.worldTypeId, currentWorld.getDiscoveryPercentage())

						PlayersAccount.account.save2DiscNew();				
				}
			}
			doSaving();
			PlayersAccount.account.doFlush();
		}
		
		public function isWorldUnlocked(wid:int):Boolean{
			if (worldsController.isWorldUnlockedFromStart(wid)){
				return true;
			}else{
				return worldsSaveData.isWorldUnlockedInRecords(wid);
			}
		}
		
		public function runTimers():void 
		{
			saveTimer.reset();
			saveTimer.start();
			hud.runUpdateTimers();
		}
		
		public function startPlayingWorld(worldOb:Object, skinId:int=0):void 
		{
			//worldOb.id
			//worldOb.cls
			//при смене ассетов страницы и так уберутся
			//hud.hidePageOfClass(WorldSelectionPage);
			//hud.hidePageOfClass(PreStartPage);
			//hud.hidePageOfClass(MapPage);//это и есть WorldSelectionPage
			
			if (skinId >= worldOb.skins.length){
				skinId = 0;
			}
			
			switchAssets2LoadWorld(worldOb.id, worldOb.skins[skinId]);
		}
		
		public function startPreloadedWorld():void 
		{
			createOrLoadWorld(StarApp.app.nxtWorldId2Switch, StarApp.app.nxtSkin2Switch.code);
		}
		
		private function createOrLoadWorld(wid:int, skinCode:String):void 
		{
			console = new Console();
			
			trace("createOrLoadWorld", wid)
			sensitiveIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0, 0, "left", "top");
			sensitiveIm.color = 0xAF732B;
			sensitiveIm.width = Main.self.sizeManager.gameWidth;
			sensitiveIm.height = Main.self.sizeManager.gameHeight;
			
			var wob:Object = worldsController.getObOfId(wid);
			worldsSaveData.setCurrentlyPlayedWorldUID(wid);
			
			var unmovedBackSprite:Sprite = new Sprite();
			addChild(unmovedBackSprite);
			var unmovedTopSprite:Sprite = new Sprite();
			
			currentWorld = new wob.cls(wob, unmovedBackSprite, this, unmovedTopSprite);
			

			addChild(unmovedTopSprite);				
			hud.registerBaseDob(unmovedTopSprite);
			//hud.showMessage("World loaded:"+wob.name, wob.desc, ["OK"], null, null, null);
			
			touchController.registerMovedSprite(currentWorld.visualization);
			
			if (Main.self.config.specificSave2Test){
				currentWorld.loadGameFromSpecificAr(Main.self.config.specificSave2Test)
			}else{
				currentWorld.loadOrCreateNew();
			}
			
			
			
		}
		
		public function removeListeners():void 
		{
			saveTimer.removeEventListener(TimerEvent.TIMER, onSaveTimer);
			//glueTimer.removeEventListener(TimerEvent.TIMER, onGlueTimer);
			removeEventListener(TouchEvent.TOUCH, onTouch);
			removeEventListener(Event.ENTER_FRAME, onFrame);				
		}
		public function createListeners():void 
		{
			saveTimer.addEventListener(TimerEvent.TIMER, onSaveTimer);
			//glueTimer.removeEventListener(TimerEvent.TIMER, onGlueTimer);
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.ENTER_FRAME, onFrame);				
		}
		
		public function rebuildPools():void 
		{
			hud.clearPool();
		}
		
		private function switchAssets2LoadWorld(wid:int, skinOb:Object):void 
		{
			StarApp.app.switchMergedArt4World(wid, skinOb);
		}
		
		public function doSaving():void{
			PlayersAccount.account.saveGlobalData(this.allControllers);
		}
		
		public function handleKeyDown(e:KeyboardEvent):Boolean 
		{
			var b:Boolean = hud.handleKeyboardEvent(e);
			if (!b){
				if (currentWorld){
					return currentWorld.handleKeyboardEent(e);
				}else{
					return false;
				}				
			}else{
				return b;
			}
		}
		
		public function handleMouseWheel(e:flash.events.MouseEvent):Boolean 
		{
			var b:Boolean = hud.handleMouseWheel(e);
			if (!b){
				if (currentWorld){
					return currentWorld.handleMouseWheel(e);
				}else{
					return false;
				}				
			}else{
				return b;
			}			
		}
		
		public function react2PurchaseConsumption(purch:globals.controllers.PurchaseObject):void 
		{
			if (this.currentWorld){
				this.currentWorld.artifactsController.consumeArtifactConnectdWithPurch(purch);
			}
		}
		
		public function clearCurrentWorld():void
		{
			if (currentWorld){
				currentWorld.prepare2LoadNew()//т.е. очищаем предыдущий мир, чтоб не висел в памяти
			}
		}

		
		private function doLoading():void{
			PlayersAccount.account.loadGlobalData(this.allControllers);
		}
		
	}

}