package gui.pages 
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import gameplay.worlds.World;
	import globals.PlayersAccount;
	import globals.StatsWrapper;
	import globals.Translator;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	/**
	 * ...
	 * @author ...
	 */
	public class BackupsPage extends InterfacePage 
	{
		private var bgd:gui.elements.NinePartsBgd;
		private var closeBtn:SmallButton;
		private var bigCap:MultilangTextField;
		private var cap:MultilangTextField;
		
		private var slots:Vector.<SaveSlotInformer>;
		private var myWorld:World;
		
		private var exportBtn:BitBtn;
		private var importBtn:BitBtn;
		private var explCap:MultilangTextField;
		public function BackupsPage() 
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
			this.bigCap = new MultilangTextField("TXID_CAP_MAKEBACKUPS", 0, 20, sizeWidth - 40, 2, 1, 0xffffff, "center", "scale", true, true);
			addChild(bigCap);
			
			//this.cap = new MultilangTextField("TXID_CAP_MAKEBACKUPS", 0, 100, sizeWidth - 40, 2, 1, 0xffffff, "center", "scale", true, true);
			//addChild(cap);
			
			slots = new Vector.<gui.pages.SaveSlotInformer>();
			for (var i:int = 0; i < 5; i++ ){
				var ssb:SaveSlotInformer = new SaveSlotInformer(this, i);
				slots.push(ssb);
				
				ssb.y = 180 + 100 * i;
				ssb.x = -Main.self.sizeManager.fitterWidth * 0.5;
				
				addChild(ssb);
			}
			
			exportBtn = Routines.buildBitBtn("TXID_CAP_EXPORT", -1, this, onExportClick, 300, 700);
			importBtn = Routines.buildBitBtn("TXID_CAP_IMPORT", -1, this, onImportClick, -300, 700);
			explCap = new MultilangTextField("TXID_CAP_BACKUPSEXPLANATION", 0, 780, sizeWidth - 40, 3, 1, 0xffffff, "center", "scale", true, true);
			addChild(explCap);
			bgd.setDims(Main.self.sizeManager.fitterWidth, 950);
		}
		
		private function onImportClick(b:BasicButton):void 
		{
			if (Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)){
				var text:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String; 
				//проверку на чистый json надо делать с самого начала
				if ((text.charAt(0)=="{")&&(text.charAt(text.length-1)=="}")){
					format = "json";//и ничего не урезаем
					var str:String = text
				}else{
					var leftBracketId:int = text.indexOf("[");
					var rightBracketId:int = text.lastIndexOf("]");
					str = text.substr(leftBracketId + 1, rightBracketId - leftBracketId - 1);
					
					var format:String = "oldPackedHex";
					var id:int = str.indexOf("|");
					if (id!=-1){
						var formatMetaData:String = str.substr(0, id);
						if (formatMetaData=="A"){
							format = "base64packed"
						}
						if (formatMetaData=="B"){
							format = "json"
						}
						str = str.substr(id + 1);
					}					
				}
				

				
				var errCode:int = myWorld.try2LoadFromString(str, format);
				if (errCode!=0){
					NewGameScreen.screen.hud.showMessage("TXID_CAP_IMPORTINCORRECT", "TXID_MSG_NOTASAVETEXT", ["TXID_MSGANS_OK"]);
				}else{
					hide();
				}
			}else{
				NewGameScreen.screen.hud.showMessage("TXID_CAP_IMPORTNOTHING", "TXID_MSG_MUSTIMPORTFROMCLIPBOARD", ["TXID_MSGANS_OK"]);
			}			
		}
		
		private function onExportClick(b:BasicButton):void 
		{
			if (myWorld.canBSaved()){
				var ar:Array = [];
				myWorld.save2Ar(ar, 0);
				var bar:ByteArray = new ByteArray();
				Routines.writeArray2ByteArray(ar, bar);
				bar.compress();
				var str:String = Routines.encodeByteArray2Base64(bar);
				var str2:String = "[" +"A"+"|"	+str+"]";
				
				Clipboard.generalClipboard.clear();
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, str2);
				
				NewGameScreen.screen.hud.showMessage("TXID_CAP_EXPORTOK", "TXID_MSG_CLIPBOARD", ["TXID_MSGANS_OK"]);				
			}

			

		}
		
		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			myWorld = paramsOb.world;
		}
		
		override public function show(paramsOb:Object):void 
		{
			super.show(paramsOb);
			updateView();
		}
		
		private function updateView():void 
		{
			for (var i:int = 0; i < slots.length; i++ ){
				slots[i].init(this.myWorld.worldTypeId);
			}
		}
		private function closeBtnHandler(b:BasicButton):void 
		{
			this.hide();
		}	
		
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 120 + Main.self.sizeManager.topMenuDelta;
			
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
				if (e.keyCode==Keyboard.ESCAPE){
					if (closeBtn.visible){
						this.hide(true);
						b = true;
					}
				}				
			}
			return b;	
		}		
		
		public function saveWorld2Slot(slotId:int):void 
		{
			if (myWorld.canBSaved()){
				var ar:Array = [];
				myWorld.save2Ar(ar, 0);
				var str:String = PlayersAccount.account.getBkpSavePath4World(myWorld.worldTypeId, slotId);
				PlayersAccount.account.saveAr2File(ar, str);
				updateView();				
			}

		}
		
		public function loadWorldFromSlot(slotId:int):void {
			var str:String = PlayersAccount.account.getBkpSavePath4World(myWorld.worldTypeId, slotId);
			var ar:Array = PlayersAccount.account.loadArFromFile(str);
			if (ar){
				if (ar.length > 0){
					var res:int = myWorld.canLoadGameFromAr(ar);
					if (res == 1){
						var bkpAr:Array = [];
						myWorld.save2Ar(bkpAr, 0);
						//prepare2LoadNew ушло внутрь и вызывается контроллером загрузки
						myWorld.loadGameFromSpecificAr(ar, bkpAr);
						hide();							
					}
				}
			}else{
				
			}

		}
	}

}