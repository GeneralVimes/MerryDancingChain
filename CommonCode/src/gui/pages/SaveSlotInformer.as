package gui.pages 
{
	import gameplay.controllers.BitBtnsController;
	import globals.PlayersAccount;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.text.MultilangTextField;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SaveSlotInformer extends Sprite 
	{
		public var slotId:int;
		public var worldId:int;
		
		private var dataTx:MultilangTextField;
		private var saveBtn:BitBtn;
		private var loadBtn:BitBtn;
		
		private var myFileProps:Object = {};
		
		private var parPage:BackupsPage
		public function SaveSlotInformer(pg:BackupsPage, sid:int) 
		{
			super();
			parPage = pg;
			slotId = sid;
			
			
			var aw:Number = Main.self.sizeManager.fitterWidth;
			
			dataTx = new MultilangTextField("", aw/2, 0, aw - 400, 2, 1, 0xffffff, "center", "scale");
			addChild(dataTx);
			
			saveBtn = Routines.buildBitBtn("TXID_CAP_SAVE", -1, this, onSaveClick, 100, 0);
			loadBtn = Routines.buildBitBtn("TXID_CAP_LOAD", -1, this, onLoadClick, aw - 100, 0);
			saveBtn.setBaseWidth(200)
			loadBtn.setBaseWidth(200)
		}
		
		public function init(wid):void{
			worldId = wid;
			
			var bkpPath:String = PlayersAccount.account.getBkpSavePath4World(worldId, slotId);
			myFileProps = PlayersAccount.account.getFileProperties(bkpPath);
			if (myFileProps.exists){
				loadBtn.visible = true;
				dataTx.showText("[TXID_CAP_SAVE "+slotId.toString()+": "+myFileProps.modificationDate.toLocaleString()+" ]")
			}else{
				loadBtn.visible = false;
				dataTx.showText("<TXID_CAP_EMPTYSLOT "+(slotId+1).toString()+" >")
			}
		}
		
		private function onLoadClick(b:BasicButton):void 
		{
			var bkpPath:String = PlayersAccount.account.getBkpSavePath4World(worldId, slotId);
			myFileProps = PlayersAccount.account.getFileProperties(bkpPath);
			if (myFileProps.exists){
				parPage.loadWorldFromSlot(this.slotId);
			}
		}
		
		private function onSaveClick(b:BasicButton):void 
		{
			if (myFileProps.exists){
				//ask 4 confirmation
				NewGameScreen.screen.hud.showMessage(
					"TXID_MSG_SLOTTAKEN",
					"TXID_MSG_SLOTTAKENCONFIRM",
					["TXID_MSGANS_YES", "TXID_MSGANS_NO"],
					[{func:onRewriteConfirmed},null]
				)
			}else{
				parPage.saveWorld2Slot(this.slotId);
			}
		}
		
		private function onRewriteConfirmed():void 
		{
			parPage.saveWorld2Slot(this.slotId);
		}
		
	}

}