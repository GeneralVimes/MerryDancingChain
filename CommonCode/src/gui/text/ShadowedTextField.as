package gui.text
{
	import gui.text.MultilangTextField;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class ShadowedTextField extends Sprite
	{
		private var tfShadow:MultilangTextField;
		private var tfFront:MultilangTextField;
		
		private var dx:Number = 2;
		private var dy:Number = 2;
		public function ShadowedTextField(text:String, ax:int, ay:int, maxWidth:int = 500, maxLines:int = -1, fntScl:Number = 1, cl:uint = 0xffffff, clShad:uint = 0x000000, algn:String = 'center', wrpMd:String = 'normal', isTranslatable:Boolean = true, needsImmediateChangeOnLangChange:Boolean = false)
		{
			this.x = ax;
			this.y = ay;
			tfShadow = new MultilangTextField(text, 0 + dx, 0 + dy, maxWidth, maxLines, fntScl, clShad, algn, wrpMd, isTranslatable, needsImmediateChangeOnLangChange);
			tfShadow.setAdditionalSymbolScale(1.0);
			addChild(tfShadow);
			tfShadow.alpha = 0.5;
			
			tfFront = new MultilangTextField(text, 0, 0, maxWidth, maxLines, fntScl, cl, algn, wrpMd, isTranslatable, needsImmediateChangeOnLangChange);
			addChild(tfFront);
			
			touchable = false;
			touchGroup = true;
		}
		
		
		public function showText(txt:String, colorsOb:Object = null):void{
			tfFront.showText(txt, colorsOb);
			tfShadow.showText(txt);
		}
		
		public function getSingleLineHeight():Number {
			return tfFront.getSingleLineHeight();
		}
		
		public function getRemovedFromAllTextFields():void
		{
			tfFront.getRemovedFromAllTextFields();
			tfShadow.getRemovedFromAllTextFields();
		}
		
		public function getCurrentText():String
		{
			return tfFront.getCurrentText();
		}
		
		public function setMaxTextWidth(aw:Number, mustRebuildText:Boolean=true):void 
		{
			tfFront.setMaxTextWidth(aw,mustRebuildText);
			tfShadow.setMaxTextWidth(aw,mustRebuildText);
		}
		public function getTextHeight():Number{
			return tfFront.getTextHeight() + Math.abs(dx);
		}	
		public function setMaxTextLines(n:int, mustRebuildText:Boolean=true):void 
		{
			tfFront.setMaxTextLines(n,mustRebuildText);
			tfShadow.setMaxTextLines(n,mustRebuildText);
		}	
		public function setWordWrapMode(md:String, mustRebuildText:Boolean=true):void {
			tfFront.setWordWrapMode(md,mustRebuildText);
			tfShadow.setWordWrapMode(md,mustRebuildText);			
		}
		
		public function setAdditionalLetterSpacing(spc:Number):void 
		{
			tfFront.setAdditionalLetterSpacing(spc)
			tfShadow.setAdditionalLetterSpacing(spc)
		}		
		public function setAdditionalSymbolScale(scl:Number):void 
		{
			tfFront.setAdditionalSymbolScale(scl)
			tfShadow.setAdditionalSymbolScale(scl)
		}
		
		public function setTextColor(fCl:uint):void{
			tfFront.setTextColor(fCl);
		}
		public function setShadowColor(cl:uint):void{
			tfShadow.setTextColor(cl);
		}
		
		public function getMaxTextWidth():Number 
		{
			return tfFront.getMaxTextWidth();
		}
		
		public function getSpaceSymbolWidth():Number 
		{
			return tfFront.getSpaceSymbolWidth()
		}
		
		public function getAdditionalSymbolScale():Number 
		{
			return tfFront.getAdditionalSymbolScale();
		}
		
		public function getRemovedFromTranslatableList():void 
		{
			tfFront.getRemovedFromTranslatableList();
			tfShadow.getRemovedFromTranslatableList();
		}
		
		public function addBGD(im:starling.display.Image):void 
		{
			addChild(im);
			addChild(tfShadow);
			addChild(tfFront);
		}
	}

}