package globals.controllers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerRankController extends PlayersDataController 
	{
		
		public function PlayerRankController() 
		{
			
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
			return super.loadFromAr(ar, nxtId)+5;
		}		
	}

}