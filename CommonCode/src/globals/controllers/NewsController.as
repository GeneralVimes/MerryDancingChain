package globals.controllers 
{
	import com.junkbyte.console.Cc;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import globals.controllers.PlayersDataController;
	/**
	 * ...
	 * @author ...
	 */
	public class NewsController extends PlayersDataController
	{
		public var lastNewsUIDRead:int = -1;
		public var currentlyShownNewsId:int = 0;
		private var newsObjsAr:Array = [];
		private var newsObjsAr2Show:Array = [];
		
		private var ldr:URLLoader;
		private var fallBackJSON:Object
		private var workJSON:Object = {};
		private var loadingPhase:String = 'notStarted';//'started','endedWithError','endedWithSuccess'
		
		private var newsOb:Object;
		public var totalNews:int = 0;
		
		public function NewsController() 
		{
			
		}
		
		public function getNextNews():Object{
			currentlyShownNewsId = (currentlyShownNewsId + 1) % totalNews;

			return getCurrentNewsObject()
		}
		
		public function getPrevNews():Object{
			currentlyShownNewsId = (currentlyShownNewsId + totalNews - 1) % totalNews;
			
			return getCurrentNewsObject()
		}
		
		public function getCurrentNewsObject():Object{
			//if (currentlyShownNewsId>=nextNewsId2Read){
				//nextNewsId2Read = currentlyShownNewsId+1
			//}	
			var ob:Object = newsObjsAr2Show[currentlyShownNewsId];
			if (ob){
				if (ob.intuid>lastNewsUIDRead){
					lastNewsUIDRead = ob.intuid;
				}					
			}

			return ob;
		}
		
		public function loadNews():void 
		{
			//trace('NewsReader loadNews')
			try{
				loadingPhase = 'started';
				var request:URLRequest = new URLRequest("https://generalvimes.github.io/newgamesnews.json");
				ldr = new URLLoader();
				ldr.dataFormat = URLLoaderDataFormat.TEXT;
				ldr.addEventListener(Event.COMPLETE, onNewsLoaded);
				ldr.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
				ldr.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpResponseStatus);
				ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
				ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderSecurityError);
				
				ldr.load(request);
			}catch (e:Error){
				Cc.log('ERROR');
				Cc.log(e.name);
				Cc.log(e.errorID );
				Cc.log(e.getStackTrace());
				Cc.log(e.message);
				loadingPhase = 'endedWithError';
				initFallBack();
			}			
		}
		
		private function onLoaderIOError(e:IOErrorEvent):void 
		{
				Cc.log('IOErrorEvent');
				
				Cc.log(e.errorID );
				Cc.log(e.text);

				Cc.log(e.toString());	
				loadingPhase = 'endedWithError';
				initFallBack();
		}
		
		private function onHttpResponseStatus(e:HTTPStatusEvent):void 
		{
			Cc.log('HTTPStatusEvent');
			Cc.log(e.toString());
			if (e.status != 200){
				loadingPhase = 'endedWithError';
				initFallBack();
			}
		}
		
		private function onHttpStatus(e:HTTPStatusEvent):void 
		{
			Cc.log('onHttpStatus');
			Cc.log(e.toString());
			if (e.status != 200){
				loadingPhase = 'endedWithError';
				initFallBack();
			}			
		}
		
		private function onLoaderSecurityError(e:SecurityErrorEvent):void 
		{
				Cc.log('SecurityErrorEvent');
				
				Cc.log(e.errorID );
				Cc.log(e.text);
				
				Cc.log(e.toString());
				loadingPhase = 'endedWithError';
				initFallBack();
		}
		
		private function onNewsLoaded(e:Event):void 
		{
			//loaded будет даже если будет страница 404.
			//пожтом надо проверять httpStatus, чтобы status был 200
			var str:String = ldr.data;

			if (loadingPhase == 'started'){
				loadingPhase = 'endedWithSuccess';
				workJSON = JSON.parse(str);
				initNewsAr();
			}
		}
		
		private function initFallBack():void{
			loadingPhase = 'endedWithSuccess'
			fallBackJSON = {
					"news":[
						{
							"games":["11"],
							"excludedgames":[""],
							"uid":"perpetuum",
							"caption":{
								"en":"Great video review!",
								"ru":"Отличный видеообзор!"
							},
							"message":{
								"en":"Great youtuber Perpetuumworld hasAttribute reviewed the game on his channel",
								"ru":"Змечательный ютубер Perpetuumworld сделал обзор игры на своём канале"
							},
							"answers":[
								{
									"text":{"en":"Watch","ru":"Смотреть"},
									"link": "https://www.youtube.com/watch?v=hXoxH6766lY"
								}
							],
							"isObsolete":"false",
							"startDate":"20-Aug-2020"
						},
						{
							"games":["all"],
							"uid":"discord",
							"caption":{
								"en":"Players Community",
								"ru":"Сообщество игроков"
							},
							"message":{
								"en":"You are welcome to join the players' community in Discord",
								"ru":"Присоединяйтесь к сообществу игроков в Дискорде"
							},
							"answers":[
								{
									"text":{"en":"Join", "ru":"Присоединиться", "uk":"Приєднатися"},
									"link": "https://discord.gg/EJ8hPpm"
								}
							],
							"isObsolete":"false",
							"startDate":"16-Jun-2020"
						},
						{
							"games":["all"],
							"uid":"modeIdles",
							"caption":{
								"en":"More Idle Games!",
								"ru":"Больше айдлов!"
							},
							"message":{
								"en":"Would you like to check more idle games by Airapport?",
								"ru":"Хотите посмотреть другие наши айдл игры?"
							},
							"answers":[
								{
									"text":{"en":"App Store"},
									"link": "https://apps.apple.com/us/developer/alexey-izvalov/id1437172357",
									"platforms":["all"],
									"excludedplatforms":["Google"]
								},
								
								{
									"text":{"en":"Google Play"},
									"link":	"https://play.google.com/store/apps/dev?id=6075165531768716801",
									"platforms":["all"],
									"excludedplatforms":["Apple"]									
								}
							],
							"isObsolete":"false",
							"startDate":"16-Jun-2020"
						},
						{
							"games":["11"],
							"excludedgames":[""],
							"uid":"vlad",
							"caption":{
								"en":"New video review by Vlad!",
								"ru":"Новый видеообзор от Влада!"
							},
							"message":{
								"en":"Many thanks to VLAD for the great review of the game!",
								"ru":"Большое спасибо VLAD'у за отличный обзор игры!"
							},
							"answers":[
								{
									"text":{"en":"Watch","ru":"Смотреть"},
									"link": "https://www.youtube.com/watch?v=cIPjLqgFwiw"
								}
							],
							"isObsolete":"false",
							"startDate":"20-Aug-2020"
						},
						{
							"games":["11"],
							"excludedgames":[""],
							"uid":"107",
							"caption":{
								"en":"Content update 1.0.7!",
								"ru":"Большое обновление 1.0.7!"
							},
							"message":{
								"en":"Many new game objects fills game with the content up to floor 16 now. Mine moonstone and build a tower which doubles your bricks. Produce gunpowder and shoot the bricks to the upper floors of the tower. Fountain waters the grass and helps produce more food for the Elephant. Bungee jumper automatically collects the money from the windows and increases its value. Also many balanse tweaks were made. We suggest you to restart the building, gain your Golden Bricks bonus and experience the newest machines",
								"ru":"Много новых игровых объектов - теперь в игре контента вплоть до 16 этажа. Добывайте лунный камень и постройте башню, которая удваивает ваши кирпичи. Добывайте порох и стреляйте кирпичами на верхние этажи башни. Фонтан поливает траву и помогает добывать больше еды для слона. Прыгун на резинке автоматически собирает деньги из окон и увеличивает их стоимость. Также было сделано много настроек баланса. Мы предлагаем вам перезапустить здание, получить бонус Золотые кирпичи и испытать новейшие машины."
							},
							"answers":[
							],
							"isObsolete":"false",
							"startDate":"20-Aug-2020"
						}
							
					]
				}
				workJSON = fallBackJSON;
				initNewsAr()
		}
		
		private function initNewsAr():void 
		{
			newsObjsAr = workJSON["news"] as Array;
			newsObjsAr2Show.length = 0;
			//totalNews = 0;
			for (var i:int = 0; i < newsObjsAr.length; i++ ){
				var ob:Object = newsObjsAr[i];
				if (isNewsValid(ob)){
					cutAnswersFromAnotherPlatforms(ob);
					newsObjsAr2Show.push(ob);
				}
				if (!ob.hasOwnProperty("intuid")){
					ob.intuid = i;
				}
			}
			totalNews = newsObjsAr2Show.length;
			
			//вот тут мы должны найти, intuid какой новости больше, чем nextNewsId2Read
			//currentlyShownNewsId = nextNewsId2Read;
			currentlyShownNewsId = newsObjsAr2Show.length - 1;
			for (i = 0; i < newsObjsAr2Show.length; i++ ){
				ob = newsObjsAr2Show[i];
				if (ob.intuid > lastNewsUIDRead){
					currentlyShownNewsId = i;
					break;
				}
			}
			
			if (currentlyShownNewsId >= totalNews){
				currentlyShownNewsId = totalNews - 1;
			}
		}
		
		private function cutAnswersFromAnotherPlatforms(ob:Object):void 
		{
			if (ob.hasOwnProperty("answers")){
				var ansAr:Array = ob.answers;
				for (var i:int = ansAr.length - 1; i >= 0; i-- ){
					var ansOb:Object = ansAr[i];
					var canShowAnswer:Boolean = true;
					if (ansOb.hasOwnProperty("platforms")){
						if ((ansOb.platforms.indexOf("all") !=-1) || (ansOb.platforms.indexOf(Main.self.config.platform) !=-1)){
							canShowAnswer = true;
							if (ansOb.hasOwnProperty("excludedplatforms")){
								if (ansOb.excludedplatforms.indexOf(Main.self.config.platform) !=-1){
									canShowAnswer = false;
								}
							}
						}else{
							canShowAnswer = false;
						}
					}
					if (!canShowAnswer){
						ansAr.splice(i, 1);
					}
				}
			}

		}
		
		private function isNewsValid(ob:Object):Boolean 
		{
			var res:Boolean = true;
			if (ob.hasOwnProperty("isObsolete")){
				if ((ob.isObsolete==true) ||(ob.isObsolete=="true")){
					res = false;
					return res;
				}				
			}
			
			res = false;
			// console.log('checking games')
			if (ob.hasOwnProperty("games")){
				if (ob.games.indexOf("all") !=-1){
					res = true;
					if (ob.hasOwnProperty("excludedgames")){
						if(ob.excludedgames.indexOf(Main.self.config.gameId.toString())!=-1){
							res = false;
						}
					}
				}else{
					if(ob.games.indexOf(Main.self.config.gameId.toString())!=-1){
						res = true;
					}
				}
			}
			// console.log('Res must be true', res);
			//checking date
			//if (res){
			//	// console.log(ob.startDate, )
			//	if ("startDate" in ob){
			//		var dt0 = new Date(ob.startDate);
			//		if (Date.now()<dt0){
			//			res=false;
			//		}
			//	} 
			//	if ("endDate" in ob){
			//		var dt1 = new Date(ob.endDate);
			//		if (Date.now()+1000*3600*24>dt1){
			//			res=false;
			//		}
			//	} 
			//	
			//}		
			return res;
		}
		

		public function hasNewNews():Boolean{
			//return true;
			if (loadingPhase == 'endedWithSuccess'){
				if (newsObjsAr2Show.length > 0){
					return newsObjsAr2Show[newsObjsAr2Show.length - 1].intuid > lastNewsUIDRead;
				}else{
					return false;
				}
			}else{
				return false;
			}
		}
		
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			ar[nxtId + 0] = lastNewsUIDRead;
			ar[nxtId+1] = 0;
			ar[nxtId+2] = 0;
			ar[nxtId+3] = 0;
			ar[nxtId+4] = 0;			
			return nxtId+5;
		}
		
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			lastNewsUIDRead = ar[nxtId + 0];
			return nxtId+5;
		}
	}

}