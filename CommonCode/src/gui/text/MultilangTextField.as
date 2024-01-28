package gui.text
{
	import flash.utils.Dictionary;
	import globals.Translator;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author General
	 */
	public class MultilangTextField extends Sprite
	{
		private var mustTranslateShownText:Boolean = true;
		
		private var allDict:Dictionary = Translator.translator.allDict;
		private var euroSymbols:String = globals.Translator.translator.allSymbols//westernSymbols+globals.Translator.translator.easternSymbols;
		private var bahaSymbols:String = globals.Translator.translator.notFoundBahasaSymbols;
		private var subsSymbols:String = globals.Translator.translator.subststitutes4BahasaS;
		private var asiaSymbols:String = globals.Translator.translator.easternSymbols;
		private var whiteSpaces:String = Translator.translator.whiteSpaces
		
		private var textHeight:Number = 30;
		
		private var text:String = '';
		private var untranslatedText:String = '';
		private var letterSprites:Array = [];
		private var myTint:uint = 0xffffff;
		private var myAlign:String = 'center';//'right','lefts'	
		private var myFontScale:Number = 1//0.5;
		private var fontScaleMod:Number = 1;//на сколько надо менятьскейл, чтобы все буквы уместились при wrapMode = 'scale'
		private var additionalSymbolScale:Number=1;
		
		private var maxStringWidth:Number = 900
		private var maxNumLines:int = -1;
		
		private var actulaTextWidth:Number = 0;
		
		private var numVisLines:int = 0;
		
		private var wrapMode:String = 'normal'//'normal'//
		//normal - просто переносим по словам
		//crop - пока не заполнится maxNumLines - а далее обрываем
		//scale - уменьшаем скейл, чтобы всё поместилось в maxNumLines
		
		private var xOffset:int = -12;
		private var yOffset:int = -36;
		private var additionalLettersSpacing:Number=0;//чтобы делать буквы вразбивку
		
		
		public function MultilangTextField(text:String, ax:int, ay:int, maxWidth:int = 500, maxLines:int = -1, fntScl:Number = 1, cl:uint = 0x000000, algn:String = 'center', wrpMd:String = 'normal', isTranslatable:Boolean = true, needsImmediateChangeOnLangChange:Boolean = false)
		{
			super();
			letterSprites = [];
			
			this.x = ax;
			this.y = ay;
			
			myFontScale = fntScl;
			myTint = cl;
			mustTranslateShownText = isTranslatable;
			
			maxStringWidth = maxWidth;
			maxNumLines = maxLines;
			
			wrapMode = wrpMd;
			myAlign = algn;
			
			if (needsImmediateChangeOnLangChange)
			{
				globals.Translator.translator.registerText(this);
			}
			
			touchable = false;
			touchGroup = true;
			
			showText(text);
		}
		
		public function showTextsOfDifferentColors(arOfText:Array, arOfColors:Array, mustAlwaysRedraw:Boolean=false):void 
		{
			var colorsOb:Object = {
				mustAlwaysRebuild:mustAlwaysRedraw,
				idsAndTints:[0]
			}
			
			
			for (var i:int=0; i<arOfText.length; i++){
				var tx1:String = arOfText[i];
				
				if (this.mustTranslateShownText){
					tx1 = Translator.translator.getLocalizedVersionOfText(tx1);
				}
				
				arOfText[i] = tx1;
			}
			
			var txt:String = "";
			for (i=0; i<arOfText.length; i++){
				txt+=arOfText[i];
				colorsOb.idsAndTints.push(arOfColors[i]);
				colorsOb.idsAndTints.push(txt.length);
			}
			
			this.showText(txt, colorsOb);
		}		
		
		public function showText(txt:String, colorsOb:Object = null, isSecondTime:Boolean = false):void
		{//isSecondTime вызывается после того, как вычислили модификатор скейла для правильного врепа
			if (!colorsOb)
			{//это значит, что showText был вызван непосредственно, следовательно, текст надо попробовать перевести
				if (this.mustTranslateShownText)
				{
					if (!isSecondTime){
						this.untranslatedText = txt;
						
						txt = globals.Translator.translator.getLocalizedVersionOfText(txt);						
					}

				}
			}
			
			if (!isSecondTime)
			{
				fontScaleMod = 1;
			}
			
			this.xOffset = -12 * myFontScale * fontScaleMod*additionalSymbolScale;
			this.yOffset = -36 * myFontScale * fontScaleMod*additionalSymbolScale;
			
			// console.log('showText', txt, colorsOb)
			//colorsOb - массив пар значений: индекс и какой цвет начиная с этого индекса
			if (!colorsOb)
			{
				var idsAndTints:Array = [0, -1, txt.length]
				var mustAlwaysRebuild:Boolean = false;
			}
			else
			{
				idsAndTints = colorsOb.idsAndTints;
				if (idsAndTints.length % 2 == 0)
				{
					idsAndTints.push(txt.length);
				}
				mustAlwaysRebuild = colorsOb.mustAlwaysRebuild
			}
			
			// console.log('showText', txt)
			if ((txt != this.text) || mustAlwaysRebuild || isSecondTime)
			{
				var idInTintsAr:int = 0;
				
				var cx:Number = this.xOffset;
				var cy:Number = this.yOffset;
				var txtLen:int = txt.length;
				
				var ltrLen:int = this.letterSprites.length;
				var len:int = Math.max(txtLen, ltrLen);
				
				var lines2Align:Array = [];
				var i0:int = 0;
				
				var lineStartX:Number = cx;
				
				for (var i:int = 0; i < len; i++)
				{
					if (i < txtLen)
					{
						var ch:String = txt.charAt(i);
						//ch = "다";
						var frid:int = -1;
						if (ch in this.allDict){
							frid = this.allDict[ch];
						}
						
						//frid=375
						//frid = 378;
						//trace("ch=", ch, "frid=",frid, "smb=",euroSymbols.charAt(frid));
						if (frid ==-1){
							
							//вместо сложной диакритики у Віетнама будем использовать более простые европейские символы (чтобы не раздувать листы) 
							frid = this.bahaSymbols.indexOf(ch);
							if (frid!=-1){
								var subsCh:String = this.subsSymbols.charAt(frid);
								if (subsCh in allDict){
									frid = allDict[subsCh];
								}else{
									frid = -1;
								}
								
							}
							//корею (и японию потом) строки склеены с европейскими
						}
						
						if (i < ltrLen)
						{
							var ltr:gui.text.LetterMC = this.letterSprites[i];
							ltr.setCurrentFrame(frid);
						}
						else
						{
							ltr = new gui.text.LetterMC(Assets.allTextures["TXS_FONT"]);
							ltr.setCurrentFrame(frid);
							addChild(ltr);
							this.letterSprites.push(ltr);
								//ltr.setOrigin(0.5,1)
						}
						
						if (i >= idsAndTints[idInTintsAr + 2])
						{
							idInTintsAr += 2;
						}
						
						var tnt:int = idsAndTints[idInTintsAr + 1];
						if (tnt == -1)
						{
							tnt = this.myTint;
						}
						ltr.color = tnt;
						
						ltr.scale = this.myFontScale * fontScaleMod*additionalSymbolScale;
						
						ltr.x = cx;
						ltr.y = cy;
						if (frid!=-1){
							ltr.visible = true
						}else{
							if (whiteSpaces.indexOf(ch)==-1){
								ltr.visible = true//using 0 as tofu
							}else{
								ltr.visible = false;
							}
						}
						//(frid != -1);
						
						//space width = 0 width = 17+2+additionalLettersSpacing
						var aw:Number = (ltr.getFrameTexture(ltr.currentFrame).width + 2 + this.additionalLettersSpacing)
						//if (frid>=globals.Translator.translator.westernSymbols.length){//setting equal width for all eastern symbols
						//	aw = 42;//because IDKY, their atlas width of 27 is not enough
						//but if we add all letter images to EuroFont size will be caught correctly
						//}
						cx += aw * this.myFontScale * fontScaleMod;
						
						//пока делаем просто - переносим следуюий символ, если вылезли за границу строки
						if (ch == '\n')
						{
							cx = this.xOffset + 0;
							cy += getSingleLineHeight()
							lines2Align.push({from: i0, to: i - 1})
							i0 = i + 1;
							lineStartX = cx;
						}
						else
						{
							if (i == txtLen - 1)
							{
								lines2Align.push({from: i0, to: i})
							}
							else
							{
								//дальше в тексте ещё есть символы, но следующий символ будет уже правее ширины строки
								if (cx - lineStartX > this.maxStringWidth)
								{
									if (wrapMode == 'crop')
									{//просто обезаем строку
										if (lines2Align.length + 1 >= this.maxNumLines)
										{
											//todo: добавить ещё 3 точки
											lines2Align.push({from: i0, to: i})
											for (var k:int = i + 1; k < this.letterSprites.length; k++)
											{
												letterSprites[k].visible = false;
											}
											break;
										}
									}
									
									var chNext:String = txt.charAt(i + 1);
									if (!(chNext in allDict))
									{//это разделитель
										cx = this.xOffset + 0;
										cy += getSingleLineHeight()
										lines2Align.push({from: i0, to: i})
										i0 = i + 1;
										lineStartX = cx;
									}
									else
									{//если следующая идёт буква
										//часть символов из текущей строки надо сбросить в следующую
										var separatorId:int = i;
										for (k = i - 1; k > i0; k--)
										{
											
											var ch1:String = txt.charAt(k)
											if (!(ch1 in allDict))
											{//ранее был разделитель
												separatorId = k;
												break;
											}
										}
										
										//оставляем на рпедыдущей строке всё, до separatorId включительно
										//а следующие символы - на новую
										//cx не двигаем, потом всё подвинем, кгда будем делать align
										
										cy += getSingleLineHeight()
										for (k = separatorId + 1; k <= i; k++)
										{
											this.letterSprites[k].y = cy;
										}
										if (separatorId < i)
										{
											lineStartX = this.letterSprites[separatorId + 1].x;
										}
										else
										{
											lineStartX = cx;
										}
										
										//if (separatorId < i){
											lines2Align.push({from: i0, to: separatorId})
											i0 = separatorId + 1;
										//}else{
										//	lines2Align.push({from: i0, to: separatorId-1})
										//	i0 = separatorId;
										//}
										
										
									}
								}
							}
						}
					}
					else
					{
						this.letterSprites[i].visible = false;
					}
				}
				this.text = txt;
				var numLines:int = lines2Align.length;
				numVisLines = numLines;
				// console.log('Align Lines', this.text, lines2Align)
				if (txtLen > 0)
				{
					for (i = 0; i < lines2Align.length; i++)
					{
						// console.log('i=',i);
						this.alignVisibleLetters(lines2Align[i].from, lines2Align[i].to);
					}
				}
				
				this.textHeight = cy-this.yOffset + getSingleLineHeight();
				
				if (!isSecondTime)
				{
					if (wrapMode == 'scale')
					{
						if (this.maxNumLines != -1)
						{
							if (numLines > this.maxNumLines)
							{
								var lastLineLength:Number = cx - lineStartX;
								this.fontScaleMod = (this.maxNumLines * this.maxStringWidth ) / (lastLineLength+(numLines-1) * this.maxStringWidth)
								showText(txt, colorsOb, true);
							}
						}
					}
				}
				
				
			}
		}
		
		public function getSingleLineHeight():Number 
		{
			return 45*this.myFontScale*this.fontScaleMod
		}		
		private function alignVisibleLetters(id0:int, id1:int):void
		{
			// console.log('alignVisibleLetters', id0, id1)
			if (id1 >= id0)
			{
				var x0:Number = this.letterSprites[id0].x;
				var x1:Number = this.letterSprites[id1].x;
				// console.log('alignVisibleLetters',this.text, id0, id1, x0, x1, this.myAlign);
				switch (this.myAlign)
				{
				case "left": 
				{
					var delta:Number = this.xOffset - x0;
					break;
				}
				case "center": 
				{
					delta = this.xOffset - (x1 + x0) / 2
					break;
				}
				case "right": 
				{
					delta = this.xOffset - x1;
					break;
				}
				}
				for (var i:int = id0; i <= id1; i++)
				{
					this.letterSprites[i].x += delta;
				}
			}
		
		}
		
		public function updateTextTranslation():void
		{
			this.showText(this.untranslatedText, null);
		}
		
		public function getRemovedFromAllTextFields():void
		{
			globals.Translator.translator.unregisterText(this);
		}
		
		public function getRemovedFromTranslatableList():void 
		{
			mustTranslateShownText = false;
			getRemovedFromAllTextFields();
		}		
		
		public function getCurrentText():String
		{
			return this.text;
		}
		
		public function setMaxTextWidth(aw:Number, mustRebuildText:Boolean=true):void 
		{
			this.maxStringWidth = aw;
			if (mustRebuildText){
				this.showText(this.text, {idsAndTints:[0, -1], mustAlwaysRebuild:true});		
			}
		}
		
		public function getMaxTextWidth():Number
		{
			return this.maxStringWidth;
		}
		public function getTextHeight():Number 
		{
			return this.textHeight;
		}
		public function getTextLines():int 
		{
			return this.numVisLines;
		}
		
		public function setMaxTextLines(n:int, mustRebuildText:Boolean=true):void 
		{
			this.maxNumLines = n;
			if (mustRebuildText){
				this.showText(this.text, {idsAndTints:[0, -1], mustAlwaysRebuild:true});
			}
			
		}
		
		public function setAdditionalLetterSpacing(spc:Number):void 
		{
			additionalLettersSpacing = spc;
		}	
		public function getAdditionalLetterSpacing():Number
		{
			return additionalLettersSpacing;
		}		
		public function getSpaceSymbolWidth():Number
		{
			return 17+2;
		}		
		public function setAdditionalSymbolScale(scl:Number):void 
		{
			additionalSymbolScale = scl;
		}	
		public function getAdditionalSymbolScale():Number
		{
			return additionalSymbolScale;
		}
		
		public function setWordWrapMode(md:String, mustRebuildText:Boolean=true):void 
		{
			this.wrapMode = md;
			if (mustRebuildText){
				this.showText(this.text, {idsAndTints:[0, -1], mustAlwaysRebuild:true});
			}
			
		}

		public function setMyFontScale(scl:Number, mustRebuildText:Boolean=true):void 
		{
			this.myFontScale = scl;
			if (mustRebuildText){
				this.showText(this.text, {idsAndTints:[0, -1], mustAlwaysRebuild:true});
			}
		}

		
		public function setTextColor(cl:uint):void 
		{
			myTint = cl;
			for (var i:int = 0; i < letterSprites.length; i++ ){
				letterSprites[i].color = cl;
			}
		}


	
	}

}