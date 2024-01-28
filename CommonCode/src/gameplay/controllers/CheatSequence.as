package gameplay.controllers 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class CheatSequence 
	{
		private var currentlyCheckedZoneId:int=0;
		private var zones:Vector.<Rectangle>;
		private var percentedZones:Vector.<Rectangle>;
		public var hasTriggered:Boolean = false;
		public function CheatSequence() 
		{
			zones = new Vector.<Rectangle>();
			percentedZones = new Vector.<Rectangle>();
		}
		
		
		public function checkTouchCoords(ax:int, ay:int):void{
			
			var rect:Rectangle = zones[currentlyCheckedZoneId];
			//trace('checkTouchCoords', ax, ay, rect);
			if (rect.contains(ax, ay)){
				currentlyCheckedZoneId++;
				if (currentlyCheckedZoneId >= zones.length){
					hasTriggered = true;
					currentlyCheckedZoneId = 0;
				}
			}else{
				currentlyCheckedZoneId = 0;
			}
		}
		
		public function reset():void 
		{
			currentlyCheckedZoneId = 0;
		}
		
		public function registerRect(rct:Rectangle):void 
		{
			percentedZones.push(rct);
			zones.push(rct.clone());
		}
		
		public function setActualScreenSize(aw:int, ah:int):void 
		{
			for (var i:int = 0; i < zones.length; i++ ){
				zones[i].left = percentedZones[i].left * aw;
				zones[i].right = percentedZones[i].right * aw;
				zones[i].top = percentedZones[i].top * ah;
				zones[i].bottom = percentedZones[i].bottom * ah;
			}
		}
	}

}