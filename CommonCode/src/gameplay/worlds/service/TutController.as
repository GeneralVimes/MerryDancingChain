package gameplay.worlds.service 
{
	import gameplay.basics.BasicGameObject;
	import gameplay.worlds.World;
	import gameplay.worlds.service.tut.MultiPhasedTutSprite;
	import gameplay.worlds.service.tut.TutorialSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class TutController 
	{
		private var myWorld:World
		private var activeTutorials:Vector.<gameplay.worlds.service.tut.TutorialSprite>;
		public function TutController(wrl:World) 
		{
			myWorld = wrl;
			this.activeTutorials = new Vector.<TutorialSprite>();
		}
		
		public function doAnimStep(dt:Number):void 
		{
			for (var i:int=this.activeTutorials.length-1; i>=0; i--){
				var tut:TutorialSprite = this.activeTutorials[i];
				tut.doAnimStep(dt)
				if (tut.wasPerformed){
					tut.getRemoved();
					this.activeTutorials.splice(i,1)
				}
			}			
		}
		
		public function hasActiveTutorial():Boolean{
			return this.activeTutorials.length>0;
		}
		public function createMultiPhasedTutor(funcsPhases:Array,funcsNext:Array, funcsPrev:Array, paramOb:Object=null, fParamsNext:Array=null, fCallersNext:Array=null, fParamsPrev:Array=null, fCallersPrev:Array=null):MultiPhasedTutSprite{
			var tut:MultiPhasedTutSprite = new MultiPhasedTutSprite(this.myWorld, funcsPhases, funcsNext, funcsPrev, paramOb, fParamsNext, fCallersNext, fParamsPrev, fCallersPrev);
			this.activeTutorials.push(tut);
			return tut;
		}
		
		public function createTutor(tutCls:Class, tutOb:BasicGameObject, tutCompFunc:Function,tutCompParams:Array=null,tutCompCaller:*=null, tutParamObj:Object=null):TutorialSprite{
			var tut:TutorialSprite = new tutCls(this.myWorld, this.myWorld.visualization.getLayerOfId(myWorld.visualization.layersAr.length-1),tutOb, tutCompFunc,tutCompParams,tutCompCaller, tutParamObj);
			this.activeTutorials.push(tut);
			return tut;
		}	
		
		public function createTutorOnHUD(tutCls:Class, tutCompFunc:Function,tutCompParams:Array=null,tutCompCaller:*=null, tutParamObj:Object=null):TutorialSprite{
			var tut:TutorialSprite = new tutCls(this.myWorld, this.myWorld.hud.parSpr,null, tutCompFunc,tutCompParams,tutCompCaller, tutParamObj);
			this.activeTutorials.push(tut);
			return tut;
		}		
		
		public function clear():void 
		{
			for (var i:int = this.activeTutorials.length - 1; i >= 0; i--){
				this.activeTutorials[i].getRemoved();
			}
			this.activeTutorials.length = 0;
		}
	}

}