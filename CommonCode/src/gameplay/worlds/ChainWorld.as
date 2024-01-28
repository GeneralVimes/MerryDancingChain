package gameplay.worlds 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import gameplay.basics.BasicGameObject;
	import gameplay.descendants.ChainObject;
	import gameplay.descendants.ChainHuman;
	import gameplay.descendants.ChainTable;
	import gameplay.descendants.MovingChainObject;
	import gameplay.worlds.states.StandardState;
	import globals.SoundPlayer;
	import service.TouchInfo;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChainWorld extends World 
	{
		private var objects:Vector.<gameplay.basics.BasicGameObject>;
		private var stands:Vector.<gameplay.basics.BasicGameObject>;
		private var sortedObjects:Vector.<gameplay.basics.BasicGameObject>;
		public var mainOb:MovingChainObject
		public var tailOb:MovingChainObject
		
		public var obstaclesMap:Dictionary
		private var mapCellSide:int = 150;
		public function ChainWorld(wob:Object, sprBack:DisplayObjectContainer, visHolder:DisplayObjectContainer, sprFront:DisplayObjectContainer) 
		{
			super(wob, sprBack, visHolder, sprFront);
			objects = new Vector.<gameplay.basics.BasicGameObject>();
			vecs4Objects.push(objects)
			stands = new Vector.<gameplay.basics.BasicGameObject>();
			vecs4Objects.push(stands)
			obstaclesMap=new Dictionary()
			sortedObjects = new Vector.<gameplay.basics.BasicGameObject>();
		}
		override protected function findVecIdWhereClassIsStored(cl:Class):int 
		{
			if (cl == ChainHuman){
				return 0
			}else{
				return 1;
			}
			
		}
		override public function canLoadGameFromAr(ar:Array):int 
		{
			return 0
			//return super.canLoadGameFromAr(ar);
		}
		override public function createObjectOfClass(cl:Class, props:Array, canBRolledBack:Boolean = false):BasicGameObject 
		{
			var res:BasicGameObject = super.createObjectOfClass(cl, props, canBRolledBack);
			if (res is ChainObject){
				(res as ChainObject).sortedId = sortedObjects.length;
				sortedObjects.push(res)
				
			}
			if (res is ChainTable){
				var cell_x:int = Math.floor(Math.abs(res.x) / mapCellSide);
				var cell_y:int = Math.floor(Math.abs(res.y) / mapCellSide);
				var cN:int = 100 * cell_x + cell_y;
				if (!(cN in obstaclesMap)){
					obstaclesMap[cN] = [];
				}
				obstaclesMap[cN].push(res)
			}
			
			return res;
		}
		
		private function sortVisObjects():void{
			for (var i:int = 0; i < sortedObjects.length - 1; i++){
				for (var j:int = i+1; j < sortedObjects.length; j++){
					var ob1:ChainObject = sortedObjects[i] as ChainObject
					var ob2:ChainObject = sortedObjects[j] as ChainObject
					if (ob1.y > ob2.y){
						ob1.parent.swapChildren(ob1, ob2);
						sortedObjects[i] = ob2;
						sortedObjects[j] = ob1;
						ob1.sortedId=j
						ob2.sortedId=i
					}
					//if (ob1.parent == ob2.parent){
						
					//}
				}
			}
		}
		override protected function clearAllObjects():void 
		{
			super.clearAllObjects();
			sortedObjects.length = 0;
		}
		
		public function adjustDepth(ob1:ChainObject, deltaY:Number):void 
		{
			if (deltaY > 0){
				var i:int = ob1.sortedId;
				while (i+1 < sortedObjects.length){
					var ob2:ChainObject = sortedObjects[i+1] as ChainObject;
					if (ob2.y<ob1.y){
						ob1.parent.swapChildren(ob1, ob2);
						sortedObjects[i] = ob2;
						sortedObjects[i+1] = ob1;
						ob1.sortedId=i+1
						ob2.sortedId=i
					}else{
						break;
					}
					i++
				}
			}else{
				i = ob1.sortedId;
				while (i-1 >= 0){
					ob2 = sortedObjects[i-1] as ChainObject;
					if (ob2.y>ob1.y){
						ob1.parent.swapChildren(ob1, ob2);
						sortedObjects[i] = ob2;
						sortedObjects[i-1] = ob1;
						ob1.sortedId=i-1
						ob2.sortedId=i
					}else{
						break;
					}
					i--
				}
			}
		}
		
		override protected function doSomethingEverySecond():void 
		{
			super.doSomethingEverySecond();
			//sortVisObjects();
		}
		public function getCurrentTail():MovingChainObject 
		{
			return tailOb
		}
		
		public function getNumPeopleInChain():int 
		{
			var res:int = 0;
			for (var i:int = 0; i < objects.length; i++){
				var hum:ChainHuman = objects[i] as ChainHuman;
				if (hum.movingMode==1 ||hum.movingMode==3){
					res += 1;
				}
			}
			return res;
		}
		//moving from x0, y0 to tmpPt, and what to do if tmpPt is inside obstacle
		public function adjustMoveCoordIfInsideObstacle(x0:Number, y0:Number, tmpPt:flash.geom.Point):void 
		{
			var cell_x0:int = Math.floor(Math.abs(tmpPt.x) / mapCellSide);
			var cell_y0:int = Math.floor(Math.abs(tmpPt.y) / mapCellSide);
			for (var di:int =-1; di <= 1; di++){
				for (var dj:int =-1; dj <= 1; dj++){
					var cN:int = 100 * (cell_x0 + di) + (cell_y0 + dj);
					if (cN in obstaclesMap){
						var ar:Array = obstaclesMap[cN];
						for (var i:int = 0; i < ar.length; i++ ){
							var st:ChainTable = ar[i] as ChainTable;
							var d:Number = Routines.getDistBetweenPoints(st.x, st.y, tmpPt.x, tmpPt.y);
							if (d < st.r){
								if (d>0){
									//inside obstacle
									var dx:Number = tmpPt.x - st.x;
									var dy:Number = tmpPt.y - st.y;
									var coef:Number = st.r / d
									tmpPt.x = st.x + dx * coef;
									tmpPt.y = st.y + dy * coef;
									return						
								}
							}
						}						
					}
				}
			}

		}

		
		override protected function makeNormalFrameStep():void 
		{
			super.makeNormalFrameStep();
			var correspondingIngameTime:Number = timeController.getCorrespondingIngameTime();
			var realWorldTime:Number = timeController.getRealWorldTime();		
			for (var i:int = 0; i < objects.length; i++){
				var ob:MovingChainObject = objects[i] as MovingChainObject;
				ob.calcStateInMoment(correspondingIngameTime); 
				ob.actualizeVisuals();
			}
			
			this.visualization.showWorldPointAtScreenCenter(mainOb.x, mainOb.y);
		}

		override protected function createInitialObjects():void 
		{
			super.createInitialObjects();
			mainOb = this.createObjectOfClass(ChainHuman, [100, 100]) as ChainHuman;
			mainOb.movingMode = 1;
			tailOb = mainOb
			
			expandMaxShownRect("left", 1500);
			expandMaxShownRect("right", 1500);
			expandMaxShownRect("top", 1500);
			expandMaxShownRect("bottom", 1500);			
			
			
			for (var i:int = 0; i < 100; i++){
				this.createObjectOfClass(ChainHuman, [Routines.randomIntNumberFromToIncl(maxShownRect.left + 500, maxShownRect.right - 500), 
													Routines.randomIntNumberFromToIncl(maxShownRect.top+500, maxShownRect.bottom-500)]) as ChainHuman;
			}
			
			for (i = 0; i < 50; i++){
				var need1More:Boolean = true;
				var numTries:int = 0;
				while (need1More && numTries < 100){
					need1More = false
					numTries++;
					var cx:Number = Routines.randomIntNumberFromToIncl(maxShownRect.left , maxShownRect.right )
					var cy:Number = Routines.randomIntNumberFromToIncl(maxShownRect.top , maxShownRect.bottom )
					for (var j:int = 0; j < stands.length; j++){
						if (Routines.getDistBetweenPoints(cx,cy,stands[j].x, stands[j].y)<250){
							need1More=true
						}
					}
				}
				if (!need1More){
					this.createObjectOfClass(ChainTable, [cx, cy]) as ChainTable;
				}
				
			}			
			sortVisObjects();

			startState(StandardState, {})
			
		}
		override public function doRestart():void 
		{
			super.doRestart();
			startState(StandardState, {})
		}
	}

}