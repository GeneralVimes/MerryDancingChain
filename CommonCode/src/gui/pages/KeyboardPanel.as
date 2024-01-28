package gui.pages 
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.text.MultilangTextField;
	/**
	 * ...
	 * @author ...
	 */
	public class KeyboardPanel extends InterfacePage 
	{
		public var currentShownText:String = "";
		private var onCompleteHandler:Function;
		private var maxStringLength:int=8;
		private var isUpperCase:Boolean=true;
		private var cap:gui.text.MultilangTextField;
		private var bigCap:gui.text.MultilangTextField;
		
		private var keyBtns:Vector.<BitBtn>;
		private var closeBtn:gui.buttons.SmallButton;
		private var bgd:NinePartsBgd;
		private var defaultSymbolsAr:Array = ["1234567890","QWERTYUIOP","ASDFGHJKL","ZXCVBNM_"];
		private var delBtn:BitBtn;
		public function KeyboardPanel() 
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
			this.bigCap = new MultilangTextField("", 0, 20, sizeWidth-40, 1, 1, 0xffffff, "center", "scale", true, true);
			addChild(bigCap);
			
			this.cap = new MultilangTextField("", -sizeWidth/2+30, 40+50, sizeWidth-250, 1, 1, 0xffffff, "left", "scale", true, true);
			addChild(cap);
			
			var okBtn:BitBtn = Routines.buildBitBtn('OK', -1, this, onOkClick, sizeWidth / 2 - 140, 40+50);
			delBtn = Routines.buildBitBtn('DEL', -1, this, onDelClick, sizeWidth / 2 - 140, 100+50);
			var shiftBtn:BitBtn = Routines.buildBitBtn('SHIFT', -1, this, onShiftClick, -sizeWidth / 2 + 100, 200);
			okBtn.setBaseWidth(150);
			delBtn.setBaseWidth(150);
			shiftBtn.setBaseWidth(150);
			
			var smbArs:Array = defaultSymbolsAr;
			keyBtns = new Vector.<gui.buttons.BitBtn>();
			var cy:int = 0;
			for (var i:int = 0; i < smbArs.length; i++ ){
				var str:String = smbArs[i];
				for (var j:int = 0; j < str.length; j++ ){
					var ch:String = str.charAt(j);
					cy = delBtn.y + 20 + 65+50 + i * 55;
					var btn:BitBtn = Routines.buildBitBtn(ch, -1, this, typeSymbol, (j - str.length / 2 + 0.5) * 60, cy);
					this.keyBtns.push(btn);
					btn.setBaseHeight(50);
					btn.setBaseWidth(55);
				}
			}
			cy += 50;
			bgd.setDims(sizeWidth, cy+20);			
		}
		
		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			bigCap.showText(paramsOb.caption);
			setCurrentShownText(paramsOb.text);
			onCompleteHandler = paramsOb.onComplete;
			maxStringLength = paramsOb.maxStringLength;
			isUpperCase = true;
			if (paramsOb.hasOwnProperty("keysAr")){
				this.initButtonsFromSymbolsAr(paramsOb.keysAr)
			}else{
				this.initButtonsFromSymbolsAr(this.defaultSymbolsAr)
			}
		}
		
		private function initButtonsFromSymbolsAr(smbArs:Array):void 
		{
			var cy:int = 0;
			var totSymbols:int = 0;
			for (var i:int = 0; i < keyBtns.length;i++ ){
				keyBtns[i].visible = false;
			}
			
			var keyId:int = 0;
			for (i = 0; i < smbArs.length; i++ ){
				var str:String = smbArs[i];
				for (var j:int = 0; j < str.length; j++ ){
					var ch:String = str.charAt(j);
					cy = delBtn.y + 20 + 65 + 50 + i * 55;
					if (keyId<keyBtns.length){
						var btn:BitBtn = keyBtns[keyId];
						btn.x = (j - str.length / 2 + 0.5) * 60;
						btn.y = cy;
						btn.setCaption(ch);
						btn.visible = true;
					}else{
						btn = Routines.buildBitBtn(ch, -1, this, typeSymbol, (j - str.length / 2 + 0.5) * 60, cy);
						this.keyBtns.push(btn);
						btn.setBaseHeight(50);
						btn.setBaseWidth(55);							
					}
					keyId++;
				}					
			}	
			cy += 50;
			bgd.setDims(sizeWidth, cy+20);				
		}
		
		private function setCurrentShownText(txt:String):void 
		{
			cap.showText(txt);
		}
		
		private function onShiftClick(b:BasicButton):void {
			isUpperCase = !isUpperCase;
			for (var i:int = 0; i < this.keyBtns.length; i++ ){
				if (isUpperCase){
					this.keyBtns[i].setCaption(this.keyBtns[i].getCaptionText().toUpperCase())
				}else{
					this.keyBtns[i].setCaption(this.keyBtns[i].getCaptionText().toLowerCase())
				}
			}
		}
		private function onOkClick(b:BasicButton):void 
		{
			var code:String = cap.getCurrentText();
			if (onCompleteHandler){
				onCompleteHandler(code);
			}
			this.hide();
		}
		
		private function onDelClick(b:BasicButton):void 
		{
			var str:String = cap.getCurrentText();
			if (str.length<=1){
				cap.showText("");
			}else{
				cap.showText(str.substr(0, str.length - 1));
			}		
		}		
		
		private function typeSymbol(b:BitBtn):void 
		{
			if (cap.getCurrentText().length<maxStringLength){
				cap.showText(cap.getCurrentText() + b.getCaptionText());	
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
				//var ch:String = String.fromCharCode(e.charCode)
				//trace("ch=", ch);
				//for (var i:int = 0; i < keyBtns.length; i++){
				//	if (ch.toLowerCase()==keyBtns[i].getCaptionText().toLowerCase()){
				//		if (cap.getCurrentText().length<maxStringLength){
				//			cap.showText(cap.getCurrentText() + ch);	
				//		}						
				//		b = true;
				//	}
				//}
				
				
				if ((e.keyCode==Keyboard.DELETE)||(e.keyCode==Keyboard.BACKSPACE)){
					var str:String = cap.getCurrentText();
					if (str.length<=1){
						cap.showText("");
					}else{
						cap.showText(str.substr(0, str.length - 1));
					}
					b = true;
				}
				
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
	}

}