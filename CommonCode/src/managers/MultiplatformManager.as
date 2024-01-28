package managers 
{
	
	/**
	 * ...
	 * @author General
	 */
	public class MultiplatformManager 
	{
		
		//platform: 
		/*
		 * android: 
		 * 	Google Play
		 * 	Amazon
		 * ios
		 * pc
		 * 	itch
		 * 	steam
		 * web
		 * 	kongregate
		 * 	newgrounds
		 * */
		//public var currentGameLink:String = 'https://play.google.com/store/apps/details?id=air.com.airapport.engineer';
		//public var gameDevBlog:String = 'http://www.airapport.com/p/games-by-airapport.html';
		//public var moreGamesLink:String = '';
		//public var makeReviewLink:String = '';//currentGameLink
		//public var analyticsCode:String = '';
		//public var analyticsTag:String = '';
		//
		//public var newDefaultWold:int =-1;
		
		public var defaultLink:String = "http://www.airapport.com/p/games-by-airapport.html";
		
		private var devLinksOnPlatforms:Object = {
			Google:	'https://play.google.com/store/apps/dev?id=6075165531768716801',
			Apple:	'https://itunes.apple.com/developer/id1437172357',
			Amazon:	'https://www.amazon.com/s?rh=n%3A2350149011%2Cp_4%3AAirapport',
			Itch:	'https://airapport.itch.io/'
		}
		
		private var gamesLinks:Object
		
		public function MultiplatformManager() 
		{
		//	makeReviewLink = currentGameLink;
			gamesLinks = {
				games:[
					{
						code:5,
						name:"TXID_GAMEDESC_QUICKCIV",
						desc:"TXID_GAMENAME_QUICKCIV",
						iconCode: "wadd_WorldsIcons4new0016",
						defaultLink:"https://www.airapport.com/2021/10/conquicktory-our-minimalistic-turn.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=com.airapport.quickcivstrategy.conquicktory',
							Apple:	'https://apps.apple.com/us/app/conquicktory/id1588421923',
							Itch:	'https://airapport.itch.io/conquicktory',
							Steam:	'https://store.steampowered.com/app/1779510/Conquicktory/'
						}
					},
					{
						code:22,
						name:"TXID_GAMEDESC_EVOARENA",
						desc:"TXID_GAMENAME_EVOARENA",
						iconCode: "wadd_WorldsIcons4new0016",
						defaultLink:"https://www.airapport.com/2021/05/evolution-arena-sandbox-for-living-rock.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=com.airapport.evolution.arena.sandbox.rps',
							Apple:	'https://apps.apple.com/us/app/evolution-arena/id1567624919',
							Itch:	'https://airapport.itch.io/evolution-arena'
						}
					},
					{
						code:12,
						name:"TXID_GAMEDESC_FARMANDMINE",
						desc:"TXID_GAMENAME_FARMANDMINE",
						iconCode: "wadd_WorldsIcons4new0015",
						defaultLink:"https://airapport.itch.io/farm-and-mine",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=com.airapport.farm.mine.idle.ludumdare48',
							Apple:	'https://apps.apple.com/us/app/idle-tower-builder/id1527621990',
							Itch:	'https://airapport.itch.io/farm-and-mine'
						}
					},
					{
						code:11,
						name:"TXID_GAMEDESC_IDLETOWERBUILDER",
						desc:"TXID_GAMENAME_IDLETOWERBUILDER",
						iconCode: "wadd_WorldsIcons4new0011",
						defaultLink:"http://www.airapport.com/2020/08/idle-tower-builder-released-to-all.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=com.airapport.idletowerbuilder',
							Apple:	'https://apps.apple.com/us/app/idle-tower-builder/id1527621990',
							Amazon:	'https://www.amazon.com/Idle-Tower-Builder-construction-manager/dp/B08FVH9CMC',
							Itch:	'https://airapport.itch.io/idle-tower-builder'
						}
					},
					{
						code:4,
						name:"TXID_GAMEDESC_STEAMPUNK",
						desc:"TXID_GAMENAME_STEAMPUNK",
						iconCode: "wadd_WorldsIcons4new0000",
						defaultLink:"https://www.airapport.com/p/steam.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=air.com.airapport.steampunkidlespinner',
							Apple:	'https://itunes.apple.com/us/app/id1445575882',
							Amazon:	'https://www.amazon.com/gp/product/B07L9ZGCKJ',
							Itch:	'https://airapport.itch.io/steampunk-idle-spinner'
						}
					},
					{
						code:1,
						name:"TXID_GAMEDESC_ENGINEER",
						desc:"TXID_GAMENAME_ENGINEER",
						iconCode: "wadd_WorldsIcons4new0001",
						defaultLink:"https://www.airapport.com/p/engineer-millionaire-press-kit.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=air.com.airapport.engineer',
							Apple:	'https://itunes.apple.com/us/app/id1437172358',
							Amazon:	'https://www.amazon.com/gp/product/B07RSD7285',
							Itch:	'https://airapport.itch.io/engineer-millionaire'
						}
					},
					{
						code:2,
						name:"TXID_GAMEDESC_20KCOGS",
						desc:"TXID_GAMENAME_20KCOGS",
						iconCode: "wadd_WorldsIcons4new0002",
						defaultLink:"https://www.airapport.com/p/20-000-cogs-under-sea-press-kit.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=air.com.airapport.A20000.cogs.under.sea.nemo.steampunk',
							Apple:	'https://itunes.apple.com/us/app/id1441246412',
							Amazon:	'https://www.amazon.com/gp/product/B07K8ZVR6S',
							Itch:	'https://airapport.itch.io/20-000-cogs-under-the-sea'	
						}
					},
					{
						code:903,
						name:"TXID_GAMEDESC_TRANSMUTATION",
						desc:"TXID_GAMENAME_TRANSMUTATION",
						iconCode: "wadd_WorldsIcons4new0010",
						defaultLink:"http://www.airapport.com/2019/10/transmutation-game-is-released.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=air.com.airapport.transmutation',
							Apple:	'https://apps.apple.com/us/app/transmutation-lab/id1475150795',
							Amazon:	'https://www.amazon.com/Airapport-Transmutation/dp/B07YYJLT3F/',
							Itch:	'https://airapport.itch.io/transmutation'
						}
					},
					{
						code:900,
						name:"TXID_GAMEDESC_IDLEEATERS",
						desc:"TXID_GAMENAME_IDLEEATERS",
						iconCode: "wadd_WorldsIcons4new0005",
						defaultLink:"http://www.airapport.com/2019/04/big-update-of-idle-eaters-omnomnom.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=air.com.airapport.eatersidle',
							Apple:	'https://itunes.apple.com/us/app/id1451106793',
							Amazon:	'https://www.amazon.com/dp/B07QH36JKD'
						}
					},
					{
						code:901,
						name:"TXID_GAMEDESC_CHICKENFARM",
						desc:"TXID_GAMENAME_CHICKENFARM",
						iconCode: "wadd_WorldsIcons4new0006",
						defaultLink:"http://www.airapport.com/2019/04/easter-eggs-assembly-line-idle-tycoon.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=air.com.airapport.eggsfactoryidle',
							Apple:	'https://itunes.apple.com/us/app/id1458762302',
							Amazon:	'https://www.amazon.com/gp/product/B07QBDBKTS'
						}
					},
					{
						code:902,
						name:"TXID_GAMENAME_TVADS",
						desc:"TXID_GAMEDESC_TVADS",
						iconCode: "wadd_WorldsIcons4new0009",
						defaultLink:"http://www.airapport.com/2019/06/tv-ads-factory-coming-up-soon.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=air.com.airapport.adsfactory',
							Apple:	'https://apps.apple.com/us/app/ads-factory-tv-watch-tycoon/id1466624295',
							Amazon:	'https://www.amazon.com/Ads-Factory-Satirical-Tycoon-Clicker/dp/B07TW9PBNH/'
						}
					},				
					{
						code:904,
						name:"TXID_GAMENAME_BOTTLE",
						desc:"TXID_GAMEDESC_BOTTLE",
						iconCode: "wadd_WorldsIcons4new0012",
						defaultLink:"http://www.airapport.com/2019/07/bottle-cap-challenge-coming-soon-as.html",
						gameLinksOnPlatforms:{
							Google:	'https://play.google.com/store/apps/details?id=air.com.airapport.bottlecapchallenge',
							Apple:	'https://apps.apple.com/us/app/bottle-cap-challenge-2019/id1471320821',
							Amazon:	'https://www.amazon.com/dp/B07TTQ8L8C/'
						}
					}
				]
			}
		}
		
		public function buildLink4AnotherGameOnThisPlatform(gid:int):String {
			var res:String = defaultLink;
			var ar:Array = gamesLinks.games;
			for (var i:int = 0; i < ar.length; i++ ){
				var ob:Object = ar[i];
				if (ob.code == gid){
					var lnk:String = ob.defaultLink;
					if (lnk){
						res = lnk;
					}
					if (ob.gameLinksOnPlatforms.hasOwnProperty(Main.self.config.platform)){
						res = ob.gameLinksOnPlatforms[Main.self.config.platform]
					}					
					break;
				}
			}
			return res;
		}
		
		public function buildMoreGamesLink():String 
		{
			var res:String = defaultLink;
			if (devLinksOnPlatforms.hasOwnProperty(Main.self.config.platform)){
				res = devLinksOnPlatforms[Main.self.config.platform]
			}
			
			return res;
		}
		
		public function buildRateGameLink():String 
		{
			var res:String = buildLink4AnotherGameOnThisPlatform(Main.self.config.gameId)
			if (Main.self.config.platform=='Itch'){
				res += '/rate';
			}
			return res;
		}
		
		public function buildCurrentGameLink():String 
		{
			return buildLink4AnotherGameOnThisPlatform(Main.self.config.gameId);
		}
		
		//public function initParams(m:Main):void 
		//{
		//	newDefaultWold = m.newDefaultWoldAndGame;
		//	//Main.self.newDefaultWold
		//	//1 - фабрика, 2 - немо
		//	
		//	if (!m.isWebVersion){//андроид или иос
		//		
		//	}else{//веб или пк
		//		if (!m.isPCVersion){//веб
		//			
		//		}else{//пк
		//			
		//		}
		//	}
		//	//"https://play.google.com/store/apps/details?id=air.com.airapport.A20000.cogs.under.sea.nemo.steampunk"
		//		
		//	//currentGameLink = "https://itunes.apple.com/us/app/id1441246412";
		//	//makeReviewLink = "https://itunes.apple.com/us/app/id1441246412";
		//	//moreGamesLink = "https://itunes.apple.com/us/app/id1441246412";
		//	currentGameLink = getLink2Game(newDefaultWold, LocalParams.platform);
		//	makeReviewLink = currentGameLink;
		//	moreGamesLink = getLink2AllDevsGames(LocalParams.platform);
		//}
		//
		////gmId - это newDefaultWorldId
		//public function getLink2Game(gmId:int, platformName:String):String 
		//{
		//	var res:String = gameDevBlog;
		//	//GooglePlay, Amazon, iOS
		//	//web, PC - ?
		//	var mobPlatformNames:Array = ['GooglePlay', 'Amazon', 'iOS', 'Indus', 'Itch', 'Kongregate', 'Newgrounds'];
		//	
		//	var linksByPlatform:Array = [
		//	]
        //
		//	switch (gmId){

		//		case 900:{
		//			linksByPlatform = [
		//				'https://play.google.com/store/apps/details?id=air.com.airapport.eatersidle',
		//				'https://www.amazon.com/dp/B07QH36JKD',
		//				'https://itunes.apple.com/us/app/id1451106793',
		//				'',
		//				'',
		//				'https://www.kongregate.com/games/GeneralVimes/idle-eaters',
		//				''
		//			]					
		//			//trace('hello')
		//			break;
		//		}
		//		case 901:{
		//			linksByPlatform = [
		//				'https://play.google.com/store/apps/details?id=air.com.airapport.eggsfactoryidle',
		//				'https://www.amazon.com/gp/product/B07QBDBKTS',//'',
		//				'https://itunes.apple.com/us/app/id1458762302',
		//				'',
		//				'',
		//				'',
		//				''
		//			]					
		//			//trace('hello')
		//			break;
		//		}
		//		case 902:{
		//			linksByPlatform = [
		//				'https://play.google.com/store/apps/details?id=air.com.airapport.adsfactory',
		//				'https://www.amazon.com/Ads-Factory-Satirical-Tycoon-Clicker/dp/B07TW9PBNH/',//'',
		//				'https://apps.apple.com/us/app/ads-factory-tv-watch-tycoon/id1466624295',//'https://itunes.apple.com/us/app/id1466624295',
		//				'https://www.airapport.com/2019/06/tv-ads-factory-coming-up-soon.html',
		//				'https://www.airapport.com/2019/06/tv-ads-factory-coming-up-soon.html',
		//				'https://www.airapport.com/2019/06/tv-ads-factory-coming-up-soon.html',
		//				'https://www.airapport.com/2019/06/tv-ads-factory-coming-up-soon.html'
		//			]					
		//			//trace('hello')
		//			break;
		//		}

		//		case 904:{
		//			linksByPlatform = [
		//				'https://play.google.com/store/apps/details?id=air.com.airapport.bottlecapchallenge',
		//				'https://www.amazon.com/dp/B07TTQ8L8C/',
		//				'https://apps.apple.com/us/app/bottle-cap-challenge-2019/id1471320821',
		//				'http://www.airapport.com/2019/07/bottle-cap-challenge-coming-soon-as.html',
		//				'http://www.airapport.com/2019/07/bottle-cap-challenge-coming-soon-as.html',
		//				'http://www.airapport.com/2019/07/bottle-cap-challenge-coming-soon-as.html',
		//				'http://www.airapport.com/2019/07/bottle-cap-challenge-coming-soon-as.html' 
		//			]					
		//			//trace('hello')
		//			break;
		//		}				
		//	}
		//	
		//	
		//	
		//	//for (var i:int = 0; i < linksByPlatform.length; i++ ){
		//	//	if (linksByPlatform[i] == ''){
		//	//		linksByPlatform[i] = moreGamesLink;
		//	//	}
		//	//}
		//	
		//	var id:int = mobPlatformNames.indexOf(platformName);
		//	if (id !=-1){
		//		if (id < linksByPlatform.length){
		//			if ( linksByPlatform[id]!= ''){
		//				res = linksByPlatform[id];
		//			}
		//		}
		//	}
		//	return res;
		//}
		//
		//public function getLink2AllDevsGames(platformName:String):String 
		//{
		//	var res:String = gameDevBlog;
		//	//GooglePlay, Amazon, iOS
		//	//web, PC - ?
		//	var mobPlatformNames:Array = ['GooglePlay', 'Amazon', 'iOS', 'Indus', 'Itch', 'Kongregate', 'Newgrounds'];
		//	
		//	var linksByPlatform:Array = [
		//		'https://play.google.com/store/apps/dev?id=6075165531768716801',
		//		'https://www.amazon.com/s/ref=bl_dp_s_web_0?ie=UTF8&search-alias=aps&field-brandtextbin=Airapport&node=2350149011',
		//		'https://itunes.apple.com/developer/id1437172357',
		//		'',
		//		'https://airapport.itch.io/',
		//		'https://www.kongregate.com/accounts/GeneralVimes',
		//		'https://generalvimes.newgrounds.com/'
		//	]
        //
		//	var id:int = mobPlatformNames.indexOf(platformName);
		//	if (id !=-1){
		//		if (id < linksByPlatform.length){
		//			if ( linksByPlatform[id]!= ''){
		//				res = linksByPlatform[id];
		//			}
		//		}
		//	}
		//	return res;
		//}
        //
		//public function getFBCode4Game():String{
		//	var res:String = '';
		//	switch (Main.self.newDefaultWoldAndGame){
		//		case 1:{
		//			res = '291684928317806';
		//			break;
		//		}
		//		case 2:{
		//			res = '1011104645765468';
		//			break;
		//		}
		//		case 4:{
		//			res = '308455280108397';
		//			break;
		//		}
		//	}
		//	
		//	return res;
		//}
		//public function getGACode4Game():String{
		//	var res:String = 'UA-105878322-3' //это было в первом спиннере
		//	switch (Main.self.newDefaultWoldAndGame){
		//		case 1:{
		//			res = 'UA-120982752-3';
		//			break;
		//		}
		//		case 2:{
		//			res = 'UA-120982752-1';
		//			break;
		//		}
		//		case 4:{
		//			res = 'UA-120982752-4';
		//			break;
		//		}
		//		case 900:{
		//			res = 'UA-120982752-5';//для едоков
		//			break;
		//		}
		//		case 901:{
		//			res = 'UA-120982752-6';//для кур
		//			break;
		//		}
		//	}
		//	if (Main.self.isWebVersion){
		//		res='UA-139963733-1'//а это для ПК/веб
		//	}else{
		//		res = 'UA-137990422-1';//попробуем 1 код на все игры для мобильных
		//	}
		//	
		//	return res;
		//}
		//
		////reachable worlds          //
		////1	//1 - Assebly line      //in another app, load it from 
		////2	//2 - Underwater        //in another app, load it from 
		////4	//4 - Workshop          //restart the world and have xxx narr
		////4	//7 - Clockwork city    //locked, will be unlocked in the update after 4th Jan
		////4	//8 - Floating islands	//locked, needs 20000 narr or more to unlock
		//							//return to the world
			
		
	}
}