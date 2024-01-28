package globals 
{
	import com.junkbyte.console.Cc;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author General
	 */
	
	public class StatsWrapper //подключение гугл аналитики
	{
		static public var stats:StatsWrapper;
		
		private var guid:String;

		private var tracker:GATracker;
		private var playtTM0:int;
		private var deactivateTm0:int;
		private var deactivatedTime:int;
		
		public var loggingLevel:int = 0;
		public function StatsWrapper()
		{
			stats = this;
			loggingLevel = Main.self.config.loggingLevel;
		}	
		
		public function init():void {
			guid = PlayersAccount.account.playerNewUID + '_V_' + Main.self.config.gameVersion;
			
			tracker = null;
			//isNewScreen)
			//tracker = new GATracker(Main.self.stage, Main.self.config.GACode);
			
			if (PlayersAccount.account.hasJustCreatedNewUid){
				//первый вход
				logText("FirstOpen", 3);
			}else{
				logText("OpenedGame", 3);
			}
		}
		
		public function react2Deactivation():void {
			deactivateTm0 = getTimer();
		}
		
		public function react2Activation():void {
			if (deactivateTm0!=0){
				deactivatedTime = getTimer() - deactivateTm0;
				
				if (deactivatedTime > 60000){
					logTextWithParams("ActivationAfterOfflineTimeInMinutes",int(deactivatedTime/60000).toString(),2);
				}				
			}

		}
		
		public function sendPlayingPing(worldTypeId:int, iterationNumber:int, monLog:Number, emergLvl:int=0):void 
		{
			if (loggingLevel <= emergLvl){
				//tracker.trackEvent(guid, "/Playing_World_" + worldTypeId.toString() + '_Iteration_' + iterationNumber.toString() + '/', monLog.toFixed(0));
			}
		}
		
		public function logTextWithParams(msg:String, param:String, emergLvl:int=0):void 
		{
			if (loggingLevel <= emergLvl){
				//tracker.trackEvent(guid, '/' + msg + '/', param);
				trace('logTextWithParams',msg, param)			
			}

		}
		
		public function logText(msg:String, emergLvl:int=0):void 
		{
			if (loggingLevel <= emergLvl){
				//tracker.trackEvent(guid, '/' + msg + '/', Main.self.config.gameVersion);
			}
			
		}
		
		//какие события надо логировать?
		/*
		 * +1. первый запуск игры+
		 * какой игры? 
		 * на какой платформе? 
		 * iOS, GooglePlay, Amazon, Web, PC
		 * +2. пребывание в игре+
		 * сам факт
		 * длительность
		 * длительность сессий
		 * версия игры
		 * +3. успешность прохождения мира. 
		 * Можно отправлять логарифм текущих денег
		 * +4. показы рекламы
		 * отправлять событие появления диалога выбора: реклама-не реклама, чтобы знать, с какой вероятностью выбирают рекламу
		 * +5. клик по "другим играм"
		 * +6. клики по всем социальным кнопкм
		 * ?7. детальную статистику отправлять только в 1ю итерацию мира
		 * */
		
	}

}