package gameplay.worlds.service 
{
	import com.junkbyte.console.Cc;
	import gameplay.worlds.World;
	import globals.StatsWrapper;
	/**
	 * ...
	 * @author ...
	 */
	public class TriggerController extends SavedWorldParamsController
	{
		private var completedTriggersUIDs:Array;
		private var triggers:Vector.<gameplay.worlds.service.Trigger>;
		
		public function TriggerController(w:World)  
		{
			super(w);
			this.triggers = new Vector.<Trigger>();
			this.completedTriggersUIDs=[];
		}
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			nxtId = Routines.saveArOfNumbers2Ar(this.completedTriggersUIDs, ar, nxtId);
			return nxtId;
		}
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			nxtId = Routines.loadArOfNumbersFromAr(this.completedTriggersUIDs, ar, nxtId);
			return nxtId;
		}		
		
		public function checkTriggers():void 
		{
			//Cc.log('Checking triggers: ',triggers.length)
			for (var i:int=this.triggers.length-1; i>=0; i--){
				var qq:Trigger = this.triggers[i];
				
				qq.checkCompletionCondition();
				
				if (qq.wasCompleted){
					this.completedTriggersUIDs.push(qq.uid);
					this.triggers.splice(i,1);
					//Cc.log('event ',qq.uid, 'triggers.length=',triggers.length);
					StatsWrapper.stats.logTextWithParams('trigger_completed', this.world.worldTypeId.toString()+"_"+qq.uid.toString(),2);
				}
			}
		}
		
		public function registerTriggerIfNew(propsObj:Object):void{
			if (this.completedTriggersUIDs.indexOf(propsObj.uid)==-1){
				this.registerTrigger(propsObj)
			}
		}
		
		public function clear():void 
		{
			this.triggers.length = 0;
		}
		
		public function isTriggerCompleted(uid:int):Boolean 
		{
			return (this.completedTriggersUIDs.indexOf(uid)!=-1)
		}
		
		private function registerTrigger(propsObj:Object):void 
		{
			var qq:Trigger = new Trigger(propsObj);
			this.triggers.push(qq);
			qq.controller = this;
		}
	}

}