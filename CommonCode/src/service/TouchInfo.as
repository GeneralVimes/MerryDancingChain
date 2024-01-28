package service 
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import gameplay.basics.BasicGameObject;
	import gameplay.controllers.TouchController;
	//import gameplay.basics.BasicGameObject;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author ...
	 */
	public class TouchInfo 
	{
		public var wasOnLastCheck:Boolean = false;
		public var isOnThisCheck:Boolean = false;
		public var lastPoint:Point = new Point();
		public var nowPoint:Point = new Point();
		public var phase:String;
		public var lastPhase:String;
		
		public var lastInteractedObject:BasicGameObject;
		public var interactedObject:BasicGameObject;
		
		public var canBUsed4ScreenDragging:Boolean = false;
		public var touchId:int;
		public var prevTouchId:int;
		
		public var target:DisplayObject;
		public var lastTarget:DisplayObject;
		
		
		public var longTapTimer:Timer;
		private var doubleTapTimer:Timer;
		
		public var ptStartOfStationaryPhase:Point = new Point();
		private var ptOfLastEndedPhase:Point = new Point();
		private var timeOfLastStationaryPhase:int;
		
		//not used
		public var hasBeganOnThisLayer:Boolean = false;//произошло ли нажатие на этом слое, или же было нажато на более вершнем слое, а затем тот слой убрался

		public var isDoubleClickPossible:Boolean = false;
		public var isLongTapPossible:Boolean = false;
		public var isUsualClickPossible:Boolean = false;
		
		public var wasDoubleClickThisCheck:Boolean = false;
		
		public var possibleStateCode:String = 'none';
		
		
		public var arId:int
		private var controller:TouchController;
		public function TouchInfo(aid:int, cont:TouchController) 
		{
			arId = aid;
			longTapTimer = new Timer(500, 1);
			doubleTapTimer = new Timer(250, 1);
			longTapTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLongTapTimer);
			doubleTapTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDoubleTapTimer);
			
			controller = cont;
		}

		
		private function onLongTapTimer(e:TimerEvent):void 
		{
			if (isLongTapPossible){
				//trace('longTap!')
				callWorldLongTap();
			}
			cancelLongTapPossibility();
			cancelUsualClickPossibility();
			cancelDoubleClickPossibility();
		}
		
		public function initFromTouch(tch:starling.events.Touch):void 
		{
			move2History();
			wasDoubleClickThisCheck = false;
			
			if (tch){
				touchId = tch.id;
				isOnThisCheck = true;
				nowPoint.x = tch.globalX;
				nowPoint.y = tch.globalY;
				phase = tch.phase;
				target = tch.target;
				
				if (target is BasicGameObject){
					interactedObject = target as BasicGameObject;
				}else{
					interactedObject = null;
				}				
			}else{
				isOnThisCheck = false;
				touchId = -1;
				target = null;
				interactedObject = null;
				phase = null;
			}
			
			if (touchId != prevTouchId){//1й исчез, а 2й перепрыгнул на 1й
				
			}
			
			canBUsed4ScreenDragging = false;
			if (isOnThisCheck){
				if (this.phase == TouchPhase.MOVED){
					var delta:int = 15;
					if (!Routines.isDistBetweenPointsSmallerThan(ptStartOfStationaryPhase.x, ptStartOfStationaryPhase.y, nowPoint.x, nowPoint.y, delta)){
						cancelDoubleClickPossibility();
						cancelLongTapPossibility();
						cancelUsualClickPossibility();
					}
					
					if (touchId == prevTouchId){
						canBUsed4ScreenDragging = true;
					}		
					callWorldMove();
					//checkMovementOnTarget();//тут cabBUsed4Moving теоретическим может превратиться в false, если текущий target провзаимодействует
				}
				if (this.phase == TouchPhase.BEGAN){
					setLongTapPossibility();
					setUsualClickPossibility();
					
					ptStartOfStationaryPhase.x = nowPoint.x;
					ptStartOfStationaryPhase.y = nowPoint.y;
					timeOfLastStationaryPhase = tch.timestamp;
					//trace('down!')
					callWorldDown();
					//checkDownOnTarget();
				}
				if (this.phase == TouchPhase.ENDED){
					//cancel long tap possibility
					cancelLongTapPossibility();
					if (isDoubleClickPossible){
						//run doublle click
						//trace('double click!')
						callWorldDoubleClick();
					}else{
						if (isUsualClickPossible){
							//trace('click!')
							callWorldClick();
							setDoubleClickPossibility();
						}
					}
					
					ptOfLastEndedPhase.x = nowPoint.x;
					ptOfLastEndedPhase.y = nowPoint.y;
					
					//trace('up!')
					callWorldUp();
					//checkUpOnTarget();
				}
				if (this.phase == TouchPhase.HOVER){
					cancelLongTapPossibility();
					cancelUsualClickPossibility();
					//if far - cancel double click possibility
					delta = 15;
					if (!Routines.isDistBetweenPointsSmallerThan(ptOfLastEndedPhase.x, ptOfLastEndedPhase.y, nowPoint.x, nowPoint.y, delta)){
						cancelDoubleClickPossibility();
					}
					callWorldHover();
					//checkHoverOnTarget();
				}
			}else{
				//cancel double click possibility
				//cancel longtap possibility
				cancelDoubleClickPossibility();
				cancelUsualClickPossibility();
				cancelLongTapPossibility();
				//checkDisappearOnTarget();
				
				callWorldLeave();
			}
			
			doObjectInteraction(tch);
			
			if (arId==1){//когда проверили оба тача
				//передаём управление в движение
				controller.checkScaleAndMovePossibility();
			}
			
			
		}

		public function doObjectInteraction(tch:Touch):void 
		{
			//trace('handleObjectInteraction', interactedObject);
			if (lastInteractedObject != interactedObject){
				if (lastInteractedObject){
					lastInteractedObject.react2TouchLeave(tch, this);
				}
			}
			if (interactedObject){
				var res:Boolean = interactedObject.react2Touch(tch, this);
				if (res){
					canBUsed4ScreenDragging = false;
				}
			}
		}		
				
		private function callWorldLongTap():void 
		{
			if (arId == 0){
				controller.callWorldLongTap(this);
			}
		}
		
		private function callWorldClick():void 
		{
			if (arId == 0){
				controller.callWorldClick(this);
			}			
		}
		
		private function callWorldDoubleClick():void 
		{
			if (arId == 0){
				controller.callWorldDoubleClick(this);
			}				
		}
		
		private function callWorldDown():void 
		{
			if (arId == 0){
				controller.callWorldDown(this);
			}				
		}
		
		private function callWorldUp():void 
		{
			if (arId == 0){
				controller.callWorldUp(this);
			}			
		}
		private function callWorldHover():void 
		{
			if (arId == 0){
				controller.callWorldHover(this);
			}			
		}
		private function callWorldMove():void 
		{
			if (arId == 0){
				controller.callWorldMove(this);
			}			
		}
		
		private function callWorldLeave():void 
		{
			if (arId == 0){
				controller.callWorldLeave();
			}			
		}		
		
		//private function checkDisappearOnTarget():void 
		//{
		//	
		//}
		//
		//private function checkHoverOnTarget():void 
		//{
		//	
		//}
		//
		//private function checkUpOnTarget():void 
		//{
		//	
		//}
		//
		//private function checkDownOnTarget():void 
		//{
		//	
		//}
		//
		//private function checkMovementOnTarget():void 
		//{
		//	//вот тут может оказаться, что это движение не приводит к движению в мире
		//}
		
		

		//public function handleObjectInteraction(tch:Touch, reallyInteract:Boolean=true):void 
		//{
		//	//trace('handleObjectInteraction', interactedObject);
		//	if (lastInteractedObject != interactedObject){
		//		if (lastInteractedObject){
		//			lastInteractedObject.react2TouchLeave(tch, this);
		//		}
		//		
		//		//lastInteractedObject = interactedObject;//унесли в move2History
		//	}
		//	if (interactedObject){
		//		var res:Boolean = interactedObject.react2Touch(tch, this);
		//		if (res){
		//			cabBUsed4Moving = false;
		//		}
		//	}
		//}
		
		private function move2History():void 
		{
			wasOnLastCheck = isOnThisCheck;
			lastPoint.x = nowPoint.x;
			lastPoint.y = nowPoint.y;
			lastTarget = target;
			lastInteractedObject = interactedObject;
			prevTouchId = touchId;
			
			//if (phase != TouchPhase.HOVER){
			lastPhase = phase;
			//}
		}
		
		
		private function onDoubleTapTimer(e:TimerEvent):void 
		{
			cancelDoubleClickPossibility();
		}
		
		private function setDoubleClickPossibility():void 
		{
			//trace('setDoubleClickPossibility')
			isDoubleClickPossible = true;
			doubleTapTimer.reset();
			doubleTapTimer.start();
		}
		private function setLongTapPossibility():void 
		{
			isLongTapPossible = true;
			longTapTimer.reset();
			longTapTimer.start();
		}
		private function setUsualClickPossibility():void 
		{
			isUsualClickPossible = true;
		}
		private function cancelDoubleClickPossibility():void 
		{
			//trace('cancelDoubleClickPossibility')
			isDoubleClickPossible = false;
		}
		private function cancelLongTapPossibility():void 
		{
			isLongTapPossible = false;
		}
		private function cancelUsualClickPossibility():void 
		{
			//trace('cancelUsualClickPossibility')
			isUsualClickPossible = false;
		}		
	}
}