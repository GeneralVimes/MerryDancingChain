package managers 
{
	import globals.controllers.PlayersDataController;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameOptionsController extends PlayersDataController 
	{
		private var options_names:Array = [];
		private var arOfOptions:Array = [];
		public function GameOptionsController() 
		{
			super();
			//вот тут опции выставляем какие нужно конкретной игре
			options_names = ["gameSpeed"]
			arOfOptions = [1]
		}
		
		public function getOptionValue(code:String, defVal:Number=0):Number{
			var id:int = options_names.indexOf(code);
			if (id !=-1){
				if (id<arOfOptions.length){
					return arOfOptions[id];
				}else{
					return defVal;
				}
			}else{
				return defVal;
			}
		}
		
		public function setOptionValue(code:String, val:Number):void{
			var id:int = options_names.indexOf(code);
			if (id!=-1){
				while (arOfOptions.length<=id){
					arOfOptions.push(0);
				}
				arOfOptions[id] = val;
			}
		}
		
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId)
			ar[nxtId + 0] = 0;	
			ar[nxtId + 1] = 0;	
			ar[nxtId + 2] = 0;	
			nxtId += 3;
			nxtId = Routines.saveArOfNumbers2Ar(arOfOptions, ar, nxtId);
			return nxtId+0;			
		}
		
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId)
			nxtId += 3;
			nxtId = Routines.loadArOfNumbersFromAr(arOfOptions, ar, nxtId);
			return nxtId;
		}		
	}

}