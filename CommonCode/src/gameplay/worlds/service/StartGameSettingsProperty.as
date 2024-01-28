package gameplay.worlds.service 
{
	/**
	 * ...
	 * @author ...
	 */
	public class StartGameSettingsProperty 
	{
		public var currentVal:int;
		public var defaultVal:int;
		public var minVal:int;
		public var maxVal:int;
		public var valName:String;
		
		public var willWrapViaMinMax:Boolean = false;
		
		public var correspondingTextVals:Array = [];
		public var coef2Show:Number = 1;
		public function StartGameSettingsProperty(nam:String, def:int, min:int, max:int) 
		{
			valName = nam;
			defaultVal = def;
			minVal = min;
			maxVal = max;
			
			currentVal = defaultVal;
		}
		
		public function setNewVal(val:int):void{
			currentVal = val;
		}
		
		public function setNewThresholds(mn:int, mx:int):void 
		{
			minVal = mn;
			maxVal = mx;
			if (currentVal<minVal){
				currentVal = minVal;
			}
			if (currentVal>maxVal){
				currentVal = maxVal;
			}
		}		
		public function modVal(delta:int):void{
			currentVal += delta;
			if (currentVal > maxVal){
				if (willWrapViaMinMax){
					var dist:int = maxVal - minVal + 1;
					currentVal = minVal + (currentVal - minVal) % dist;
				}else{
					currentVal = maxVal;
				}
			}
			if (currentVal < minVal){
				if (willWrapViaMinMax){
					dist = maxVal - minVal + 1;
					currentVal = maxVal - (maxVal-currentVal) % dist;
				}else{
					currentVal = minVal;
				}
			}
		}
		public function showCurrentVal():String{
			if (correspondingTextVals.length == 0){
				if (coef2Show == 1){
					return currentVal.toString();
				}else{
					return Routines.showNumberInAAFormat(currentVal*coef2Show)
				}
			}else{
				return correspondingTextVals[(currentVal - minVal) % correspondingTextVals.length];
			}
		}

	}

}