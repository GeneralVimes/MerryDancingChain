package gameplay.descendants 
{
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class ChainTable extends ChainObject 
	{
		public var r:Number = 100;
		public function ChainTable() 
		{
			super();
			
		}
		override public function initVisuals():void 
		{
			super.initVisuals();
			var id:int = Routines.getRandomIndexFromWeightedAr([20,10,5])
			var cd:String = ["TEX_LEMONADETABLE","TEX_PIZZATABLE","TEX_LEMONTREE"][id]
			
			var im:Image = Routines.buildImageFromTexture(Assets.allTextures[cd], this, 0, 0, null);
			
		}
	}

}