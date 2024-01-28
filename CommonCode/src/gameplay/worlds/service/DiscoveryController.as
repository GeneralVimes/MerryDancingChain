package gameplay.worlds.service 
{
	import gameplay.worlds.World;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DiscoveryController extends SavedWorldParamsController 
	{
		
		public function DiscoveryController(w:World) 
		{
			super(w);
			
		}
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			ar[nxtId+0] = 0;
			ar[nxtId+1] = 0;
			ar[nxtId+2] = 0;
			ar[nxtId+3] = 0;
			ar[nxtId+4] = 0;
			return nxtId+5;
		}
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			return nxtId+5;
		}			
	}

}