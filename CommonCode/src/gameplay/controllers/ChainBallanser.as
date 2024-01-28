package gameplay.controllers 
{
	import gameplay.descendants.ChainHuman;
	import gameplay.descendants.ChainTable;
	/**
	 * ...
	 * @author ...
	 */
	public class ChainBallanser extends Ballanser 
	{
		
		public function ChainBallanser() 
		{
			super();
			
		}
		override protected function initEntities():void 
		{
			super.initEntities();

			entities = [
				{	cls:ChainHuman,	name:"TXID_MACH_NAME_PAROVOZ", desc:"TXID_MACH_DESC_PAROVOZ",	layers:[1,0]	},
				{	cls:ChainTable,	name:"TXID_MACH_NAME_PAROVOZ", desc:"TXID_MACH_DESC_PAROVOZ",	layers:[1]	}
				
			]
		}
		override public function getDeltaTillNextGift(giftId:int):Number 
		{
			return 999999999999999;
		}
	}

}