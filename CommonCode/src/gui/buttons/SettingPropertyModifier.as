package gui.buttons 
{
	import gameplay.worlds.service.StartGameSettingsProperty;
	import gui.text.MultilangTextField;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class SettingPropertyModifier extends Sprite
	{
		private var txt:gui.text.MultilangTextField;
		private var myProperty:StartGameSettingsProperty;
		private var myDelta:int;
		private var plusBtn:SmallButton;
		private var minBtn:SmallButton;
		public function SettingPropertyModifier(prop:StartGameSettingsProperty, txW:Number, delta:int=1) 
		{
			myProperty = prop;
			myDelta = delta;
			this.txt = new MultilangTextField("", 0, 0, txW, 1, 1, 0xffffff, "center", "scale", true, false);
			addChild(txt);
			plusBtn = new SmallButton(0, 1, 0);
			minBtn = new SmallButton(0, 1, 0);
			plusBtn.setCaption("+");
			minBtn.setCaption("-");
			plusBtn.setIconByCode("empty");
			minBtn.setIconByCode("empty");
			plusBtn.registerOnUpFunction(onPlusClick);
			minBtn.registerOnUpFunction(onMinusClick);
			addChild(plusBtn);
			addChild(minBtn);
			plusBtn.x = txW/2+50;
			minBtn.x = -txW/2-50;
			plusBtn.y = 0
			minBtn.y = 0
			
			showProp();
		}
		
		public function getPropValue():Number{
			if (!myProperty){ return 0}
			return myProperty.currentVal;
		}
		
		public function attach2Property(prop:StartGameSettingsProperty):void{
			myProperty = prop;
		}
		
		public function showProp(addedText:String=null):void 
		{
			if (!myProperty){ return }
			var str:String = myProperty.valName+': ' + myProperty.showCurrentVal();
			if (addedText){
				str += addedText;
			}
			txt.showText(str);
			if (!myProperty.willWrapViaMinMax){
				minBtn.visible = myProperty.currentVal > myProperty.minVal;
				plusBtn.visible = myProperty.currentVal < myProperty.maxVal;
			}else{
				minBtn.visible = true;
				plusBtn.visible = true;
			}
		}
		
		public function setWidth(txW:Number):void 
		{
			plusBtn.x = txW/2+50;
			minBtn.x = -txW/2-50;
			plusBtn.y = 0
			minBtn.y = 0
			this.txt.setMaxTextWidth(txW);
		}
		
		public function setLines(n:int):void 
		{
			this.txt.setMaxTextLines(n, false);

		}
		
		private function onMinusClick(b:BasicButton):void 
		{
			if (!myProperty){ return }
			myProperty.modVal(-myDelta);
			showProp();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onPlusClick(b:BasicButton):void 
		{
			if (!myProperty){ return }
			myProperty.modVal(myDelta);
			showProp();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}

}