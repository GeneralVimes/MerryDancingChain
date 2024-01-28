package gameplay.worlds.service 
{
	import gameplay.worlds.World;
	import gui.pages.BabelGiftsPanel;
	/**
	 * ...
	 * @author ...
	 */
	public class GiftsController extends SavedWorldParamsController
	{
		public var preparedRewardOb:Object = null;
		public var timeOfNextGift:Number = -1;
		public var currentGiftId:int = 0;
		
		private var wasAnnouncedAboutGift:Boolean = false;
		private var numSecondsWOAnnouncement:int = 0;
		
		public function GiftsController(w:World)  
		{
			super(w);
			
		}
				
		public function reset():void 
		{
			preparedRewardOb = null;
			timeOfNextGift =-1;
			currentGiftId = 0;
			wasAnnouncedAboutGift = false;
			numSecondsWOAnnouncement = 0;
		}
		
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			
			nxtId = super.save2Ar(ar, nxtId)
			ar[nxtId + 0] = timeOfNextGift;
			ar[nxtId + 1] = currentGiftId;
			ar[nxtId + 2] = 0;
			ar[nxtId + 3] = 0;
			ar[nxtId + 4] = 0;
			
			return nxtId + 5;
		}
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			timeOfNextGift = ar[nxtId + 0];
			currentGiftId = ar[nxtId + 1];
			return nxtId + 5;
		}
		
		public function checkGifts():void 
		{
			if (timeOfNextGift ==-1){
				timeOfNextGift = this.world.timeController.getRealWorldTime()+this.world.ballanser.getDeltaTillNextGift(currentGiftId)
			}
			if (!preparedRewardOb){
				if (this.world.timeController.getRealWorldTime() >= timeOfNextGift){
					preparedRewardOb = this.world.createNewReward4Myself(currentGiftId)
				}				
			}else{
				if (!wasAnnouncedAboutGift){
					if (!NewGameScreen.screen.hud.hasOpenMessage() && !NewGameScreen.screen.hud.hasOpenPage()){
						numSecondsWOAnnouncement++;
						if (numSecondsWOAnnouncement >= 10){
							wasAnnouncedAboutGift = true;
							NewGameScreen.screen.hud.showMessage('TXID_MSG_CAP_REWARD_READY','TXID_MSG_REWARD_READY',["TXID_ANS_GET"],[{func:this.openGiftPanel}])
						}
					}
				}
			}

		}
		
		private function openGiftPanel():void 
		{
			NewGameScreen.screen.hud.showPageOfClass(BabelGiftsPanel, {world:this.world});
		}
		
		public function usePreparedGift():void{
			world.giveReward(this.preparedRewardOb, true);
			preparedRewardOb = null;
			currentGiftId++;
			
			timeOfNextGift = this.world.timeController.getRealWorldTime()+this.world.ballanser.getDeltaTillNextGift(currentGiftId)
			
			wasAnnouncedAboutGift = false;
			numSecondsWOAnnouncement = 0;
		}

	}

}