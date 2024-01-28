package gameplay.worlds.service 
{
	import gameplay.worlds.World;
	
	/**
	 * ...
	 * @author General
	 */
	public class NumPurchasesController extends SavedWorldParamsController 
	{
		public var numPurchasesByPurchIds:Array = [];//{id:int, num:int}
		public function NumPurchasesController(w:World) 
		{
			super(w);
			
		}
		
		public function getNextNumberOfPurchase4PurchaseId(id:int):int{
			var res:int = 0;
			var ar:Array = [];
			for (var i:int = 0; i < numPurchasesByPurchIds.length; i++ ){
				var ob:Object = numPurchasesByPurchIds[i];
				if (ob.id==id){
					ar[ob.num] = 1;
				}
			}
			
			for (i = 0; i < ar.length + 1; i++ ){
				if (ar[i]!=1){
					res = i;
					break;
				}
			}
			
			return res;
		}
		
		public function registerPurchaseOfIdAndNumber(id:int, num:int):void{
			if (getObIdOfIdAndNumber(id, num)==-1){
				numPurchasesByPurchIds.push({id:id, num:num})
			}
		}
		public function unRegisterPurchaseOfIdAndNumber(id:int, num:int):void{
			var arId:int = getObIdOfIdAndNumber(id, num);
			if (arId!=-1){
				numPurchasesByPurchIds.splice(arId, 1);
			}
		}
		
		private function getObIdOfIdAndNumber(id:int, num:int):int
		{
			var res:int =-1;
			for (var i:int = 0; i < numPurchasesByPurchIds.length; i++ ){
				var ob:Object = numPurchasesByPurchIds[i];
				if ((ob.id == id)&&(ob.num == num)){
					res = i;
					break;
				}
			}
			return res;
		}
		
		public function clear():void{
			numPurchasesByPurchIds.length = 0;
		}
		
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			var len:int = numPurchasesByPurchIds.length;
			ar[nxtId + 0] = len;
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				var ob:Object = numPurchasesByPurchIds[i];
				ar[nxtId + 0] = ob.id;
				ar[nxtId + 1] = ob.num;
				nxtId += 2;
			}
			return nxtId;
		}
		
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			var len:int = ar[nxtId + 0];
			nxtId++;
			numPurchasesByPurchIds.length = 0;
			for (var i:int = 0; i < len; i++ ){
				numPurchasesByPurchIds.push({id:ar[nxtId + 0], num:ar[nxtId + 1]})
				nxtId += 2;
			}
			return nxtId;			
		}
	}

}