package gui.pages 
{

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import gameplay.worlds.World;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.pages.UpdatedInterfacePage;
	import gui.text.MultilangTextField;
	/**
	 * ...
	 * @author ...
	 */
	public class BabelGiftsPanel extends UpdatedInterfacePage
	{
		private var bgd:gui.elements.NinePartsBgd;
		private var myWorld:World
		private var cap:gui.text.MultilangTextField;
		private var closeBtn:gui.buttons.SmallButton;
		private var bonusInfoCap:gui.text.MultilangTextField;
		private var getBtn:gui.buttons.BitBtn;
		private var weekBtn:BitBtn;
		public function BabelGiftsPanel() 
		{
			super();
			bgd = new NinePartsBgd();
			addChild(bgd);
			bgd.alpha = 0.8;

			closeBtn = new SmallButton(0);
			closeBtn.setIconByCode("close")
			closeBtn.registerOnUpFunction(this.closeBtnHandler);
			addChild(closeBtn);
			closeBtn.x = Main.self.sizeManager.fitterWidth*0.5-70
			closeBtn.y = 0
			
			this.cap = new MultilangTextField("TXID_CAP_DAILYBONUS", 0, 40, sizeWidth-20, 1, 1, 0xffffff, "center", "scale", true, true);
			addChild(cap);
			this.bonusInfoCap = new MultilangTextField('', 0, 150, sizeWidth - 20, -1, 1, 0xffffff, 'center');
			addChild(bonusInfoCap);
			this.getBtn = new BitBtn();
			
			addChild(getBtn);
			getBtn.setIconTextMode("text");
			getBtn.setCaption("TXID_ANS_GET");
			getBtn.y = bonusInfoCap.y+50;
			getBtn.registerOnUpFunction(onGetBtnClick)	
			
			weekBtn = Routines.buildBitBtn("TXID_CAP_WEEKLYBONUS", -1, this, onWeekBtnClick, 0, getBtn.y + 100);
			weekBtn.setBaseWidth(500);
		}
		
		private function onWeekBtnClick(b:BasicButton):void {
			NewGameScreen.screen.hud.showPageOfClass(CodeEnterPage, {world:this.myWorld}, 1);
		}
		private function onGetBtnClick(b:BasicButton):void 
		{
			myWorld.giftsController.usePreparedGift();
		}
		private function closeBtnHandler(b:BasicButton):void 
		{
			this.hide();
		}
		override public function updateView():void 
		{
			super.updateView();
			if (this.myWorld.giftsController.preparedRewardOb){
				this.bonusInfoCap.showText(this.myWorld.buildRewardInfo(this.myWorld.giftsController.preparedRewardOb))
				this.getBtn.visible = true;
			}else{
				this.bonusInfoCap.showText("TXID_CAP_NEXTBONUSIN: "+Routines.convertSeconds2SmallTimeString(this.myWorld.giftsController.timeOfNextGift-this.myWorld.timeController.getRealWorldTime()))
				this.getBtn.visible = false;
			}
			
			bgd.setDims(sizeWidth, this.weekBtn.y+50);
		}
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 120+Main.self.sizeManager.topMenuDelta;			
			bgd.setDims(sizeWidth, Main.self.sizeManager.gameHeight - 50);
		}
		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			myWorld = paramsOb.world;
			
		}	
		override public function handleKeyboardEvent(e:KeyboardEvent):Boolean 
		{
			if (!this.visible){return false}
			var b:Boolean = super.handleKeyboardEvent(e);
			if (!b){
				if (e.keyCode==Keyboard.BACK){
					if (closeBtn.visible){
						this.hide(true);
						b = true;
					}
				}
				if (e.keyCode==flash.ui.Keyboard.ESCAPE){
					if (closeBtn.visible){
						this.hide(true);
						b = true;
					}
				}				
			}
			return b;			
		}		
	}

}