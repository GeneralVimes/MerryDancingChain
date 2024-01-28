package gameplay.worlds.service 
{
	import gameplay.worlds.World;
	/**
	 * ...
	 * @author ...
	 */
	public class SavedWorldParamsController 
	{
		protected var world:World
		public function SavedWorldParamsController(w:World) 
		{
			world = w;
		}
		
		public function save2Ar(ar:Array, nxtId:int):int{
			ar[nxtId + 0] = 0;
			return nxtId + 1;
		}
		
		public function loadFromAr(ar:Array, nxtId:int):int{
			return nxtId + 1;
		}
		
	}

}