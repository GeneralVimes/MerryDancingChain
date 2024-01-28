package gameplay.worlds 
{
	import com.junkbyte.console.Cc;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import globals.controllers.PurchaseController;
	import managers.SpreadedCalculationsManager;


	import gameplay.basics.BasicGameObject;

	import gameplay.basics.UnMovedBGD;
	import gameplay.basics.service.PurchasedRecord;
	import gameplay.basics.service.UpgradedParam;


	import gameplay.visual.EffectsController;
	import gameplay.worlds.service.ArtifactObject;
	import gameplay.worlds.service.ArtifactsController;
	import gameplay.worlds.service.CodeBonusesController;
	import gameplay.worlds.service.DiscoveryController;
	import gameplay.worlds.service.GiftsController;
	import gameplay.worlds.service.NewsController;
	import gameplay.worlds.service.TimeFlowController;
	import gameplay.worlds.service.LoadingController;
	import gameplay.worlds.service.SavedWorldParamsController;
	import gameplay.worlds.service.TriggerController;
	import gameplay.worlds.service.TutController;
	import gameplay.worlds.states.NormalState;
	import gameplay.worlds.states.WorldState;
	import globals.PlayersAccount;
	import globals.StatsWrapper;
	import globals.Translator;


	import saves.NewSavedGame;
	import service.TouchInfo;
	import starling.display.DisplayObjectContainer;
	import gameplay.controllers.Ballanser;
	import gameplay.controllers.Purchaser;
	import gameplay.visual.VisibleWorld;
	import gameplay.visual.WorldHUD;
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class World 
	{
		protected var callBacksOnCreation:Dictionary;
		protected var callBacksOnCycleCompletion:Dictionary;
		protected var callBacksOnDestroy:Dictionary;
		
		protected var screenCenterXAtCreation:Number=0;
		protected var screenCenterYAtCreation:Number = 0;
		
		public var money:Number = 0;
		public var numRestarts:int = 0;
		public var prestige:int = 0;
		
		
		protected var maxShownRect:Rectangle = new Rectangle();
		protected var fields4Interface:Object = {left:0, top:0, right:0, bottom:0}
		protected var loadController:LoadingController;
		
		public var timeController:TimeFlowController;
		public var giftsController:GiftsController;
		protected var triggerController:TriggerController;
		public var artifactsController:ArtifactsController;
		public var newsController:NewsController	
		public var codeBonusesController: CodeBonusesController
		public var discoveryController: DiscoveryController
		protected var paramsControllers:Vector.<SavedWorldParamsController>;
		
		protected var effectsController:EffectsController;
		
		protected var tutController:TutController;
		protected var triggersAr:Array = [];
		
		public var worldTypeId:int;//назначается World Manager'ом при создании
		
		public var worldName:String;
		public var worldDesc:String;
		
		public var currentSkinCode:String;//в зависимости от кода скина могут быть разные отрисовки объектов
		
		public var hud:WorldHUD;
		public var ballanser:Ballanser;
		public var purchaser:Purchaser;
		public var visualization:VisibleWorld;
		public var playStatus:int = -1;//0 - загрузка, 1 - игра
		
		public var currentState:WorldState;
		private var lastActualizaionTime:Number = 0;
		private var isHilbernated:Boolean = false;
	
		
		
		public var allowedDrags:Rectangle = new Rectangle();
		
		public var vecs4Objects:Vector.<Vector.<BasicGameObject>>;
		public var unMovedBackObjects:Vector.<UnMovedBGD>;
		
		protected var delayedRewardObject:Object;	
		protected var lastAdsCallTime:Number = 0;	
		
		public var functionsDict:Dictionary;//чтобы была возможность вызвать функцию из объекта, не имеющего доступа к классу мира-потомка
		public var spreadedCalculationsManager:SpreadedCalculationsManager;
		public function World(wob:Object, sprBack:DisplayObjectContainer, visHolder:DisplayObjectContainer, sprFront:DisplayObjectContainer) 
		{
			worldTypeId = wob.id;
			
			worldName = wob.name;
			worldDesc = wob.desc;
			
			currentSkinCode = Assets.workingSkinCode;
			hud = new wob.hudCLS(sprFront, this);
			hud.hideAll();
			ballanser = new wob.balCLS();
			purchaser = new wob.purchCLS();
			visualization = new VisibleWorld(this);
			
			callBacksOnCreation = new Dictionary();
			callBacksOnCycleCompletion = new Dictionary();
			callBacksOnDestroy = new Dictionary();
			
			functionsDict = new Dictionary();
			
			maxShownRect.setTo(0, 0, Main.self.sizeManager.gameWidth, Main.self.sizeManager.gameHeight);
			
			visualization.setMaxVievedZoneFromRect(this.maxShownRect);
			visualization.initFields4Interface(this.fields4Interface);
			
			visualization.registerUnmovedBackSprite(sprBack);
			visHolder.addChild(visualization);
			
			vecs4Objects = new Vector.<Vector.<gameplay.basics.BasicGameObject>>();
			
			loadController = new LoadingController(this);
			
			paramsControllers = new Vector.<gameplay.worlds.service.SavedWorldParamsController>();
			timeController = new TimeFlowController(this);
			giftsController = new GiftsController(this);
			triggerController = new TriggerController(this);
			artifactsController = new ArtifactsController(this);		
			newsController = new NewsController(this);		//OBSOLETE BUT IS ALREADY SAVED
			codeBonusesController = new CodeBonusesController(this);		
			discoveryController = new DiscoveryController(this);		
			paramsControllers.push(timeController, giftsController, triggerController, artifactsController,newsController,codeBonusesController,discoveryController);
			
			effectsController = new EffectsController(this);
			tutController = new TutController(this);
			
			unMovedBackObjects = new Vector.<gameplay.basics.UnMovedBGD>();
			
			spreadedCalculationsManager = new SpreadedCalculationsManager(this);
			
			currentState = new NormalState(this);
		}

		
		public function prepare2LoadNew():void 
		{
			clearAllObjects();
			hud.resetAfterRestart();
			NewGameScreen.screen.hud.clearStack();
		}		
		
		public function doRestart():void{
			this.numRestarts++;
			this.calcPrestigeAfterRestart();
			
			this.clearAllObjects();
			this.setWorldAnchorCoords()
			this.doInitialThings(true);
			hud.resetAfterRestart();
			NewGameScreen.screen.hud.clearStack();
			visualization.setNewCoordsAndScale(visualization.x, visualization.y, visualization.scale);
			//чтобы был стейт, а не null -> надо вынести в главный движок
			startState(NormalState,{});
		}
		
		protected function clearAllObjects():void 
		{
			for (var i:int = 0; i < vecs4Objects.length; i++ ){
				var vec:Vector.<BasicGameObject> = vecs4Objects[i];
				for (var j:int = vec.length - 1; j >= 0; j-- ){
					if (vec[j]){
						vec[j].prepare4Removal();
					}
				}
			}
			removeQuedForRemovelObjects();
			//а теперь для верности выставляем все длины в 0
			for (i = 0; i < vecs4Objects.length; i++ ){
				vecs4Objects[i].length = 0;
			}
			
			triggerController.clear();
			tutController.clear();
			effectsController.clear();
			NewGameScreen.screen.hud.closeAllMessages();
			
			if (currentState){
				currentState.finalize();
				currentState = null;
			}
		}
		
		public function removeQuedForRemovelObjects():void{
			var prc:Number = 0;
			for (var k:int = 0; k < vecs4Objects.length; k++ ){
				var vec:Vector.<BasicGameObject> = vecs4Objects[k];
				var wereRemovalsMade:Boolean = false;
				for (var j:int = vec.length - 1; j >= 0; j-- ){
					var ob:BasicGameObject = vec[j];
					if (ob.isQueued4Removeal){
					//	prc += ob.purchasedPrice;
						
						vec.splice(j, 1);
						
						ob.getRemovedFromScreenCompletely();
						wereRemovalsMade = true;
					}
				}
				if  (wereRemovalsMade){
					for (j = 0; j < vec.length; j++ ){
						vec[j].arId = j;
					}
				}
			}
		}	
		
		protected function calcPrestigeAfterRestart():void 
		{
			
		}
		
		protected function doInitialThings(isAfterRestart:Boolean):void 
		{
			if (isAfterRestart){
				this.setAfterRestartMoneyAndOtherParams();
			}else{
				this.setVeryInitialMoneyAndOtherParams();
			}
			
			this.createBGDs();
			this.createInitialObjects();
			this.createTriggers();
			this.updateUnmovableBGDs();
			hud.showAll();
			playStatus = 1;
		}
		
		protected function updateUnmovableBGDs():void 
		{
			
		}
		
		protected function createTriggers():void 
		{
			Cc.log('createTriggers',this.triggersAr.length)
			for (var i:int=0; i<this.triggersAr.length; i++){
				var ob:Object = this.triggersAr[i];
				this.triggerController.registerTriggerIfNew(ob)
			}
		}
		
		protected function hasSomethingPreventingTutorial():Boolean 
		{
			return this.timeController.isSpeedingTime() ||
					(tutController.hasActiveTutorial() || NewGameScreen.screen.hud.hasOpenPage() || NewGameScreen.screen.hud.hasOpenMessage());
		}		
		
		protected function createBGDs():void 
		{
			
		}
		
		protected function setVeryInitialMoneyAndOtherParams():void 
		{
			visualization.setNewCoordsAndScale(0, 0, 1);
			this.numRestarts = 0;
			money = 0;
		}
		protected function setAfterRestartMoneyAndOtherParams():void 
		{
			visualization.setNewCoordsAndScale(0, 0, 1);
			money = 0;
		}
		
		protected function createInitialObjects():void 
		{
			timeController.initTime4NewWorld();
			
		}
		
		public function react2DoubleTapAtCoords(wrlX:Number, wrlY:Number):void 
		{
			trace('react2DoubleTapAtCoords',wrlX, wrlY)
		}
		
		public function react2ClickAtCoords(wrlX:Number, wrlY:Number):void 
		{
			trace('react2ClickAtCoords',wrlX, wrlY)
		}
		
		public function react2LongTapAtCoords(wrlX:Number, wrlY:Number):void 
		{
			trace('react2LongTapAtCoords',wrlX, wrlY)
		}		
		
		public function react2NewVisualizationCoords():void 
		{
			for (var i:int = 0; i < unMovedBackObjects.length; i++ ){
				unMovedBackObjects[i].react2NewVisPos(visualization.x, visualization.y, visualization.scale);
			}
			this.hud.react2NewVisualizationCoords();
			if (this.currentState){
				this.currentState.react2NewVisualizationCoords();
			}
		}
		
		public function react2NewVisualizationScale():void 
		{
			this.hud.react2NewVisualizationScale();
			if (this.currentState){
				this.currentState.react2NewVisualizationScale();
			}
		}
		
		public function react2Resize():void 
		{
			//возможно, стоит изменять не maxShownRect, а содавать какой-то временный Rect? Чтобы при возврате к обычной ориентации всё возвращалось как было?
			
			var oldScreenCenterX:Number = visualization.scrX2World( Main.self.sizeManager.oldGameWidth / 2 );
			var oldScreenCenterY:Number = visualization.scrY2World( Main.self.sizeManager.oldGameHeight / 2 );
			//trace('old:',oldScreenCenterX, oldScreenCenterY)
			if (maxShownRect.width < Main.self.sizeManager.gameWidth){
				var delta:Number = Main.self.sizeManager.gameWidth - maxShownRect.width;
				maxShownRect.left -= delta / 2;
				maxShownRect.right += delta / 2;
			}
			if (maxShownRect.height < Main.self.sizeManager.gameHeight){
				delta = Main.self.sizeManager.gameHeight - maxShownRect.height;
				maxShownRect.top -= delta / 2;
				maxShownRect.bottom += delta / 2;
			}
			
			visualization.updateScreenRectOnScreen();
			
			visualization.setMaxVievedZoneFromRect(this.maxShownRect);
			
			visualization.showWorldPointAtScreenCenter(oldScreenCenterX, oldScreenCenterY);
			NewGameScreen.screen.touchController.changeVisWorldScale(1, Main.self.sizeManager.gameWidth / 2 , Main.self.sizeManager.gameHeight / 2 );
			
			hud.react2Resize();
			
			if (currentState){
				currentState.react2Resize();
			}
			
			//trace(Main.self.sizeManager.gameWidth,Main.self.sizeManager.gameHeight,visualization.scale)
			//trace('new:',visualization.scrX2World( Main.self.sizeManager.gameWidth / 2 ), visualization.scrY2World( Main.self.sizeManager.gameHeight / 2 ))
		}
		
		//dir: left, right, top, bottom
		public function expandMaxShownRect(dir:String, dist:Number):void{
			switch (dir){
				case 'left':{
					this.maxShownRect.left -= dist;
					break;
				}
				case 'top':{
					this.maxShownRect.top -= dist;
					break;
				}
				case 'right':{
					this.maxShownRect.right += dist;
					break;
				}
				case 'bottom':{
					this.maxShownRect.bottom += dist;
					break;
				}
			}
			
			visualization.setMaxVievedZoneFromRect(this.maxShownRect);
		}
		
		public function getMostLeftCoord():Number{
			return maxShownRect.left
		}
		public function getMostTopCoord():Number{
			return maxShownRect.top
		}
		public function getMostBotCoord():Number{
			return maxShownRect.bottom
		}
		public function getMostRightCoord():Number{
			return maxShownRect.right
		}
		
		public function showInterstitial():void{
			lastAdsCallTime = this.timeController.getRealWorldTime();
			EnhanceWrapper.showInterstitialAd();
		}
		
		public function giveRewardAfterAds(rewardOb:Object):void 
		{
			delayedRewardObject = rewardOb;
			lastAdsCallTime = this.timeController.getRealWorldTime();
			EnhanceWrapper.showRewardedAd(onRewardedAdGranted, onRewardedAdDeclined, onRewardedAdUnavailable);
		}
		public function giveRewardAfterSkipAds(rewardOb:Object):void 
		{
			lastAdsCallTime = this.timeController.getRealWorldTime();
			giveReward(rewardOb,true);
			NewGameScreen.screen.currenciesController.spendCurrency("currency_ads_skips", 1)
		}		
		
		private function onRewardedAdGranted(type:String, value:int):void 
		{
			giveReward(delayedRewardObject,true);
		}
		
		private function onRewardedAdDeclined():void 
		{
			
		}
		
		private function onRewardedAdUnavailable():void 
		{
			showMessage("TXID_SOMETHINGWRONG", "TXID_TRYAGAIN", ["TXID_MSGANS_OK"]);
		}
				
		public function giveReward(rewardOb:Object, mustNotify:Boolean=false):void 
		{
			if (rewardOb!=null){
				if (mustNotify){
					this.showMessage('TXID_MSG_REWRECEIVED',this.buildRewardInfo(rewardOb),["TXID_MSGANS_OK"], [], null )
					StatsWrapper.stats.logTextWithParams('reward_received', rewardOb.rewardType);				
				}
			}
			
			if (rewardOb!=null){
				if (rewardOb.rewardType=='freeMoney'){
					var val:Number = rewardOb.rewardValue;
					this.money += val;
				}
				if (rewardOb.rewardType=='multiplyMoney'){
					val = rewardOb.rewardCoef;
					this.money += this.money*(rewardOb.rewardCoef-1);
				}
				if (rewardOb.rewardType=='forwardTime'){
					val = rewardOb.rewardValue;
					timeController.cheatForwardTime(val)
				}
				if (rewardOb.rewardType=='hardCurrency'){
					var curCode:String = rewardOb.resourceName;
					val = rewardOb.rewardValue;
					NewGameScreen.screen.currenciesController.gainCurrency(curCode, val)
				}
				if (rewardOb.rewardType == 'combinedReward'){
					for (var i:int = 0; i < rewardOb.rewards.length; i++ ){
						giveReward(rewardOb.rewards[i], mustNotify)
					}
				}
			}			
		}
				
		public function createNewReward4Myself(currentGidtId:int):Object 
		{
			var rewardOb:Object = {};
			
			rewardOb.rewardType = 'freeMoney';
			if (currentGidtId == 0){
				rewardOb.rewardValue = 50;
			}else{
				rewardOb.rewardValue = (0.1 + 0.5 * Math.random()) * this.money;
				if (rewardOb.rewardValue < 50){
					rewardOb.rewardValue = 50;
				}
			}
			
			return rewardOb;
		}
		
		public function buildRewardInfo(rewardOb:Object):String 
		{
			var res:String='';
			if (rewardOb!=null){
				if (rewardOb.rewardType=='freeMoney'){
					res = 'TXID_REW_FREEMON: '+Routines.showNumberInAAFormat(rewardOb.rewardValue);
				}	
				if (rewardOb.rewardType=='multiplyMoney'){
					res = 'TXID_REW_MULTMON x'+Routines.showNumberInAAFormat(rewardOb.rewardCoef);
				}	
				if (rewardOb.rewardType=='forwardTime'){
					res = 'TXID_REW_TIMEFORWARD '+Routines.convertSeconds2SmallTimeString(rewardOb.rewardValue);
				}
				if (rewardOb.rewardType=='hardCurrency'){
					res = Routines.showNumberInAAFormat(rewardOb.rewardValue)+' '+NewGameScreen.screen.currenciesController.getCurrencyName(rewardOb.resourceName);
				}	
				if (rewardOb.rewardType == 'combinedReward'){
					for (var i:int = 0; i < rewardOb.rewards.length; i++ ){
						res += buildRewardInfo(rewardOb.rewards[i]) + '\n';
					}
				}
			}
			
			return res;			
		}
		public function willRewardHaveEffect(rewardOb:Object):Boolean
		{
			var res:Boolean=false;
			if (rewardOb!=null){
				if (rewardOb.rewardType=='freeMoney'){
					res = true;
				}	
				if (rewardOb.rewardType == 'multiplyMoney'){
					res = this.money>=1
				}	
				if (rewardOb.rewardType=='forwardTime'){
					res = true;
				}	
				if (rewardOb.rewardType=='hardCurrency'){
					res = true;
					if (rewardOb.resourceName == "currency_ads_skips"){
						res = Main.self.config.platformGroup == 'Mobile';
					}
				}
				if (rewardOb.rewardType == 'combinedReward'){
					res = false;
					for (var i:int = 0; i < rewardOb.rewards.length; i++ ){
						res ||= willRewardHaveEffect(rewardOb.rewards[i]);
						if (res){
							break;
						}
					}
				}				
			}
			
			return res;			
		}
		
		public function callWorldLongTap(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			if (this.currentState){
				currentState.callWorldLongTap(wx, wy, sx, sy, inf);
			}
		}
		
		public function callWorldClick(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			if (this.currentState){
				currentState.callWorldClick(wx, wy, sx, sy, inf);
			}
		}
		
		public function callWorldDoubleClick(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			if (this.currentState){
				currentState.callWorldDoubleClick(wx, wy, sx, sy, inf);
			}
		}
		
		public function callWorldDown(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			if (this.currentState){
				currentState.callWorldDown(wx, wy, sx, sy, inf);
			}
		}
		
		public function callWorldUp(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			if (this.currentState){
				currentState.callWorldUp(wx, wy, sx, sy, inf);
			}
		}
		
		public function callWorldHover(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			if (this.currentState){
				currentState.callWorldHover(wx, wy, sx, sy, inf);
			}
		}
		
		public function callWorldMove(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			if (this.currentState){
				currentState.callWorldMove(wx, wy, sx, sy, inf);
			}
		}
		
		public function callWorldLeave():void 
		{
			if (this.currentState){
				currentState.callWorldLeave();
			}
		}
		
		public function loadOrCreateNew():void 
		{
			var loadPossibility:int = canLoadGameFrom(PlayersAccount.account.newSavedGame);
			if (loadPossibility == 1){
				var wasLastAttempt:Boolean = PlayersAccount.account.getParamOfName("loadingAttempt_W_"+this.worldTypeId.toString(), "-1") == this.worldTypeId.toString();
				if (wasLastAttempt){
					showMessage("TXID_LASTLOADATTEMPT","TXID_SEND",["TXID_TRYLOADAGAIN","TXID_SENDREPORT","TXID_STARTNEW"],[{func:this.loadGame},{func:this.sendLoadedArReport},{func:this.createNew}])
				}else{
					loadGame();
				}
				
			}else{
				createNew();
				//loadPossibility == -1 - сказать, что старый сейв не поддерживается и дать какой-то бонус
				if (loadPossibility==-1){
					giveBonus2OldTester()
				}
			}
		}
		
		protected function giveBonus2OldTester():void 
		{
			
		}
		
		private function sendLoadedArReport():void 
		{
			Main.self.showConsole();
			Cc.log(Translator.translator.getLocalizedVersionOfText("TXID_SAVEDATA"))
			Cc.log("vvvvvvvvvvvvvvvvvvv")
			var wid:int = worldTypeId - 1; 
			var ar:Array = PlayersAccount.account.newSavedGame.getBigSaveArOfId(wid);
			Cc.log(ar);
			Cc.log("^^^^^^^^^^^^^^^^^^^")
			Cc.log(Translator.translator.getLocalizedVersionOfText("TXID_SAVEDATA"))
		}
		
		private function sendLoadedArReportFromController():void 
		{
			Main.self.showConsole();
			Cc.log(Translator.translator.getLocalizedVersionOfText("TXID_SAVEDATA"))
			Cc.log("vvvvvvvvvvvvvvvvvvv")
			var wid:int = worldTypeId - 1; 
			var ar:Array = loadController.getCurrentlyLoadedArray();
			Cc.log(ar);
			Cc.log("^^^^^^^^^^^^^^^^^^^")
			Cc.log(Translator.translator.getLocalizedVersionOfText("TXID_SAVEDATA"))
		}
		
		protected function createNew():void 
		{
			PlayersAccount.account.setParamOfName("loadingAttempt_W_" + this.worldTypeId.toString(), "-1")
			setWorldAnchorCoords();
			doInitialThings(false);
			visualization.showWorldPointAtScreenCenter(screenCenterXAtCreation, screenCenterYAtCreation);
		}
		
		protected function setWorldAnchorCoords():void 
		{
			screenCenterXAtCreation = Main.self.sizeManager.gameWidth / 2;
			screenCenterYAtCreation = Main.self.sizeManager.gameHeight / 2;			
		}

		public function continueGame():void{
			loadGame();
		}
		
		private function loadGame():void 
		{
			//вот тут надо поставиьт метку "попытка загрузки мира", чтобы если будет креш, отправить репорт
			PlayersAccount.account.setParamOfName("loadingAttempt_W_"+this.worldTypeId.toString(), this.worldTypeId.toString());
			
			var wid:int = worldTypeId - 1; 
			PlayersAccount.account.setCurrentlyLoadedSaveVersion(PlayersAccount.account.newSavedGame.getSaveVersion(wid));
			var ar:Array = PlayersAccount.account.newSavedGame.getBigSaveArOfId(wid);
			
			loadGameFromSpecificAr(ar, null);
		}
		
		public function loadGameFromSpecificOb(ob:Object, bkpAr:Array = null, preCompletionCallBack:Function=null, afterCompletionCallBack:Function=null):void{
			loadController.initializeLoadingfromOb(ob, bkpAr, preCompletionCallBack,afterCompletionCallBack);
		}
		public function loadGameFromSpecificAr(ar:Array, bkpAr:Array = null, preCompletionCallBack:Function=null, afterCompletionCallBack:Function=null):void{
			for (var i:int = 0; i < ar.length; i++ ){
				if (isNaN(ar[i])||(ar[i]==Infinity)||(ar[i]==-Infinity)){
					ar[i] = 0;
				}
			}			
			loadController.initializeLoading(ar, bkpAr, preCompletionCallBack,afterCompletionCallBack);
		}
		
		public function canContinuePreviousGame():Boolean{
			return canLoadGameFrom(PlayersAccount.account.newSavedGame) == 1;
		}
		
		protected function canLoadGameFrom(newSavedGame:saves.NewSavedGame):int 
		{
			if (Main.self.config.mustClearSave){
				return 0;
			}
			//
			var res:int = 0;//сейва нет
			//тут всё ок	
			
			
			var saveVersion:String = newSavedGame.getSaveVersion(this.worldTypeId-1);
			
			if (newSavedGame.doesSaveExist(this.worldTypeId-1)){
				res = 1;
			}
			
			//а вообще при фактической загрузке при ошибке на любом шаге надо откатываться и стартовать заново
			
			//что делать если версия мира кардинало утсарела и обратно несовместима?
			//это сам мир будет определять
			if (res==1){
				if (!isSaveVersionSupported(saveVersion)){
					res =-1;
				}
			}
			
			
			if (res == 1){//а теперь смотрим сам массив
				var saveAr:Array = newSavedGame.getBigSaveArOfId(this.worldTypeId - 1);
				res = canLoadGameFromAr(saveAr);
			}
			
			return res;		
		}
		
		
		protected function isSaveVersionSupported(saveVersion:String):Boolean 
		{
			//иногда тут могут быть старевшие версии, которые больше не поддерживаются
			return true;
		}
		
		protected function isSaveIntVersionSupported(saveVersion:int):Boolean 
		{
			//иногда тут могут быть старевшие версии, которые больше не поддерживаются
			return true;
		}
		
		public function canLoadGameFromOb(ob:Object):int{
			var res:int = 1;
			if (!isSaveIntVersionSupported(ob["saveIntVersion"])){
				res =-1;//просто версия сохрана устарела
			}else{
				if (ob["worldTypeId"] != this.worldTypeId){
					res =-1;//не от того мира
				}
			}
			return res;
		}
		public function canLoadGameFromAr(ar:Array):int
		{
			var res:int = 1;
			if (ar.length < 9){
				res = 0; //сейв короче минимального размера - считай, чтоего нет
			}else{
				if (!isSaveIntVersionSupported(ar[0 + 0])){
					res =-1;//просто версия сохрана устарела
				}else{
					if (ar[0 + 2] != this.worldTypeId){
						res =-1;//не от того мира
					}
				}
			}
			return res;
		}

		public function save2Ob(ob:Object):Object{
			ob["saveIntVersion"] = Main.self.config.saveIntVersion;
			ob["getTime"] = (new Date()).getTime();
			ob["worldTypeId"] = this.worldTypeId;
			ob["gameId"] = Main.self.config.gameId;
			saveOwnParams2Ob(ob);
			ob["paramsControllers"] = [];
			saveParamsControllers2Ar(ob["paramsControllers"], 0);
			ob["vectorsObs"] = [];
			saveVectorsOfObjects2Ar(ob["vectorsObs"], 0);
			return ob;
		}
		public function save2Ar(ar:Array, nxtId:int):int{
			ar[nxtId + 0] = Main.self.config.saveIntVersion;
			ar[nxtId + 1] = (new Date()).getTime();
			ar[nxtId + 2] = this.worldTypeId;
			ar[nxtId + 3] = Main.self.config.gameId;
			ar[nxtId+4] = 0;
			ar[nxtId+5] = 0;
			ar[nxtId+6] = 0;
			ar[nxtId+7] = 0;
			ar[nxtId+8] = 0;			
			ar[nxtId+9] = 0;			
			nxtId += 10;
			nxtId = saveOwnParams2Ar(ar, nxtId);
			nxtId = saveParamsControllers2Ar(ar, nxtId);
			nxtId = saveVectorsOfObjects2Ar(ar, nxtId);
			return nxtId;
		}
		
		protected function saveVectorsOfObjects2Ar(ar:Array, nxtId:int):int 
		{
			var len:int = vecs4Objects.length;
			ar[nxtId+0] = len;
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				nxtId = saveVecOfObject2Ar(vecs4Objects[i], ar, nxtId);
			}
			return nxtId;			
		}
		
		protected function saveParamsControllers2Ar(ar:Array, nxtId:int):int 
		{
			var len:int = paramsControllers.length;
			ar[nxtId+0] = len;
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				nxtId = paramsControllers[i].save2Ar(ar, nxtId);
			}
			return nxtId;
		}
		
		protected function loadOwnParamsFromOb(ob:Object):Object{
			screenCenterXAtCreation = Routines.getObjectPropertyValue(ob, "screenCenterXAtCreation", screenCenterXAtCreation);
			screenCenterYAtCreation = Routines.getObjectPropertyValue(ob, "screenCenterYAtCreation", screenCenterYAtCreation);
			numRestarts = Routines.getObjectPropertyValue(ob, "numRestarts", numRestarts);
			prestige = Routines.getObjectPropertyValue(ob, "prestige", prestige);
			money = Routines.getObjectPropertyValue(ob, "money", money);
			maxShownRect.left = Routines.getObjectPropertyValue(ob, "maxShownRect_left", maxShownRect.left);
			maxShownRect.top = Routines.getObjectPropertyValue(ob, "maxShownRect_top", maxShownRect.top);
			maxShownRect.right = Routines.getObjectPropertyValue(ob, "maxShownRect_right", maxShownRect.right);
			maxShownRect.bottom = Routines.getObjectPropertyValue(ob, "maxShownRect_bottom", maxShownRect.bottom);
			return ob;
		}
		
		protected function saveOwnParams2Ob(ob:Object):Object{
			ob["screenCenterXAtCreation"] = screenCenterXAtCreation;
			ob["screenCenterYAtCreation"] = screenCenterYAtCreation;
			ob["numRestarts"] = numRestarts;
			ob["prestige"] = prestige;
			ob["money"] = money;
			ob["maxShownRect_left"] = maxShownRect.left;
			ob["maxShownRect_top"] = maxShownRect.top;
			ob["maxShownRect_right"] = maxShownRect.right;
			ob["maxShownRect_bottom"] = maxShownRect.bottom;
			
			return ob;
		}
		protected function saveOwnParams2Ar(ar:Array, nxtId:int):int
		{
			ar[nxtId + 0] = screenCenterXAtCreation;
			ar[nxtId + 1] = screenCenterYAtCreation;
			ar[nxtId + 2] = numRestarts;
			ar[nxtId + 3] = prestige;
			ar[nxtId + 4] = money;
			ar[nxtId + 5] = maxShownRect.left;
			ar[nxtId + 6] = maxShownRect.top;
			ar[nxtId + 7] = maxShownRect.right;
			ar[nxtId + 8] = maxShownRect.bottom;			
			ar[nxtId + 9] = 0	//забили нулями только в 1.0.10	
			nxtId = nxtId + 10;
			return nxtId;
		}

		private function saveVecOfObject2Ar(vec:Vector.<gameplay.basics.BasicGameObject>, ar:Array, nxtId:int):int 
		{
			var len:int = vec.length;
			ar[nxtId + 0] = len;
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				nxtId = vec[i].save2Ar(ar, nxtId);
			}
			return nxtId;
		}		
		
		public function emergencyStopLoading(bkpAr:Array = null):void 
		{
			//когда при загрузке какого-то объекта происходит ошибка
			//попав сюда, loadController.isLoading уже убран
			
			//тут можно попытаться восстановиться из бекапа
			
			var resAr:Array = [];
			var ansAr:Array = [];
			if (bkpAr!=null){
				resAr = [{func:startLoadingFromBackup}]
				ansAr = ["TXID_ANS_TRYBACKUP"]
			}
			resAr.push({func:sendLoadedArReportFromController})
			ansAr.push("TXID_SENDREPORT")
			
			showMessage(
				"TXID_SOMETHINGWRONG",
				"TXID_MSG_SORRYSAVE TXID_MSG_WRONGSAVEOPTIONS",
				ansAr, resAr
			)
		}
		
		
		private function startLoadingFromBackup():void 
		{
			loadController.initializeLoadingFromBackup();
		}

				
		public function startLoadingFromOb(ob:Object):Object{
			playStatus = 0;
			PlayersAccount.account.currentlyLoadedIntSaveVersion = ob["saveIntVersion"];
			//ob["saveIntVersion"] //will be used to check variants
			//ob["getTime"] = (new Date()).getTime();
			//ob["worldTypeId"] = this.worldTypeId;
			//ob["gameId"] = Main.self.config.gameId;
			loadOwnParamsFromOb(ob);
			//loadParamsControllers2Ob(ob);
			//loadVectorsOfObjects2Ob(ob);	
			if (ob.hasOwnProperty("paramsControllers")){
				this.loadParamsControllersFromAr(ob["paramsControllers"], 0);	
			}
			//ob["vectorsObs"] - отсюда выкачиваем лоад контроллером
			return ob;
		}
				
		public function startLoadingFromAr(ar:Array, nxtId:int):int 
		{
			playStatus = 0;
			PlayersAccount.account.currentlyLoadedIntSaveVersion = ar[nxtId + 0];
			//ar[nxtId + 1] - дата сохранения
			//ar[nxtId + 2] - this.worldTypeId;
			//ar[nxtId + 3] - Main.self.config.gameId;			
			nxtId += 10;
			nxtId = this.loadOwnParamsFromAr(ar, nxtId);
			nxtId = this.loadParamsControllersFromAr(ar, nxtId);	
			
			return nxtId;
		}
		
		//при добавлении новых paramsControllers в массив они в первый раз вычитывать сейв просто не будут
		protected function loadParamsControllersFromAr(ar:Array, nxtId:int):int 
		{
			var len:int = ar[nxtId + 0];
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				nxtId = paramsControllers[i].loadFromAr(ar, nxtId);
			}
			return nxtId;
		}
		
		protected function loadOwnParamsFromAr(ar:Array, nxtId:int):int
		{
			screenCenterXAtCreation = ar[nxtId + 0]
			screenCenterYAtCreation = ar[nxtId + 1]
			numRestarts             = ar[nxtId + 2]
			prestige                = ar[nxtId + 3]
			money                   = ar[nxtId + 4]
			maxShownRect.left = ar[nxtId + 5]
			maxShownRect.top = ar[nxtId + 6]
			maxShownRect.right = ar[nxtId + 7]
			maxShownRect.bottom	 = ar[nxtId + 8]		
			nxtId = nxtId + 10;
			return nxtId;
		}
		
		public function afterLoadFunction():void{
			for (var i:int = 0; i < vecs4Objects.length; i++){
				var vec:Vector.<BasicGameObject> = vecs4Objects[i];
				for (var j:int = 0; j < vec.length; j++){
					vec[j].afterLoadProcessing();
				}
			}
			for (i = 0; i < vecs4Objects.length; i++){
				vec = vecs4Objects[i];
				for (j = 0; j < vec.length; j++){
					vec[j].secondAfterLoadProcessing();
					vec[j].changeGraphicsFromAfterLoadParams();
				}
			}
			//чтобы зоть какой-то стейт был после загрузки, а не null
			startState(NormalState, {});
		}
		
		public function getIndexOfClass(cls:Class):int 
		{
			return ballanser.entitiesClasses.indexOf(cls);
		}
		
		public function makeAMoveOnFrame():void 
		{
			if (isHilbernated){return; }
			
			if (loadController.isLoading){
				makeLoadingFrameStep();
			}else{
				if (playStatus == 1){
					makeNormalFrameStep();
				}
				
			}			
		}
		
		private function makeLoadingFrameStep():void 
		{
			loadController.doLoadingStep();
		}
		
		protected function makeNormalFrameStep():void 
		{
			timeController.actualizeTime();
			if (timeController.getRealWorldTime() - lastActualizaionTime >= 1){
				this.doSomethingEverySecond();
				lastActualizaionTime = timeController.getRealWorldTime();
			}
			//trace(timeController.getRealWorldTime(), timeController.getCurrentModelledWorldTime(), timeController.getCorrespondingIngameTime())		
			this.hud.doAnimStep(timeController.outerWorldDt);
			tutController.doAnimStep(timeController.outerWorldDt);
			effectsController.doStep(timeController.correspondingIngameDt);
			if (currentState){
				currentState.doAnimStep(timeController.outerWorldDt);
			}
			/*
			//в потомках, если нужны распределённые вычисления, надо будет вызывать
			if (spreadedCalculationsManager.hasSomething2Do()){
				spreadedCalculationsManager.doCalculationsOnFrame();
			}
			*/
		}
		
		protected function doSomethingEverySecond():void 
		{
			this.triggerController.checkTriggers();
			this.giftsController.checkGifts();
		}
	
		public function buildLayers4Object(ob:BasicGameObject):Array 
		{
			var res:Array = [];
			for (var i:int = 0; i < ob.layersIds.length; i++ ){
				res.push(visualization.layersAr[ob.layersIds[i]]);
			}
			//выдаётся набор слоёв, на которые распределяются слои объекта, в зависимости от его класса и текущего мира
			return res;
		}
		
		protected function findVecWhereClassIsStored(cl:Class):Vector.<BasicGameObject> 
		{
			return vecs4Objects[findVecIdWhereClassIsStored(cl)];
		}
		
		protected function findVecIdWhereClassIsStored(cl:Class):int
		{
			//in descendants must be not -1
			return -1;
		}	
		
		public function countObjectsOfClass(cl:Class, canBDescendant:Boolean = false):int{
			var res:int = 0;
			var vec:Vector.<BasicGameObject> = findVecWhereClassIsStored(cl);
			for (var i:int = 0;  i < vec.length; i++ ){
				var ob:BasicGameObject = vec[i];
				if (ob.myClass == cl){
					res++;
				}else{
					if (canBDescendant){
						if (ob is cl){
							res++
						}
					}
				}
			}
			return res;
		}
		
		public function findAllObjectsOfClass(cl:Class, vec:Vector.<BasicGameObject>, canBDescendant:Boolean = false, props:Object=null):Vector.<BasicGameObject>{
			if (!vec){
				vec = new Vector.<gameplay.basics.BasicGameObject>();
			}
			vec.length = 0;//если использовали ранее созданный вектор
			
			var id:int =-1;
			var need1More:Boolean = true;
			while (need1More){
				need1More = false;
				var res:BasicGameObject = findObjectOfClass(cl, id, canBDescendant, props);
				if (res){
					vec.push(res);
					id = res.arId;
					need1More = true;
				}
			}
			return vec;
		}
		
		public function findObjectOfClass(cl:Class, lookAfterArId:int =-1, canBDescendant:Boolean = false, props:Object=null):BasicGameObject{
			var res:BasicGameObject = null;
			var vec:Vector.<BasicGameObject> = findVecWhereClassIsStored(cl);
			for (var i:int = lookAfterArId + 1;  i < vec.length; i++ ){
				var ob:BasicGameObject = vec[i];
				if (!ob.isQueued4Removeal){
					if (ob.myClass == cl){
						if (props){
							if (ob.hasSpecificProperties(props)){
								res = ob;
								break;							
							}						
						}else{
							res = ob;
							break;
						}
					}else{
						if (canBDescendant){
							if (ob is cl){
								if (props){
									if (ob.hasSpecificProperties(props)){
										res = ob;
										break;							
									}								
								}else{
									res = ob;
									break;								
								}
							}
						}
					}					
				}

			}
			return res;
		}
		
		public function getObjectOfBaseClassAndId(cls:Class, id:int):BasicGameObject 
		{
			var vecId:int = findVecIdWhereClassIsStored(cls);
			return getObjectOfIdFromVectorId(id, vecId);
		}
		
		public function getObjectOfIdFromVectorId(id:int, vecId:int):BasicGameObject
		{
			return vecs4Objects[vecId][id];
		}
		
		public function loadObjectFromSave(ar:Array, nxtId:int, mustHaveArId:int, mustBeInVecId:int):int 
		{
			var objCodeId:int = ar[nxtId + 0];
			var cl:Class = ballanser.entitiesClasses[objCodeId];
			//trace("loadObjectFromSave", objCodeId,cl, nxtId )
			var vecId:int = findVecIdWhereClassIsStored(cl);//must be == mustBeInVecId==ar[nxtId + 2]
			var vec2StoreObject:Vector.<BasicGameObject> = findVecWhereClassIsStored(cl); //vec2StoreObject.length==mustHaveArId==ar[nxtId + 1];
			
			var res:BasicGameObject = new cl();
			res.myClass = cl;
			res.functionFromConstructor();
			res.registerMyWorld(this);	
			
			nxtId = res.loadPropertiesFromAr(ar, nxtId);
			
			var objRecord:Object = ballanser.entities[objCodeId];
			//{	cls:Forest,	name:"TXID_NAME_FOREST", desc:"TXID_DESC_FOREST",	layers:[0]	
			res.copyWorldPropertiesFromRecord(objRecord)
			res.initVisuals();//при оверлоаде тут внутри будет initMouseController
			res.distribute2Layers(this.buildLayers4Object(res));
			
			res.initSpecialCallBacksFromWorld();
			vec2StoreObject.push(res);
			
			return nxtId;
		}
		
		public function createObjectOfClass(cl:Class, props:Array, canBRolledBack:Boolean = false):BasicGameObject{
			var objCodeId:int = ballanser.entitiesClasses.indexOf(cl);
			if (objCodeId ==-1){
				trace('WARNING: class ', cl, ' not found in the array allClasses');
			}
			var vecId:int = findVecIdWhereClassIsStored(cl);
			var vec2StoreObject:Vector.<BasicGameObject> = findVecWhereClassIsStored(cl);
			
			var res:BasicGameObject = new cl();
			res.myClass = cl;
			res.functionFromConstructor();
			res.registerMyWorld(this);
			res.arId = vec2StoreObject.length;
			res.vecId = vecId;
			
			res.initProperties(props);
			res.afterInitProcessing();//тут выполняем что-то, что надо выполнить, когда вся инициализация пройдёт: и класса и потомка
			//это аналог afterLoadProcessing
			//но не совсем. Он выполняется до инициализации графики, а afterLoadProcessing - после.
			//поэтому если что-то делать в afterLoadProcessing, оно не повлияет на графику (например, создание кнопки апгрейда)
			//так что в secondAfterLoadProcessing вызываем changeGraphicsFromAfterLoadParams
			var objRecord:Object = ballanser.entities[objCodeId];
			//{	cls:Forest,	name:"TXID_NAME_FOREST", desc:"TXID_DESC_FOREST",	layers:[0]	
			res.copyWorldPropertiesFromRecord(objRecord)
			res.initVisuals();//при оверлоаде тут внутри будет initMouseController
			res.distribute2Layers(this.buildLayers4Object(res));
			
			res.canBRolledBack = canBRolledBack;
			
			res.setCreatedAndCurrentMoment(this.timeController.getCorrespondingIngameTime());	
			res.setCreatedAndCurrentRealTimeMoment(this.timeController.getRealWorldTime());			
			
			res.initSpecialCallBacksFromWorld();
			
			vec2StoreObject.push(res);
			
			if (!canBRolledBack){
				res.onCreated();//тут могут быть создания связанных объектов
			}
			
			return res;
		}
		
		public function react2StartTimeSpeeding(speedingTimeStart:Number):void 
		{
			
		}
		
		public function showSpeedingCompleteMessageIfNeeded(speedingDuration:Number):void 
		{
			
		}
		
		public function giveOtherOfflineReward(offlineDuration:Number):void
		{
			
		}
		
		public function getMasterTimeCoef(timeDuration:Number):Number{
			return 1;
		}

		
		public function isSpeedingTime():Boolean
		{
			return timeController.isSpeedingTime();
		}
		
		public function getMasterTapCoef():Number 
		{
			return 1;
		}
		
		public function getMasterProdCoef():Number 
		{
			return 1;
		}
				
		public function countOwnedArtifacts():int 
		{
			return artifactsController.countOwnedArtifacts();
		}
		
		public function countArtifactsOfCode(code:String):int 
		{
			return artifactsController.countArtifactsOfCode(code);
		}
		
		public function receiveResource(code:String, val:Number):void 
		{
			if (code == 'money'){
				this.money += val;
			}
		}
		public function getResourceVal(code:String):Number 
		{
			if (code == 'money'){
				return this.money;
			}else{
				return 0;
			}
			
		}

		public function showEffect(wx:Number, wy:Number, cls:Class, propsOb:Object, onScreenNotWorld:Boolean=false):void{
			effectsController.showEffect(wx, wy, cls, propsOb, onScreenNotWorld);
		}
		
		public function getObjectCreationCallback(myClass:Class):Function 
		{
			return callBacksOnCreation[myClass];
		}
		
		public function getObjectSycleCompletionCallback(myClass:Class):Function 
		{
			return callBacksOnCycleCompletion[myClass];
		}
		
		public function showColoredMessage(cap:String, colorsOb:Object, ansAr:Array, eftsAr:Array, iconsAr:Array, propsOb:Object):void 
		{
			NewGameScreen.screen.hud.showColoredMessage(cap, colorsOb, ansAr, eftsAr, iconsAr, propsOb)
		}	
		
		public function showMessage(cap:String, txt:String, ansAr:Array, eftsAr:Array=null, iconsAr:Array = null, propsOb:Object=null ):void{
			NewGameScreen.screen.hud.showMessage(cap, txt, ansAr, eftsAr, iconsAr, propsOb)
		}		
		
		public function showSpreadedCalculationsEnd():void 
		{
			hud.showSpreadedCalculationsEnd()
		}
		public function showSpreadedCalculationsStart():void 
		{
			hud.showSpreadedCalculationsStart()
		}
		public function showSpreadedCalculationsProgress(numDone:int, numTotal:int):void 
		{
			hud.showSpreadedCalculationsProgress(numDone,numTotal)
		}	
		
		public function continueAfterSpreadedCalculation():void 
		{
			
		}		
		public function canLaunchRewardedNow(timeBetweenCalls:Number=3*60):Boolean 
		{
			var res:Boolean = false;
			if (this.timeController.getRealWorldTime() - lastAdsCallTime >= timeBetweenCalls){
				return EnhanceWrapper.isRewardedAdReady();
			}
			return res;
		}		
		public function canLaunchInterstitialNow(firstCallAfterStart:Number=3*60, timeBetweenCalls:Number=2*60):Boolean 
		{
			var res:Boolean = false;
			if (getTimer()*0.001>=firstCallAfterStart){
				if (this.timeController.getRealWorldTime() - lastAdsCallTime >= timeBetweenCalls){
					return EnhanceWrapper.isInterstitialReady();
				}				
			}

			return res;
		}
		
		public function showInterstitialIfCan(firstCallAfterStart:Number=3*60, timeBetweenCalls:Number=2*60):void{
			if(canLaunchInterstitialNow(firstCallAfterStart,timeBetweenCalls)){
				showInterstitial();
			}
		}
		
		public function canSkipCurrentRewardedAd():Boolean{
			return NewGameScreen.screen.currenciesController.countCurrencyOfCode("currency_ads_skips") > 0;
			//if (NewGameScreen.screen.purchaseController.hasPurchase
			//return false;
		}
		
		//в IdleWorld сделано нормально через numPurchasesController 
		public function calcPurchasePrice4Code(code:String):Number 
		{
			var basePrice:Number = purchaser.getPurchasePrice4PurchaseCode(code);
			var coef:Number = purchaser.getPurchaseCoef4PurchaseCode(code);
			var nextNumberOfPurchase:int = purchaser.getNextNumberOfPurchase4PurchaseCode(code);
			
			
			return basePrice*Math.pow(coef, nextNumberOfPurchase);
		}
		
		public function react2LoadingFinished():void 
		{
			this.createBGDs();
			this.createTriggers();
			visualization.setMaxVievedZoneFromRect(this.maxShownRect);
			visualization.setNewCoordsAndScale(visualization.x, visualization.y, visualization.scale);
			PlayersAccount.account.setParamOfName("loadingAttempt_W_"+this.worldTypeId.toString(), "-1");
			hud.showAll();
			playStatus = 1;
			
			if (loadController.hasBackup()){
				showMessage(
					"TXID_MSG_LOADING_COMPLETE",
					"TXID_MSG_ISLOADOK TXID_MSG_YOUCANREVERT2BACKUP",
					["TXID_MSGANS_OK", "TXID_MSGANS_ROLLBACK"], [null, {func:startLoadingFromBackup}]
				)				
			}
		}
		
		public function canBSaved():Boolean
		{
			var res:Boolean = ((!loadController.isLoading) && (!timeController.isSpeedingTime()) && (playStatus == 1));
			if (this.currentState){
				res &&= currentState.canBAutoSaved;
			}
			return res;
		}
		
		public function getDiscoveryPercentage():Number 
		{
			return 0;
		}
		
		public function performCheatOfId(id:int):void 
		{
			
		}
		
		public function showRestartRequest():void 
		{
			doRestart()
		}
		
		public function hasEnoughResources2BuyArtifact(aft:gameplay.worlds.service.ArtifactObject):Boolean
		{
			var res:Boolean = false;
			if (aft.alternativeCurrency){
				var mon:Number = this.getResourceVal(aft.alternativeCurrency);
				res = mon >= aft.alternativeCurrencyPrice;
			}
			return res;
		}
		
				
		public function startState(stateClass:Class, propsOb:Object):void 
		{
			if (this.currentState){
				this.currentState.finalize();
			}
			this.currentState = new stateClass(this);
			this.currentState.initProps(propsOb);
		}
		
		public function handleKeyboardEent(e:flash.events.KeyboardEvent):Boolean 
		{		
			if (this.currentState){
				return this.currentState.handleKeyboardEent(e);
			}else{
				return false;
			}
		}
		
		public function handleMouseWheel(e:flash.events.MouseEvent):Boolean 
		{
			if (this.currentState){
				return this.currentState.handleMouseWheel(e);
			}else{
				return false;
			}			
		}
		
		public function getMyName():String{
			var ob:Object = NewGameScreen.screen.worldsController.getObOfId(worldTypeId);
			if (ob){
				return ob.name;
			}else{
				return '';
			}
		}
		public function getMyDescription():String{
			var ob:Object = NewGameScreen.screen.worldsController.getObOfId(worldTypeId);
			if (ob){
				return ob.desc;
			}else{
				return '';
			}
		}
		public function getMyDiscordIcon():String{
			var ob:Object = NewGameScreen.screen.worldsController.getObOfId(worldTypeId);
			if (ob){
				return ob.discordIcon;
			}else{
				return '';
			}
		}
		public function react2ImmediateArtifactPurchase(aft:gameplay.worlds.service.ArtifactObject):void
		{
			
		}

		//-1 - impossible, 0 - possible but not now, 1 - possible now at no cost, 2 - possible now at a cost
		public function canUnlockAnotherWorld(worldId:int):int 
		{
			return -1;
		}
		
		public function buildStringConfirmation2UnlockAnotherWorld(worldId:int):String{
			return "";
		}
		
		public function performUnlockOfAnotherWorld(worldId:int):void{
			NewGameScreen.screen.worldsSaveData.setWorldUnlockedInRecords(worldId);
		}	
		
		public function try2LoadFromString(str:String, format:String):int 
		{
			var errCode:int = 1;
			switch (format){
				case "oldPackedHex":{
					if (!Routines.doesStringHaveSomethingExcept(str, "0123456789abcdefgABCDEFGHIJKLMNOPQRSTUVWXYZ")){
						var str3:String = Routines.unpackHexString(str);
						if (!Routines.doesStringHaveSomethingExcept(str3, "0123456789abcdef")){
							var bar2:ByteArray = new ByteArray();
							Routines.decodeHex2ByteArray(str3, bar2);
							var ar2:Array = [];
							Routines.readArrayFromByteArray(ar2, bar2)
						}
					}
					break;
				}
				case "base64packed":{
					bar2 = new ByteArray();
					Routines.decodeBase642ByteArray(str, bar2);
					try {
						bar2.uncompress();
					}catch(e:Error){
						return 1;
					}
					ar2 = [];
					Routines.readArrayFromByteArray(ar2, bar2)
					break;
				}
				case "json":{
					try {
						var ob2:Object = JSON.parse(str);
					}catch(e:Error){
						return 1;
					}
					break;
				}
			}
			
			if (ar2){
				if (ar2.length > 0){
					var res:int = this.canLoadGameFromAr(ar2);
					if (res==1){
						var bkpAr:Array = [];
						this.save2Ar(bkpAr, 0);
						this.loadGameFromSpecificAr(ar2, bkpAr);		
						errCode = 0;
					}
				}				
			}else{
				if (ob2){
					res = this.canLoadGameFromOb(ob2);
					if (res==1){
						bkpAr = [];
						this.save2Ar(bkpAr, 0);
						this.loadGameFromSpecificOb(ob2, bkpAr);						
						errCode = 0;
					}
				}
			}
			return errCode;
		}
		
		public function handleExit2MainMenu():void 
		{
			this.playStatus =-1;
			this.hud.hideAll();
			this.spreadedCalculationsManager.stopAllCalculations();
		}


	}
}