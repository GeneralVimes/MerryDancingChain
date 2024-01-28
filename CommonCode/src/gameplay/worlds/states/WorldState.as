package gameplay.worlds.states 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import gameplay.worlds.World;
	import gameplay.worlds.states.modules.StateModule;
	import service.TouchInfo;
	/**
	 * ...
	 * @author ...
	 */
	public class WorldState 
	{
		
		protected var myWorld:World;
		protected var lastSeldomActualizationTime:Number = 0;
		protected var delayBetweenSeldomActualizations:Number = 0.1;
		protected var playTime:Number = 0;	
		
		protected var isAnimatingScreenMovement:Boolean = false;
		protected var animationMode:int = 0;//0 - screen center, 1 - topleft point
		protected var ptOfScreenMovementStart:Point;
		protected var ptOfScreenMovementEnd:Point;
		protected var screenMovementTotalTime:Number=1;
		protected var screenMovementElapsedTime:Number = 0;
		
		public var isActive:Boolean = true;
		public var canBAutoSaved:Boolean = true;
		
		protected var myModules:Vector.<StateModule>
		public function WorldState(wrl:World) 
		{
			myWorld = wrl;
			isActive = true;
			ptOfScreenMovementStart = new Point();
			ptOfScreenMovementEnd = new Point();
			
			myModules = new Vector.<gameplay.worlds.states.modules.StateModule>;
		}
		
		
		public function callWorldLongTap(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].callWorldLongTap(wx, wy, sx, sy, inf)
			}
		}
		
		public function callWorldClick(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].callWorldClick(wx, wy, sx, sy, inf)
			}
		}
		
		public function callWorldDoubleClick(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].callWorldDoubleClick(wx, wy, sx, sy, inf)
			}
		}
		
		public function callWorldDown(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].callWorldDown(wx, wy, sx, sy, inf)
			}
		}
		
		public function callWorldUp(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].callWorldUp(wx, wy, sx, sy, inf)
			}
		}
		
		public function callWorldHover(wx:Number, wy:Number, sx:Number, sy:Number, inf:service.TouchInfo):void 
		{
			//inf.lastPoint имеет сведения и о своей предыдущей точке
			//inf.wasOnLastCheck
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].callWorldHover(wx, wy, sx, sy, inf)
			}			
		}
		
		public function callWorldMove(wx:Number, wy:Number, sx:Number, sy:Number, inf:TouchInfo):void 
		{
			//inf.lastPoint имеет сведения и о своей предыдущей точке
			//inf.canBUsed4ScreenDragging можно запретить перетаскивание экрана, что является дефотным действием на движение
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].callWorldMove(wx, wy, sx, sy, inf)
			}			
		}
		
		public function callWorldLeave():void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].callWorldLeave()
			}
		}		
		
		public function doAnimStep(dt:Number):void{
			playTime+= dt;
			if (playTime>=lastSeldomActualizationTime+delayBetweenSeldomActualizations){
				performSeldomActualization();
				lastSeldomActualizationTime = playTime;
			}
			
			if (isAnimatingScreenMovement){
				screenMovementElapsedTime+= dt;
				if (screenMovementElapsedTime>=screenMovementTotalTime){
					isAnimatingScreenMovement = false;
				}
				var lambda:Number = screenMovementElapsedTime / screenMovementTotalTime;
				if (lambda < 0){lambda = 0; }
				if (lambda > 1){lambda = 1; }
				
				lambda = (lambda < 0.5)?(2 * lambda * lambda):(1 - 2 * (1 - lambda) * (1 - lambda));
				if (animationMode==0){
					this.myWorld.visualization.showWorldPointAtScreenCenter(
							ptOfScreenMovementStart.x+lambda*(ptOfScreenMovementEnd.x-ptOfScreenMovementStart.x),
							ptOfScreenMovementStart.y + lambda * (ptOfScreenMovementEnd.y - ptOfScreenMovementStart.y)
						)					
				}
				if (animationMode == 1){
					this.myWorld.visualization.setNewCoords(
							ptOfScreenMovementStart.x+lambda*(ptOfScreenMovementEnd.x-ptOfScreenMovementStart.x),
							ptOfScreenMovementStart.y + lambda * (ptOfScreenMovementEnd.y - ptOfScreenMovementStart.y)					
					)
				}
			}
			
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].doAnimStep(dt)
			}			
		}
		
		protected function performSeldomActualization():void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].performSeldomActualization()
			}			
		}
		
		public function initProps(propsOb:Object):void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].initProps(propsOb)
			}			
		}
		
		public function finalize():void 
		{
			isActive = false;
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].finalize()
			}
			myModules.length = 0;
		}
		
		public function handleKeyboardEent(e:flash.events.KeyboardEvent):Boolean 
		{
			var res:Boolean = false;
			for (var i:int = 0; i < myModules.length;i++ ){
				res ||= myModules[i].handleKeyboardEent(e)
			}			
			return res
		}
		
		public function handleMouseWheel(e:flash.events.MouseEvent):Boolean 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].handleMouseWheel(e)
			}			
			return false;
		}
		
		public function react2NewVisualizationScale():void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].react2NewVisualizationScale()
			}			
		}
		
		public function react2NewVisualizationCoords():void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].react2NewVisualizationCoords()
			}			
		}
		
		public function animateScreenMovement2ShowPointAtCenter(cx:Number, cy:Number, tm:Number=1):void 
		{
			isAnimatingScreenMovement = true;
			animationMode = 0;
			ptOfScreenMovementStart = this.myWorld.visualization.getWorldPointAtScreenCenter();
			ptOfScreenMovementEnd.setTo(cx, cy);
			screenMovementTotalTime = tm;
			screenMovementElapsedTime = 0;			
		}
		
		public function animateScreenMovement2SetCoordsOfVisualization(cx:Number, cy:Number, tm:Number=1):void 
		{
			isAnimatingScreenMovement = true;
			animationMode = 1;
			ptOfScreenMovementStart.setTo(this.myWorld.visualization.x, this.myWorld.visualization.y);
			ptOfScreenMovementEnd.setTo(cx, cy);
			screenMovementTotalTime = tm;
			screenMovementElapsedTime = 0;			
		}
		
		public function react2Resize():void 
		{
			for (var i:int = 0; i < myModules.length;i++ ){
				myModules[i].react2Resize()
			}			
		}
	}

}