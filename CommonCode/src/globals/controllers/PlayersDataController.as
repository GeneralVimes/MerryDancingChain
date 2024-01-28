package globals.controllers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class PlayersDataController 
	{
		
		public function PlayersDataController() 
		{
			
		}
		public function save2Ar(ar:Array, nxtId:int):int 
		{
			ar[nxtId+0] = 0;		
			return nxtId+1;			
		}
		
		public function loadFromAr(ar:Array, nxtId:int):int 
		{
			return nxtId+1;
		}		
	}

}