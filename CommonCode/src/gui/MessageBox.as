package gui 
{
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import globals.StatsWrapper;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class MessageBox extends Sprite
	{
		private var bgd:NinePartsBgd;
		private var cap:MultilangTextField;
		private var txt:MultilangTextField;
		private var btns:Vector.<BitBtn>;
		private var closeBtn:SmallButton;
		
		private var isVisible:Boolean = false;
		private var buttonEffects:Array;
		private var autoHideTimer:Timer;
		
		private var statsCode:String = 'msg';
		private var totalButtons:int = 1;
		
		private var screenPos:String = "top";
		private var onHumanCloseFunction:Function;//что будет происходить,когда игрок закрыл окно нажатием на кнопку или на крестик
		public function MessageBox() 
		{
			bgd = new NinePartsBgd();
			cap = new MultilangTextField("", 0, 40, Main.self.sizeManager.fitterWidth*0.7, 2, 1, 0xffffff, "center", "scale", true);
			txt = new MultilangTextField("", 0, 56, Main.self.sizeManager.fitterWidth*0.7, -1, 1, 0xffffff, "center", "normal", true);
			
			addChild(bgd);
			addChild(cap);
			addChild(txt);
			
			
			btns = new Vector.<gui.buttons.BitBtn>();
			closeBtn = new SmallButton(74);
			closeBtn.setIconByCode("close");
			closeBtn.registerOnUpFunction(this.onCloseBtnClick);
			addChild(closeBtn);
			
			autoHideTimer = new Timer(1000, 1);
			autoHideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAutoHideTImer);
		}

		
		public function showColored(capTxt:String, colorOb:Object, answers:Array, efts:Array = null, frames:Array = null, propsOb:Object = null):void{
			var numLines:int =-1;
			if (propsOb){
				if (propsOb.hasOwnProperty("maxLines")){
					numLines = propsOb["maxLines"];
				}
				if (propsOb.hasOwnProperty("screenPos")){
					screenPos = propsOb["screenPos"];
				}
			}
			txt.setMaxTextLines(numLines, false);
			if (numLines !=-1){
				txt.setWordWrapMode("scale", false)
			}else{
				txt.setWordWrapMode("none", false)
			}
			
			
			txt.showTextsOfDifferentColors(colorOb.arOfText, colorOb.arOfColors, false);
			setOtherParams(capTxt, answers, efts, frames, propsOb)
		}

		public function show(capTxt:String, msgTxt:String, answers:Array, efts:Array = null, frames:Array = null, propsOb:Object = null):void{
			var numLines:int =-1;
			if (propsOb){
				if (propsOb.hasOwnProperty("maxLines")){
					numLines = propsOb["maxLines"];
				}
				if (propsOb.hasOwnProperty("screenPos")){
					screenPos = propsOb["screenPos"];
				}
				if (propsOb.hasOwnProperty("closeFunc")){
					onHumanCloseFunction = propsOb["closeFunc"];
				}else{
					onHumanCloseFunction = null;
				}
			}
			txt.setMaxTextLines(numLines, false);
			if (numLines !=-1){
				txt.setWordWrapMode("scale", false)
			}else{
				txt.setWordWrapMode("none", false)
			}
			
			txt.showText(msgTxt);
			setOtherParams(capTxt, answers, efts, frames, propsOb)
		}
		
		private function setOtherParams(capTxt:String, answers:Array, efts:Array=null, frames:Array=null, propsOb:Object=null):void 
		{
			buttonEffects = efts;
			
			cap.showText(capTxt);
			
			txt.y = cap.y + cap.getTextHeight()+50;
			var cy:Number = txt.y + txt.getTextHeight();
			for (var i:int = 0; i < btns.length; i++ ){
				btns[i].visible = false;
			}
			
			totalButtons = answers.length;
			var buttonW:int = 274;
			if (propsOb){
				if (propsOb.hasOwnProperty("buttonsWidth")){
					buttonW = propsOb.buttonsWidth;
				}		
			}
			
			
			for (i = 0; i < answers.length; i++){
				if (i < btns.length){
					var btn:BitBtn = btns[i];
				}else{
					btn = new BitBtn();
					addChild(btn);
					btns.push(btn);
					btn.registerOnUpFunction(onAnswerBtnClick);
				}
				btn.setBaseWidth(buttonW)
				btn.visible = true;
				btn.numVal = i;
				btn.setCaption(answers[i]);
				
				var step:int = buttonW+25;
				
				var maxLineLength:int = Math.floor(Main.self.sizeManager.fitterWidth*0.85/step);
				var idInLine:int = i % maxLineLength;
				var lineId:int = Math.floor(i / maxLineLength);
				var totBtnsInLine:int = Math.min(answers.length - lineId * maxLineLength, maxLineLength);
				if (totBtnsInLine <= 0){totBtnsInLine = 1; }
				
				
				//btn.x = (idInLine-(totBtnsInLine%2)) / 2 * step;
				btn.x = step*(idInLine)-step*(totBtnsInLine-1)/2
				//btn.myAction = actsAr[i];
				btn.y = cy+50;
				
				var iconId:int = getIconId4Button(frames, i);
				if (iconId==-1){
					btn.setIconTextMode("text");
				}else{
					btn.setIconTextMode("icontext");
					btn.setIcon(iconId);
				}
				
				if (idInLine>=totBtnsInLine-1){
					cy+=75;
				}
			}
			
			closeBtn.x = Main.self.sizeManager.fitterWidth*0.4;
			closeBtn.y = 0;
			
			bgd.setDims(Main.self.sizeManager.fitterWidth*0.85, cy + 20);
			
			statsCode = 'msg';
			
			if (propsOb){
				if (propsOb.hasOwnProperty("autohideMS")){
					this.autoHideTimer.delay = propsOb.autohideMS;
					autoHideTimer.reset();
					autoHideTimer.start();
				}
				if (propsOb.hasOwnProperty("statsCode")){
					statsCode = 'msg_'+propsOb.statsCode;
				}else{
					statsCode = 'msg_msg';
				}
				if (propsOb.hasOwnProperty("canClose")){
					closeBtn.visible = propsOb.canClose;
				}else{
					closeBtn.visible = true;
				}
				
				//if (props.hasOwnProperty("cy")){
				//	this.y = Main.self.sizeManager.topMenuDelta+props.cy;
				//}	
				
			}
			StatsWrapper.stats.logTextWithParams(statsCode, "MessageShown");
			alignOnScreen();
			visible = true;			
		}
		
		private function getIconId4Button(frames:Array, id:int):int
		{
			var res:int =-1;
			if (frames){
				if (frames.length>id){
					res = frames[id];
				}
			}
			return res;
		}
		
		private function onAnswerBtnClick(btn:BasicButton):void 
		{
			var id:int = btn.numVal;
			//trace('ID:', id);
			
			
			if (buttonEffects){
				var eft:Object = buttonEffects[id];
				if (eft){
					if (eft.hasOwnProperty("caller")){
						//trace('calling apply')
						//trace(eft.func)
						//trace(eft.caller)
						//trace(eft.params)
						eft.func.apply(eft.caller, eft.params)
					}else{
						if (eft.hasOwnProperty("func")){
							eft.func();
						}						
					}
				}
			}
			StatsWrapper.stats.logTextWithParams(statsCode, "ans_" + id.toString() + '_of_' + totalButtons.toString() );
			//потенциальный баг:
			//если func также закрывает все сообщения, а потом показывает новое (например, рестарт мира и показ нового приветствия)
			//тогда этот мсгбокс, уже закрытый, открывается вновь,
			//и тут вызывается дождавшийся своей очереди close
			this.close();
			if (this.onHumanCloseFunction){
				this.onHumanCloseFunction()
			}			
		}	
		
		private function onCloseBtnClick(btn:BasicButton):void 
		{
			StatsWrapper.stats.logTextWithParams(statsCode, "CloseClick");
			this.close();
			if (this.onHumanCloseFunction){
				this.onHumanCloseFunction()
			}
		}
		//просто при close onHumanCloseFunction не вызваем, т.к. закрыться окно могло и системой, и по истечении времени
		public function close():void 
		{
			visible = false;
		}
		
		public function handleKeyboardEvent(e:flash.events.KeyboardEvent):Boolean 
		{
			if (!this.visible){return false}
			var b:Boolean = false;
			if (e.keyCode==Keyboard.BACK){
				if (closeBtn.visible){
					this.close();
					if (this.onHumanCloseFunction){
						this.onHumanCloseFunction()
					}
					b = true;
				}
			}
			if (e.keyCode==Keyboard.ESCAPE){
				if (closeBtn.visible){
					this.close();
					if (this.onHumanCloseFunction){
						this.onHumanCloseFunction()
					}
					b = true;
				}
			}
			return b;
		}
		
		public function alignOnScreen():void 
		{
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 50+Main.self.sizeManager.topMenuDelta;
			if (this.screenPos=="bottom"){
				this.y = Main.self.sizeManager.gameHeight - 50 - bgd.height;
			}
		}
		
		private function onAutoHideTImer(e:TimerEvent):void 
		{
			close();
		}
		
	}

}