package globals 
{
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.junkbyte.console.Cc;

	import flash.display.BitmapData;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;

	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.system.System;
	import flash.utils.ByteArray;
	import gui.buttons.BasicButton;
	import gui.pages.CreditsPage;
	import gui.pages.KeyboardPanel;
	import managers.MultiplatformManager;
	import managers.WorldsController;
	import models.UploadPostHelper;
	import starling.core.Starling;
	/**
	 * ...
	 * @author ...
	 */
	public class MenuCommandsPerformer 
	{
		static public var self:MenuCommandsPerformer;
		public function MenuCommandsPerformer() 
		{
			self = this;
		}
		
		public function openLinkByCode(cd:String):void 
		{
			var codes:Array = ["privacy", "contact", "moreGames", "rateGame", "discordcodes", "discord", "reddit"];
			var links:Array = [
				"http://www.airapport.com/p/privacy-policy.html",
				"http://www.airapport.com/p/contact.html",
				Main.self.multiplatformManager.buildMoreGamesLink(),
				Main.self.multiplatformManager.buildRateGameLink(), 
				"https://discord.gg/MeQ2J6R",
				"https://discord.gg/qpDbwpF5un",
				"https://www.reddit.com/r/Airapport/"
			]
			
			var id:int = codes.indexOf(cd);
			if (id!=-1){
				openLink(links[id])
			}
			
			StatsWrapper.stats.logTextWithParams("OpenLink", cd);
		}
		
		public function showCreditsMessage():void 
		{
			NewGameScreen.screen.hud.showPageOfClass(CreditsPage);
		}

		public function sendEmailWithCaptionAndText(cap:String, txt:String):void {
			openLink(
				"mailto:general@cardswars.com?subject=" + Translator.translator.getLocalizedVersionOfText(cap)+"&body="+Translator.translator.getLocalizedVersionOfText(txt)
			)
		}		
		public function openLink(str:String):void 
		{
			var request:URLRequest = new URLRequest( str );
			navigateToURL( request, "_blank" );
		}
		
		public function logSaves2Console():void 
		{
			Cc.log("Save data")
			Cc.log("Global")
			Cc.log(PlayersAccount.account.getGlobalDataAr());
			if (NewGameScreen.screen.currentWorld){
				Cc.log("World")
				Cc.log(PlayersAccount.account.newSavedGame.getBigSaveArOfId(NewGameScreen.screen.currentWorld.worldTypeId - 1));
			}
		}
		
		public function copyConsole2Clipboard():void 
		{
			System.setClipboard(Cc.getAllLog());
		}
		

		public function sendScore2Discord(gameMode:String, scoreText:String):void 
		{
			var url:String = "https://discord.com/api/webhooks/";
			
			
			var req:URLRequest = new URLRequest(url);
			req.method = URLRequestMethod.POST;
		//	req.requestHeaders = [new URLRequestHeader('Content-type', 'application/json')];
			var data:URLVariables = new URLVariables();
			data.username = PlayersAccount.account.playerName4Score//"<@!USER_ID>"//"test1";
			data.content = Translator.translator.getLocalizedVersionOfText("**TXID_SCORE**: " +scoreText+" TXID_SCORE_FLOORS - TXID_CONTESTMODE " + gameMode,"en");
			req.data = data;
			
			sendToURL(req);
			
		//	var ldr:URLLoader = new URLLoader(req);
		//	ldr.load(req);
			//navigateToURL(req);
		}
		
		public function sendVote2Discord(questionId:int, question:String, variantId:int, variantsTotal:int, variantName:String):void{	
			var url:String = "https://discord.com/api/webhooks/";
			var req:URLRequest = new URLRequest(url);
			req.method = URLRequestMethod.POST;
			
			var data:URLVariables = new URLVariables();
			data.username = "Poll "+questionId.toString()+" vote"//"<@!USER_ID>"//"test1";
			data.content = Translator.translator.getLocalizedVersionOfText(question)+" - "+"Vote "+variantId.toString()+'/'+variantsTotal.toString()+": "+Translator.translator.getLocalizedVersionOfText(variantName);
			req.data = data;
			
			sendToURL(req);
		}
		public function shareGame2Twitter():void{
			var m_url:String = Main.self.multiplatformManager.buildCurrentGameLink()//ссылка на твою игру
			var m_title:String = Translator.translator.getLocalizedVersionOfText("TXID_IMPLAYINGGAME")+" "+NewGameScreen.screen.worldsController.globalGameName+" by @Airapport " +Translator.translator.getLocalizedVersionOfText("TXID_AREYOUWITHME")//сопроводительный текст
			
			var url:String = encodeURI( m_url );
			var title:String = escape( m_title );
			
			var request:URLRequest = new URLRequest( "https://twitter.com/intent/tweet?text=" + url + " " + title );
			navigateToURL( request, "_blank" );			
		}
		
		public function shareGame2Facebook():void{
			var m_url:String = Main.self.multiplatformManager.buildCurrentGameLink()//ссылка на твою игру
			var m_title:String = Translator.translator.getLocalizedVersionOfText("TXID_IMPLAYINGGAME")+" "+NewGameScreen.screen.worldsController.globalGameName+" by @Airapport "+Translator.translator.getLocalizedVersionOfText("TXID_AREYOUWITHME")//сопроводительный текст
			
			var url:String = encodeURI( m_url );
			var title:String = escape( m_title );
			
			var request:URLRequest = new URLRequest( "http://facebook.com/sharer.php?u=" + url + "&quote=" + title );
			navigateToURL( request, "_blank" );				

		}
		
		public function sendScreenshot2Discord():void{
			var bmd:BitmapData = new BitmapData(Starling.current.viewPort.width, Starling.current.viewPort.height);
			Starling.current.stage.drawToBitmapData(bmd);
			var ba:ByteArray  = PNGEncoder.encode(bmd);

			var loader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest();	
			var variables:URLVariables = new URLVariables();

			urlRequest.url = "https://discord.com/api/webhooks/";
			urlRequest.contentType = "multipart/form-data; boundary=" + UploadPostHelper.getBoundary();
			urlRequest.method = URLRequestMethod.POST;
			var postVariables:Object = {}
			
			var worldName:String = "";
			if (NewGameScreen.screen.currentWorld){
				worldName = " / " + Translator.translator.getLocalizedVersionOfText(NewGameScreen.screen.currentWorld.getMyName(), "en");
			}
			
			postVariables.payload_json = com.adobe.serialization.json.JSON.encode({"content":NewGameScreen.screen.worldsController.globalGameName+worldName,"username":PlayersAccount.account.playerName4Score})
			//, "embeds":[{"title":NewGameScreen.screen.worldsController.globalGameName+worldName}]
			urlRequest.data = UploadPostHelper.getPostData("screenshot.png", ba, postVariables);
			urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onLoaderResponse);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError1);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderError2);
			try{
				loader.load(urlRequest);
			}
			catch (e:Error){
				trace("Screenshot share Error")
				NewGameScreen.screen.hud.showMessage("TXID_SOMETHINGWRONG", "TXID_TRYAGAIN", ["TXID_MSGANS_OK"]);
			}
		}
		
		private function onLoaderError2(e:SecurityErrorEvent):void 
		{
			NewGameScreen.screen.hud.showMessage("TXID_SOMETHINGWRONG", "TXID_TRYAGAIN", ["TXID_MSGANS_OK"]);
		}
		
		private function onLoaderError1(e:IOErrorEvent):void 
		{
			NewGameScreen.screen.hud.showMessage("TXID_SOMETHINGWRONG", "TXID_TRYAGAIN", ["TXID_MSGANS_OK"]);
		}
		
		private function onLoaderResponse(e:HTTPStatusEvent):void 
		{
			if ((e.status>=200)&&(e.status<=299)){
				NewGameScreen.screen.hud.showMessage("TXID_MSGCAP_SCREENSHOTOK", "TXID_MSG_TEXTAFTERSCREENSHOTOK\nTXID_MSG_SCREENSHOTSUBMITTEDFROM "+PlayersAccount.account.playerName4Score, ["TXID_MSGANS_OK", "TXID_MSGANS_COMMUNITY", "TXID_MSGANS_CHANGEUSERNAME"], [null, {func:openDiscordScreens}, {func:changeUserName}]);
			}else{
				NewGameScreen.screen.hud.showMessage("TXID_SOMETHINGWRONG", "TXID_TRYAGAIN", ["TXID_MSGANS_OK"]);
			}
			//
		}
		
		private function openDiscordScreens():void 
		{
			openLink("https://discord.gg/qpDbwpF5un")
		}
		
		private function changeUserName():void 
		{
			NewGameScreen.screen.hud.showPageOfClass(KeyboardPanel,{caption:"TXID_CAP_SELECTPLAYERNAME", text:PlayersAccount.account.playerName4Score, onComplete:this.onPlayerNameSelectComplete, maxStringLength:20})
		}
		
		private function onPlayerNameSelectComplete(txt:String):void 
		{
			if (txt){
				if (txt.length > 0){
					PlayersAccount.account.playerName4Score = txt;
					PlayersAccount.account.setParamOfName("playerName4Score", txt);
					NewGameScreen.screen.hud.showMessage("TXID_MSGCAP_PLAYERNAMECHANGED", "TXID_MSG_PLAYERNAME: "+PlayersAccount.account.playerName4Score, ["TXID_MSGANS_OK"]);				
				}				
			}			

		}
	}
}