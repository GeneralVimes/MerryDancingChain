package gameplay.descendants 
{
	import flash.geom.Point;
	import gameplay.worlds.ChainWorld;
	import globals.SoundPlayer;
	/**
	 * ...
	 * @author ...
	 */
	public class MovingChainObject extends ChainObject 
	{
		public var movingMode:int = 0//0 - just staying, 1 - tail, 2 - chasing tail which is visible, 3 - midboby
		private var movingAim:MovingChainObject
		
		private var targetX:Number = 0
		private var targetY:Number = 0
		
		private var course:Number=0
		private var targetCourse:Number=0
		private var changeCourseSpeed:Number = 10
		
		private var speed:Number=0
		private var targetSpeed:Number=0
		private var changeSpeedSpeed:Number = 1500	
		
		private var tmpPt:Point=new Point()
		public function MovingChainObject() 
		{
			super();
			movingMode = 0;
			movingAim = null;			
		}
		override public function initProperties(ar:Array):int 
		{
			var nxtId:int = super.initProperties(ar);
			targetX = this.x;
			targetY = this.y;
			return nxtId
		}
		override public function calcStateInMoment(mt:Number):void 
		{
			super.calcStateInMoment(mt);
			//timePassedSinceLastCheck
			var d:Number = Routines.getDistBetweenPoints(this.x, this.y, this.targetX, this.targetY);
			var maxSpeed:Number = 350;
			
			var breakingDist:Number = this.speed * this.speed / this.changeSpeedSpeed / 2;
			if (d <= breakingDist+50){
				targetSpeed=0
			}else{
				targetSpeed = maxSpeed;
			}
			
			//if (movingMode == 0){
				//targetSpeed = 0;
			//}
			
			if (speed!=targetSpeed){
				var maxChange:Number = timePassedSinceLastCheck * changeSpeedSpeed
				var delta:Number = targetSpeed - speed;
				if (maxChange >= Math.abs(delta)){
					speed=targetSpeed
				}else{
					speed += maxChange * ((delta > 0)?1: -1);
				}
			}		
			var dx:Number = targetX - x
			var dy:Number = targetY - y
			if (dx!=0 || dy!=0){
				targetCourse = Math.atan2(dx, -dy)
			}else{
				targetCourse = course;
			}
			
			
			//if (movingMode == 0){
				//targetCourse = course;
			//}
			
			if (course!=targetCourse){
				maxChange = timePassedSinceLastCheck * changeCourseSpeed
				delta = targetCourse - course;
				if (delta > Math.PI){
					delta-=2*Math.PI
				}
				if (delta < -Math.PI){
					delta+=2*Math.PI
				}
				
				if (maxChange >= Math.abs(delta)){
					course=targetCourse
				}else{
					course += maxChange * ((delta > 0)?1: -1);
				}
			}
			
			var vx:Number = speed * Math.sin(course);
			var vy:Number = -speed * Math.cos(course);
			tmpPt.setTo(this.x + vx * timePassedSinceLastCheck, this.y + vy * timePassedSinceLastCheck)
			this.myChainWorld.adjustMoveCoordIfInsideObstacle(this.x, this.y, tmpPt);
			
			this.changePos(tmpPt.x, tmpPt.y)
			
			
			//this.rotation = this.course;
			if ((this.course>=0) && (this.course<Math.PI)){
				this.scaleX=1
			}else{
				this.scaleX=-1
			}
			
			if ((movingMode == 1) || (movingMode == 2) || (movingMode == 3)){
				if (movingAim){
					targetX = movingAim.x;
					targetY = movingAim.y;	
					
					if (movingMode == 2){
						if (movingAim.movingMode!=1){
							movingMode=0;
							movingAim = null;
						}else{
							d = Routines.getDistBetweenPoints(this.x, this.y, movingAim.x, movingAim.y);
							
							if (d>250){
								movingAim = null;
								movingMode = 0;
							}
							if (d < 50){
								movingAim.movingMode = 3;
								movingMode = 1;
								myChainWorld.tailOb = this;
								SoundPlayer.player.playNewSound("idea",3);
								if (myChainWorld.getNumPeopleInChain()==101){
									myChainWorld.showMessage("Victory!!!", "Now everyone is dancing in the chain and having fun", ["OK"]);
								}
							}
						}
					}
				}
			}
			if (movingMode==0){
				var tlOb:MovingChainObject = this.myChainWorld.getCurrentTail();
				if (tlOb){
					d = Routines.getDistBetweenPoints(this.x, this.y, tlOb.x, tlOb.y);
					if (d < 150){
						movingAim = tlOb;
						movingMode = 2;
					}
				}
			}
			
			if (movingMode == 0){
				if (speed == 0){
					if (Math.random()<0.001){
						var tx:Number = this.x + Math.random() * 500 - 250
						var ty:Number = this.y + Math.random() * 500 - 250
						if (tx > myWorld.getMostLeftCoord() + 500 && tx < myWorld.getMostRightCoord() - 500 && 
								ty>myWorld.getMostTopCoord()+500 && ty<myWorld.getMostBotCoord()-500){
									setMovingAim(tx, ty)
								}
					}
				}else{
					if (Math.random() < 0.001){//щоб не застрягало
						setMovingAim(this.x, this.y)
					}
				}
			}
			
			
			if (speed == 0){
				stopWalkinAnimations()
			}else{
				startWalkingAnimations()
			}
		}
		protected function startWalkingAnimations():void 
		{
			
		}
		
		protected function stopWalkinAnimations():void 
		{
			
		}
		public function setMovingAim(wx:Number, wy:Number):void 
		{
			targetX = wx;
			targetY = wy;
		}			
	}

}