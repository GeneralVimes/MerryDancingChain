package managers 
{
	import globals.PlayersAccount;
	import globals.controllers.PlayersDataController;
	/**
	 * ...
	 * @author ...
	 */
	public class ContentAvailabilityController extends PlayersDataController
	{
		
		public function ContentAvailabilityController() 
		{
			
		}
		
		//будут сецифичные для игры функции для проверки, открыл ли тот или иной контент
		
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId)
			ar[nxtId+0] = 0;		
			return nxtId+1;			
		}
		
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId)
			return nxtId+1;
		}				
	}

}