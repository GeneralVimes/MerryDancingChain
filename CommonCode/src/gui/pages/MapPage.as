package gui.pages 
{
	import gameplay.worlds.World;
	import gui.text.ShadowedTextField;
	import starling.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import globals.MenuCommandsPerformer;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class MapPage extends InterfacePage 
	{
		private var bgd:gui.elements.NinePartsBgd;
		private var cap:gui.text.MultilangTextField;
		private var bgIm:Image;
		private var bgW0:Number;
		private var bgH0:Number;
		private var closeBtn:gui.buttons.SmallButton;
		private var voteVars:Array;
		private var voteBtns:Vector.<BitBtn>;
		private var voteCap:ShadowedTextField;
		private var voteResCap:ShadowedTextField;
		private var voteDiscordBtn:BitBtn;
		
		private var hasAlreadyVoted:Boolean = false;
		private var worldsIcon:MovieClip;
		private var infs:Vector.<WorldOnMapInformer>;
		
		public var callerWorld:World;
		public function MapPage() 
		{
			super();
			bgd = new NinePartsBgd();
			addChild(bgd);
			bgd.alpha = 0.8;
			
			bgIm = Routines.buildImageFromTexture(Assets.allTextures["TEX_MAPBGD"], this, 0, 0, "center", "top");
			bgW0 = bgIm.width;
			bgH0 = bgIm.height;
			//bgIm.alpha = 0.7;		
			
			closeBtn = new SmallButton(0);
			closeBtn.setIconByCode("close")
			closeBtn.registerOnUpFunction(this.closeBtnHandler);
			addChild(closeBtn);
			closeBtn.x = Main.self.sizeManager.fitterWidth*0.5-70
			closeBtn.y = 0
			
			this.cap = new MultilangTextField("TXID_CAP_AVAILABLEWORLDS", 0, 50, Main.self.sizeManager.fitterWidth, 1, 1, 0xffffff, "center", "scale", true,true);	
			addChild(cap);
			
			infs = new Vector.<gui.pages.WorldOnMapInformer>();
			for (var i:int = 0; i < NewGameScreen.screen.worldsController.worldData.length; i++ ){
				var ob:Object =  NewGameScreen.screen.worldsController.worldData[i];
				var inf:WorldOnMapInformer = new WorldOnMapInformer(ob.id, this);
				infs.push(inf);
				addChild(inf);
			}
			
			voteCap = new ShadowedTextField("TXID_VOTETOWER", 0, 0, Main.self.sizeManager.gameWidth - 20, -1, 1, 0xffffff,0x000000, 'center', 'normal',true, true);
			addChild(voteCap);
			voteVars = [
				"TXID_CAP_OPTION_EIFFEL"	,
				"TXID_CAP_OPTION_PISA"		,
				"TXID_CAP_OPTION_BURJ"		,
				"TXID_CAP_OPTION_PYRAMID"	,
				"TXID_CAP_OPTION_BEAN"		,
				"TXID_CAP_OPTION_ESB"		,
				"TXID_CAP_OPTION_BERLIN"	
			]
			
			voteBtns = new Vector.<gui.buttons.BitBtn>();
			for (i = 0; i < voteVars.length; i++ ){
				var btn:BitBtn = Routines.buildBitBtn(voteVars[i], -1, this, onVoteBtnClick);
				btn.numVal = i;
				btn.setBaseWidth(390);
				voteBtns.push(btn);
			}
			
			voteResCap = new ShadowedTextField("TXID_VOTERESULT TXID_DISCORDSUGGESTIONS", 0, 0, Main.self.sizeManager.gameWidth - 20, -1, 1,0xffffff,0x000000, "center", "normal",true, true);
			addChild(voteResCap);
			voteDiscordBtn = Routines.buildBitBtn("Discord", -1, this, onDiscordClick);
			
			bgd.setDims(this.sizeWidth, this.sizeWidth);
		}
		
		private function onDiscordClick(b:BasicButton):void 
		{
			MenuCommandsPerformer.self.openLink("https://discord.gg/XfnJnQF");
		}
		
		private function onVoteBtnClick(b:BasicButton):void 
		{
			//send Vote 2 Discord
			hasAlreadyVoted = true;
			alignOnScreen();
		}
		
		private function closeBtnHandler(b:BasicButton):void 
		{
			this.hide();
		}		
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 0;
			
			bgIm.x = 0;
			
			bgIm.scale = Math.min(Main.self.sizeManager.gameWidth / bgW0, Main.self.sizeManager.gameHeight / bgH0);
			
			if (Main.self.sizeManager.gameHeight > bgIm.height + 100){
				bgIm.y = 100;
				
			}else{
				bgIm.y = Main.self.sizeManager.gameHeight - bgIm.height;
			}
					
			
			closeBtn.x = Main.self.sizeManager.gameWidth / 2 - 40;
			closeBtn.y = 40+Main.self.sizeManager.topMenuDelta;
			
			
			var len:int = infs.length;
			for (var i:int = 0;  i < len; i++){
				var inf:WorldOnMapInformer = infs[i];
				inf.x = (0.5+i) * Main.self.sizeManager.gameWidth / len - Main.self.sizeManager.gameWidth / 2;
				inf.y = 250;
				inf.updateView()
			}
			
			
			voteCap.setMaxTextWidth(Main.self.sizeManager.gameWidth - 40);
			voteCap.x = 0;
			voteCap.y = Main.self.sizeManager.gameHeight / 2;
			voteCap.visible = !hasAlreadyVoted;
			var cy0:Number = voteCap.y + voteCap.getTextHeight() + 30;
			
			var numBtnsInLine:int = Math.floor((Main.self.sizeManager.gameWidth-40) / 400);
			var distBetweenBtns:Number = (Main.self.sizeManager.gameWidth - 40) / numBtnsInLine;
			
			for (i = 0; i < voteBtns.length; i++ ){
				var btn:BitBtn = voteBtns[i];
				var rowId:int = Math.floor(i / numBtnsInLine);
				var cy:Number = cy0 + 80 * rowId;
				var cx:Number = (i % numBtnsInLine + 0.5) * Main.self.sizeManager.gameWidth / numBtnsInLine - Main.self.sizeManager.gameWidth / 2;
				btn.x = cx;
				btn.y = cy;
				
				btn.visible = !hasAlreadyVoted;
			}
			
			
			var dy:Number = Main.self.sizeManager.gameHeight - 50 - cy;
			for (i = 0; i < voteBtns.length; i++ ){
				voteBtns[i].y += dy;
			}
			voteCap.y += dy;
			
			voteResCap.setMaxTextWidth(Main.self.sizeManager.gameWidth - 40);
			voteResCap.x = 0;
			voteResCap.y = voteCap.y;
			voteDiscordBtn.y = voteResCap.y + voteResCap.getTextHeight() + 30;
			
			voteResCap.visible = hasAlreadyVoted;
			voteDiscordBtn.visible = hasAlreadyVoted;
			
			bgd.setDims(Main.self.sizeManager.gameWidth, Main.self.sizeManager.gameHeight);
		}
		
		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			//myWorld = paramsOb.world;
			callerWorld = null;
			if (paramsOb.hasOwnProperty("world")){
				callerWorld = paramsOb.world;
			}
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
		
		override public function show(paramsOb:Object):void 
		{
			super.show(paramsOb);
			alignOnScreen();
		}
	}

}