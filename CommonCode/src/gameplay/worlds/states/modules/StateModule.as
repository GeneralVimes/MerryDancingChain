package gameplay.worlds.states.modules 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import gameplay.worlds.states.WorldState;
	import service.TouchInfo;
	/**
	 * ...
	 * @author ...
	 */
	public class StateModule 
	{
		public var myState:WorldState
		public function StateModule(st:WorldState) 
		{
			myState = st;
		}
		
		public function callWorldLongTap(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			
		}
		
		public function callWorldClick(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			
		}
		
		public function callWorldDoubleClick(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			
		}
		
		public function callWorldDown(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			
		}
		
		public function callWorldUp(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			
		}
		
		public function callWorldHover(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			
		}
		
		public function callWorldMove(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			
		}
		
		public function callWorldLeave():void 
		{
			
		}
		
		public function doAnimStep(dt:Number):void 
		{
			
		}
		
		public function performSeldomActualization():void 
		{
			
		}
		
		public function initProps(propsOb:Object):void 
		{
			
		}
		
		public function finalize():void 
		{
			
		}
		
		public function handleKeyboardEent(e:flash.events.KeyboardEvent):void 
		{
			
		}
		
		public function handleMouseWheel(e:flash.events.MouseEvent):void 
		{
			
		}
		
		public function react2NewVisualizationScale():void 
		{
			
		}
		
		public function react2NewVisualizationCoords():void 
		{
			
		}
		
		public function react2Resize():void 
		{
			
		}
		
	}

}