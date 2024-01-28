package gui.pages 
{
	import globals.PlayersAccount;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.text.MultilangTextField;
	import gui.text.ShadowedTextField;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class WorldOnMapInformer extends Sprite
	{
		public var worldId:int;
		
		private var glowIm:Image;
		private var shadeIm:Image;
		private var iconIm:Image;
		private var lockIm:Image;
		private var nameCap:ShadowedTextField;
		private var descCap:ShadowedTextField;
		private var startBtn:BitBtn;
		private var unlockBtn:BitBtn;
		
		private var myMap:MapPage;
		public function WorldOnMapInformer(wid:int, map:MapPage) 
		{
			super();
			worldId = wid;
			myMap = map;
			var ob:Object = NewGameScreen.screen.worldsController.getObOfId(worldId);
			
			shadeIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this);
			glowIm=Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this);
			
			shadeIm.color = 0x93541E
			iconIm = Routines.buildImageFromTexture(Assets.manager.getTexture(ob.frame), this);
			lockIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_WORDLOCK"], this);
			
			glowIm.width = iconIm.width + 4;
			glowIm.height = iconIm.height + 4;		
			
			shadeIm.width = iconIm.width + 4;
			shadeIm.height = iconIm.height + 4;
			shadeIm.x = iconIm.x + 2;
			shadeIm.y = iconIm.y + 2;
			
			nameCap = new ShadowedTextField(ob.name, 0, -120, 450, 1, 1, 0xffffff,0x93541E, 'center', 'scale', true, true);
			//descCap = new ShadowedTextField(ob.desc, 0, 150, 450, 3, 1, 0xffffff,0x93541E, 'center', 'scale', true, true);
			addChild(nameCap);
			//addChild(descCap);
			
			startBtn = Routines.buildBitBtn("TXID_CAP_START", -1, this, onStartClick, 0, 150);
			unlockBtn = Routines.buildBitBtn("TXID_CAP_UNLOCK", -1, this, onUnlockClick, 0, 150);
			
		}
		
		private function onStartClick(b:BasicButton):void 
		{
			trace("Start");
			this.myMap.hide();
			if (this.myMap.callerWorld){
				NewGameScreen.screen.onSaveTimer(null);
				if (this.myMap.callerWorld.worldTypeId==this.worldId){
					return;
				}
			}
				
			var worldOb:Object = NewGameScreen.screen.worldsController.getObOfId(this.worldId);
			var skid:int = PlayersAccount.account.getIntParamOfName("worldskin_"+this.worldId.toString(), worldOb.defaultSkinId)
			NewGameScreen.screen.startPlayingWorld(worldOb, skid);//clearCurrentWorld будет внутри				
			
		}
		private function onUnlockClick(b:BasicButton):void 
		{
			trace("Unlock");
			if (this.myMap.callerWorld){
				var unlockPossibility:int = this.myMap.callerWorld.canUnlockAnotherWorld(this.worldId);
				switch (unlockPossibility){
					case 0:{//not enough resources
						NewGameScreen.screen.hud.showMessage("TXID_MSGCAP_TOWERLOCKED", this.myMap.callerWorld.buildStringConfirmation2UnlockAnotherWorld(this.worldId), ["TXID_MSGANS_OK"]);
						break;
					}
					case 1:{//can unlock without any payments
						this.myMap.callerWorld.performUnlockOfAnotherWorld(this.worldId);
						NewGameScreen.screen.hud.showMessage("TXID_MSGCAP_UNLOCKOK", "TXID_MSG_CANPLAYWORLD", ["TXID_MSGANS_OK"]);
						updateView();
						break;
					}
					case 2:{//can pay and unlock. Must ask 4 confirmation
						NewGameScreen.screen.hud.showMessage("TXID_MSGCAP_UNLOCKCONFIRM", this.myMap.callerWorld.buildStringConfirmation2UnlockAnotherWorld(this.worldId)+"\nTXID_MSG_DOYOUREALLYWANTUNLOCK", ["TXID_CAP_UNLOCK","TXID_MSGANS_CANCEL"],[{func:onUnlockConfirmed},null]);
						break;
					}
				}				
			}

		}
		
		private function onUnlockConfirmed():void 
		{
			if (this.myMap.callerWorld){
				this.myMap.callerWorld.performUnlockOfAnotherWorld(this.worldId);
				updateView();
			}
		}
		
		public function updateView():void{
			unlockBtn.visible = false;
			startBtn.visible = true;
			if (NewGameScreen.screen.isWorldUnlocked(this.worldId)){
				lockIm.visible = false;
				startBtn.setCaption("TXID_CAP_START")
				if (this.myMap.callerWorld){
					if (this.myMap.callerWorld.worldTypeId == this.worldId){
						startBtn.setCaption("TXID_CAP_YOUAREHERE")
					}
				}
			}else{
				lockIm.visible = true;
				unlockBtn.visible = true;
				startBtn.visible = false;

				unlockBtn.setCaption("TXID_CAP_LOCKED")
				unlockBtn.setViewMode("blocked")
				
				if (this.myMap.callerWorld){
					var unlockPossibility:int = this.myMap.callerWorld.canUnlockAnotherWorld(this.worldId);
					if (unlockPossibility!=-1){
						unlockBtn.setViewMode("standard")
						if (unlockPossibility >=1){
							unlockBtn.setCaption("TXID_CAP_UNLOCK")
						}
					}
				}
			}
		}
		
	}

}