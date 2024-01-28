package gameplay.worlds.service 
{
	import com.junkbyte.console.Cc;
	import gameplay.worlds.World;
	import globals.controllers.PurchaseObject;
	/**
	 * ...
	 * @author ...
	 */
	public class ArtifactsController extends SavedWorldParamsController
	{
		public var artifacts:Array=[];
		
		public function ArtifactsController(w:World)  
		{
			super(w);
		}
		
		public function initArtifactsAr(ar:Array):void{
			this.artifacts = ar;
			//we must right after a start check the actual purchases and actualize artifacts
			actualizeArtifactsFromPurchaser();
		}
		
		public function findArtifactOfUID(uid:int):ArtifactObject{
			var res:ArtifactObject = null;
			for (var i:int=0; i<this.artifacts.length; i++){
				if (this.artifacts[i].uid==uid){
					res = this.artifacts[i];
					break;
				}
			}
			return res;
		}
		
		public function findArtifactWhichGivesCurrency(currCode:String):ArtifactObject 
		{
			var res:ArtifactObject = null;
			var resId:int = findIdOfArtifactWhichGivesCurrency(currCode);
			if (resId!=-1){
				res = this.artifacts[resId];
			}
			return res;			
		}
		
		
		public function findIdOfArtifactWhichGivesCurrency(currCode:String):int 
		{
			var res:int = -1;
			for (var i:int = 0; i < this.artifacts.length; i++){
				var aft:ArtifactObject = this.artifacts[i];
				var purch:PurchaseObject = NewGameScreen.screen.purchaseController.findGoodyOfCode(aft.associatedPurchaseCode);
				if (purch){
					if (purch.getCurrencyValueInPurchase(currCode) > 0){
						res = i;
						break;
					}
				}
			}
			return res;				
		}		
		//public function purchaseArtifactOfUID(uid, currency):void{
		//var purchasedAFT=null;
		//for (var i=0; i<this.artifacts.length; i++){
		//if (this.artifacts[i].uid==uid){
		//this.artifacts[i].quantity++;
		//purchasedAFT = this.artifacts[i];
		//break
		//}
		//}
		//if(purchasedAFT){
		//if (currency=="bricks"){
		//this.myWorld.prestige-=purchasedAFT.bricksPrice;
		//}
		//if (currency=="science"){
		//this.myWorld.receiveResource("science", -purchasedAFT.sciencePrice);
		//}
		//}
        //
		//}

		public function countOwnedArtifacts():int{
			var res:int=0;
			for (var i:int=0; i<this.artifacts.length; i++){
				res += this.artifacts[i].quantity;
			}
			return res;
		}

		public function countArtifactsOfCode(cd:String):int{
			var res:int=0;
			for (var i:int=0; i<this.artifacts.length; i++){
				if (this.artifacts[i].code == cd){
					res = this.artifacts[i].quantity;
					break;
				}
			}
			return res;
		}
		
		public function actualizeArtifactsFromPurchaser():void 
		{
			NewGameScreen.screen.purchaseController.actualizePurchases();
			for (var i:int = 0; i < artifacts.length; i++ ){
				var aft:ArtifactObject = artifacts[i];
				
				var num:int = NewGameScreen.screen.purchaseController.countGoodiesOfCode(aft.associatedPurchaseCode);
				Cc.log('ArtifactObject:', aft.uid, "q=", aft.quantity, "num=", num);
				if (num > aft.quantity){
					aft.quantity = num;
				}
			}
		}
		

		public function consumeArtifactConnectdWithPurch(purch:globals.controllers.PurchaseObject):void 
		{
			Cc.log('consumeArtifactConnectdWithPurch');
			for (var i:int = 0; i < artifacts.length; i++ ){
				var aft:ArtifactObject = artifacts[i];
				if (purch.code==aft.associatedPurchaseCode){
					aft.quantity = purch.quantity;
					Cc.log("code:", purch.code, "quantity:", aft.quantity);
					break;
				}
			}
			
		}		
		
		public function buyArtifact(aft:gameplay.worlds.service.ArtifactObject):void 
		{
			if (aft.alternativeCurrency){
				var mon:Number = this.world.getResourceVal(aft.alternativeCurrency);
				if (mon >= aft.alternativeCurrencyPrice){
					this.world.receiveResource(aft.alternativeCurrency, -aft.alternativeCurrencyPrice);
					aft.quantity++;
				}
			}
		}
		
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			var id0:int = nxtId;
			nxtId++;
			
			var num:int = 0
			for (var i:int=0; i<this.artifacts.length; i++){
				var aft:ArtifactObject = this.artifacts[i];
				if (aft.quantity>0){
					num++;
					ar[nxtId] = aft.uid;
					ar[nxtId+1] = aft.quantity;
					nxtId += 2;
				}
			}
			ar[id0] = num;
			return nxtId;
		}
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			var num:int = ar[nxtId + 0];
			nxtId++;
			for (var i:int=0; i<num; i++){
				var uid:int = ar[nxtId+0];
				var qua:int = ar[nxtId+1];
				nxtId += 2;
				
				var aft:ArtifactObject = this.findArtifactOfUID(uid);
				if (aft){
					aft.quantity = qua;
				}
			}
			
			actualizeArtifactsFromPurchaser();
			
			return nxtId;
		}


		
		
	}
}