package gameplay.basics.service 
{
	import flash.geom.Point;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author ...
	 */
	public class MouseController 
	{
		public var entryMousePoint:Point//=new Point();
		public var prevMousePoint:Point//=new Point();
		public var downMousePoint:Point//=new Point();
		public var upMousePoint:Point//=new Point();
		public var currentMousePoint:Point //= new Point();
		
		public var entryGlobalMousePoint:Point//=new Point();
		public var prevGlobalMousePoint:Point//=new Point();
		public var downGlobalMousePoint:Point//=new Point();
		public var upGlobalMousePoint:Point//=new Point();
		public var currentGlobalMousePoint:Point //= new Point();		
		
		public var entryMousePointsVec			:Vector.<Point>=new Vector.<Point>();
		public var prevMousePointsVec			:Vector.<Point>=new Vector.<Point>();
		public var downMousePointsVec			:Vector.<Point>=new Vector.<Point>();
		public var upMousePointsVec				:Vector.<Point>=new Vector.<Point>();
		public var currentMousePointsVec		:Vector.<Point>=new Vector.<Point>();
		public var entryGlobalMousePointsVec	:Vector.<Point>=new Vector.<Point>();
		public var prevGlobalMousePointsVec		:Vector.<Point>=new Vector.<Point>();
		public var downGlobalMousePointsVec		:Vector.<Point>=new Vector.<Point>();
		public var upGlobalMousePointsVec		:Vector.<Point>=new Vector.<Point>();
		public var currentGlobalMousePointsVec	:Vector.<Point>=new Vector.<Point>();	

		
		protected var wasPreviouslyMouseDown:Boolean = false;
		protected var wasPreviouslyMouseOver:Boolean = false;
		
		public var prevMouseInteractionTimeStamp:Number = 0;
		public var currentMouseInteractionTimeStamp:Number = 0;
		
		protected var tmpPt:Point = new Point();
		
		private var reaction2MouseDown:Function;
		private var reaction2MouseUp:Function;
		private var reaction2MouseEnter:Function;
		private var reaction2MouseExit:Function;
		private var reaction2MouseMoveTouched:Function;
		private var reaction2MouseMoveUntouched:Function;
		
		public var arId:int = 0;
		

		
		public var lastMouseInfId:int = -1;
		public function MouseController(aid:int) 
		{
			arId = aid;
			entryMousePointsVec.push(new Point(),new Point())			
			prevMousePointsVec.push(new Point(),new Point())			
			downMousePointsVec.push(new Point(),new Point())			
			upMousePointsVec.push(new Point(),new Point())				
			currentMousePointsVec.push(new Point(),new Point())		
			entryGlobalMousePointsVec.push(new Point(),new Point())	
			prevGlobalMousePointsVec.push(new Point(),new Point())		
			downGlobalMousePointsVec.push(new Point(),new Point())		
			upGlobalMousePointsVec.push(new Point(),new Point())		
			currentGlobalMousePointsVec.push(new Point(),new Point())
		}
		
		public function registerMouseHandlers(fDown:Function, fUp:Function, fEnter:Function, fExit:Function, fMoveTouched:Function, fMoveUntouched:Function):void{
			reaction2MouseDown = fDown;
			reaction2MouseUp = fUp;
			reaction2MouseEnter = fEnter;
			reaction2MouseExit = fExit;
			reaction2MouseMoveTouched = fMoveTouched;
			reaction2MouseMoveUntouched = fMoveUntouched;
		}
		
		public function react2Touch(infId:int, tch:Touch, obj:Sprite, tm:Number):Boolean 
		{
			if (lastMouseInfId != infId){
				lastMouseInfId = infId;
				entryMousePoint			= entryMousePointsVec[lastMouseInfId]			
				prevMousePoint			= prevMousePointsVec[lastMouseInfId]				
				downMousePoint			= downMousePointsVec[lastMouseInfId]				
				upMousePoint			= 	upMousePointsVec[lastMouseInfId]				
				currentMousePoint		= currentMousePointsVec[lastMouseInfId]			
				entryGlobalMousePoint	= entryGlobalMousePointsVec[lastMouseInfId]		
				prevGlobalMousePoint	= 	prevGlobalMousePointsVec[lastMouseInfId]		
				downGlobalMousePoint	= 	downGlobalMousePointsVec[lastMouseInfId]		
				upGlobalMousePoint		= upGlobalMousePointsVec[lastMouseInfId]			
				currentGlobalMousePoint	= currentGlobalMousePointsVec[lastMouseInfId]					
			}
		
			var res:Boolean = false;
			currentMouseInteractionTimeStamp = tm;
			
			if (tch){
				tmpPt.x = tch.globalX;
				tmpPt.y = tch.globalY;
				obj.globalToLocal(tmpPt, currentMousePoint);
				currentGlobalMousePoint.x = tmpPt.x;
				currentGlobalMousePoint.y = tmpPt.y;
				
				switch (tch.phase){
					case TouchPhase.BEGAN:{
						wasPreviouslyMouseDown = true;
						downMousePoint.x = currentMousePoint.x;
						downMousePoint.y = currentMousePoint.y;
						
						downGlobalMousePoint.x = currentGlobalMousePoint.x;
						downGlobalMousePoint.y = currentGlobalMousePoint.y;
						
						res=reaction2MouseDown();
						break;
					}
					case TouchPhase.ENDED:{
						if (wasPreviouslyMouseDown){
							upMousePoint.x = currentMousePoint.x;
							upMousePoint.y = currentMousePoint.y;
							upGlobalMousePoint.x = currentGlobalMousePoint.x;
							upGlobalMousePoint.y = currentGlobalMousePoint.y;							
							res=reaction2MouseUp();

						}
						wasPreviouslyMouseDown = false;
						break;
					}
					case TouchPhase.MOVED:{
						res=reaction2MouseMoveTouched();
						break;
					}
					case TouchPhase.HOVER:{
						if (wasPreviouslyMouseOver){
							res=reaction2MouseMoveUntouched();
						}else{
							wasPreviouslyMouseOver = true;
							res=reaction2MouseEnter();
						}
						
						break;
					}
				}
				prevMousePoint.x = currentMousePoint.x;
				prevMousePoint.y = currentMousePoint.y;
				prevGlobalMousePoint.x = currentGlobalMousePoint.x;
				prevGlobalMousePoint.y = currentGlobalMousePoint.y;
			}else{
				wasPreviouslyMouseDown = false;
				wasPreviouslyMouseOver = false;
				res=reaction2MouseExit();
			}
			
			prevMouseInteractionTimeStamp = currentMouseInteractionTimeStamp;
			return res;
		}
		
		public function hasDraggedBetweenDownAndUp():Boolean 
		{
			var dx:Number = upGlobalMousePoint.x - downGlobalMousePoint.x;
			var dy:Number = upGlobalMousePoint.y - downGlobalMousePoint.y;
			return (Math.abs(dx) > 20) || (Math.abs(dy) > 20);
		}
		
	}

}