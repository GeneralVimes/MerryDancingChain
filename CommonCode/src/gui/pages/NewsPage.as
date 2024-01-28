package gui.pages 
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import globals.MenuCommandsPerformer;
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
	public class NewsPage extends InterfacePage 
	{
		private var bgd:gui.elements.NinePartsBgd;
		private var closeBtn:gui.buttons.SmallButton;
		private var cap:gui.text.MultilangTextField;
		private var ansBtns:Vector.<gui.buttons.BitBtn>;
		private var ansActions:Array;
		private var nxtBtn:BitBtn;
		private var prevBtn:BitBtn;
		private var newsCap:gui.text.MultilangTextField;
		private var newsText:gui.text.MultilangTextField;
		private var shownNewsUID:String='';
		
		public function NewsPage() 
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
			
			this.cap = new MultilangTextField("TXID_CAP_NEWS", 0, 40, sizeWidth, 7, 1, 0xffffff, "center", "scale", true, true);
			addChild(cap);	
			
			this.newsCap = new MultilangTextField("",0,220,sizeWidth-20,-1,1,0xffffff,"center","normal",false)
			this.newsText = new MultilangTextField("",0,320,sizeWidth-20,-1,1,0xffffff,"center","normal",false)
			addChild(newsCap);
			addChild(newsText);
		
			this.nxtBtn = Routines.buildBitBtn('', 9, this, onNextClick, 200, 80);
			this.prevBtn = Routines.buildBitBtn('', 10, this, onPrevClick, -200, 80);
			nxtBtn.setIconTextMode("icon");
			nxtBtn.setBaseWidth(60);
			prevBtn.setIconTextMode("icon");
			prevBtn.setBaseWidth(60);
			
			this.ansBtns = new Vector.<BitBtn>();
			this.ansActions = [];	
		}
		
		private function onNextClick(b:BasicButton):void 
		{
			showNewsFromObject(NewGameScreen.screen.newsController.getNextNews())
		}	
		private function onPrevClick(b:BasicButton):void 
		{
			showNewsFromObject(NewGameScreen.screen.newsController.getPrevNews())
		}
		
		private function closeBtnHandler(b:BasicButton):void 
		{
			this.hide();
		}
		override public function show(paramsOb:Object):void 
		{
			super.show(paramsOb);
			showNewsFromObject(NewGameScreen.screen.newsController.getCurrentNewsObject())
		}
		
		private function showNewsFromObject(ob:Object):void 
		{
			if (ob){
				shownNewsUID = ob.uid;
				
				this.newsCap.showText(Translator.translator.selectPhraseOfLanguage(ob.caption));
				this.newsText.showText(Translator.translator.selectPhraseOfLanguage(ob.message));
				
				newsText.y = newsCap.y + newsCap.getTextHeight() + 30;
				
				var cy:Number = this.newsText.y+this.newsText.getTextHeight()+50
				
				this.ansActions = []
				for (var i:int=0; i<this.ansBtns.length; i++){
					this.ansBtns[i].visible = false;
				}			
				
				if (ob.hasOwnProperty("answers")){
					var ansAr:Array = ob.answers;
					
					var mxNumButtonsInLine:int = Math.floor(sizeWidth / 300);
					if (mxNumButtonsInLine==0){
						mxNumButtonsInLine = 1;
					}
					var mxNumLines:int = Math.ceil(ansAr.length / mxNumButtonsInLine);
					
					for (i=0; i<ansAr.length; i++){
						var ansOb:Object = ansAr[i];
						
						if (ansOb.hasOwnProperty("link")){
							this.ansActions.push({func:MenuCommandsPerformer.self.openLink, caller:MenuCommandsPerformer.self, params:[ansOb.link]});
						}else{
							this.ansActions.push(null);
						}
						
						if (i<this.ansBtns.length){
							var btn:BitBtn = this.ansBtns[i];
						}else{
							btn = Routines.buildBitBtn("", -1, this, onAnsBtnClick, 0, 250);
							btn.numVal = i;
							this.ansBtns.push(btn);
						}
						btn.visible = true;
						btn.setCaption(Translator.translator.selectPhraseOfLanguage(ansOb.text));
						
						var lineId:int = Math.floor(i / mxNumButtonsInLine);
						var idInLine:int = i % mxNumButtonsInLine;
						
						if (lineId<mxNumLines-1){
							var btnsInThisLine:int = mxNumButtonsInLine;
						}else{
							btnsInThisLine = ansAr.length - mxNumButtonsInLine * (mxNumLines - 1);
						}
						
						
						btn.x = (idInLine-((btnsInThisLine-1)/2))*(sizeWidth/(btnsInThisLine+1));
						//btn.x = (i-((ansAr.length-1)/2))*(sizeWidth/(ansAr.length+1));
						btn.y = cy+lineId*70;
					}	
					
				}
				this.bgd.setDims(sizeWidth, cy + 50 + lineId * 70);
			}			
		}
		
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 120 + Main.self.sizeManager.topMenuDelta;
			
			sizeWidth = Main.self.sizeManager.gameWidth - 140;
			
			closeBtn.x = sizeWidth / 2 - 50;
			newsCap.setMaxTextWidth(sizeWidth-20)
			newsText.setMaxTextWidth(sizeWidth-20)
			showNewsFromObject(NewGameScreen.screen.newsController.getCurrentNewsObject())
		}
		
		private function onAnsBtnClick(b:BasicButton):void 
		{

			var eft:Object = ansActions[b.numVal];
			if (eft){
				if (eft.hasOwnProperty("caller")){
					eft.func.apply(eft.caller, eft.params)
				}else{
					if (eft.hasOwnProperty("func")){
						eft.func();
					}						
				}
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
	}

}