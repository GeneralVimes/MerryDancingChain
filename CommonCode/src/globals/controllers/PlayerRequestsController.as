package globals.controllers 
{
	import gameplay.visual.WorldHUD;
	import globals.MenuCommandsPerformer;
	import globals.PlayersAccount;
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerRequestsController extends PlayersDataController 
	{
		private var timeOfLastRateRequest:Number = 0;
		private var versionOfLastRateRequest:String = '';
		private var lastRateAnswer:int = 0;//0 - not asked, 1 - not liked, 2 - liked&rated, 3 liked&rated later
		public function PlayerRequestsController() 
		{
			
		}
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			ar[nxtId + 0] = lastRateAnswer;
			ar[nxtId + 1] = timeOfLastRateRequest;
			nxtId = Routines.saveString2Ar(ar, nxtId + 2, versionOfLastRateRequest);
			ar[nxtId + 0] = 0
			ar[nxtId + 1] = 0
			
			return nxtId+2
		}
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			lastRateAnswer = ar[nxtId + 0]
			timeOfLastRateRequest = ar[nxtId + 1]
			var strAr:Array = [''];
			nxtId = Routines.loadStringFromAr(ar, nxtId + 2, strAr);
			versionOfLastRateRequest = strAr[0];
			//= ar[nxtId + 0]
			//= ar[nxtId + 1] 			
			
			return nxtId+2
		}		
		
		public function decide2Ask2RateGame(realTime:Number, hud:WorldHUD):void 
		{
			var mustShowRequest:Boolean = false;
			switch (lastRateAnswer){
				case 0:{//не спрашивали - спрашиваем
					mustShowRequest = true;
					break;
				}
				case 1:{//not liked
					mustShowRequest = (realTime-timeOfLastRateRequest)>3600*24*7*4*6//спрашиваем через полгода
					break;
				}
				case 2:{//liked and rated
					mustShowRequest = (realTime-timeOfLastRateRequest) > 3600 * 24 * 7 * 4//спрашиваем через месяц
					mustShowRequest &&= Main.self.config.gameVersion != versionOfLastRateRequest;
					break;
				}
				case 3:{//liked, but said "later"
					mustShowRequest = (realTime-timeOfLastRateRequest)>3600*24*7//спрашиваем через неделю
					break;
				}
			}
			if (mustShowRequest){
				this.versionOfLastRateRequest = Main.self.config.gameVersion;
				this.timeOfLastRateRequest = realTime;
				hud.showNotificationButtonIfNonexistent('rate')
			}
		}
		
		public function showRateGameRequest():void 
		{
			NewGameScreen.screen.hud.showMessage("TXID_CAP_SMALLQUESTION", "TXID_CAP_DOYOULIKEGAME", ["TXID_MSGANS_YES", "TXID_MSGANS_NO"], [{func:this.onAnswerYes}, {func:this.onAnswerNo}], null, {statsCode:"doyoulikeme"});
		}
		
		private function onAnswerNo():void 
		{
			lastRateAnswer = 1;
			NewGameScreen.screen.hud.showMessage("TXID_CAP_SORRY", "TXID_CAP_TELLWHY", ["TXID_MSGANS_SEND", "TXID_MSGANS_LATER"], [{func:this.onAnswerTellWhyNotLike}, {func:this.onAnswerLaterTellWhyNotLike}], null, {statsCode:"whynotlike"});
		}
		
		private function onAnswerYes():void 
		{
			lastRateAnswer = 3;
			NewGameScreen.screen.hud.showMessage("TXID_CAP_THANKYOU", "TXID_CAP_RATEGAME", ["TXID_MSGANS_WRITE", "TXID_MSGANS_LATER"], [{func:this.onAnswerRate}, {func:this.onAnswerLaterRate}], null, {statsCode:"pleasereview"});
		}
		private function onAnswerTellWhyNotLike():void{
			MenuCommandsPerformer.self.sendEmailWithCaptionAndText("TXID_MSG_HOWTOIMPROVE gameId=" + Main.self.config.gameId.toString(), PlayersAccount.account.playerNewUID + 'TXID_MSG_EMAILBODY');
		}
		private function onAnswerLaterTellWhyNotLike():void{
			
		}
		private function onAnswerRate():void{
			lastRateAnswer = 2;
			MenuCommandsPerformer.self.openLinkByCode("rateGame");
		}
		private function onAnswerLaterRate():void{
			lastRateAnswer = 3;
		}
	}

}