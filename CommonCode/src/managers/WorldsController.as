package managers 
{
	import gameplay.controllers.ChainBallanser;
	import gameplay.controllers.ChainPurchaser;
	import gameplay.visual.ChainHUD;
	import gameplay.worlds.ChainWorld;
	import globals.controllers.CurrencyObject;
	import globals.controllers.PurchaseObject;
	/**
	 * ...
	 * @author ...
	 */
	public class WorldsController 
	{
		public var globalGameName:String = "Game";//название игры переводить не будем
		public var gameDiscordChannel:String = '#game';

		public var worldData:Array;
		public var purchasesData:Array;
		public var consumableCurrencies:Array;
		public function WorldsController() 
		{
			worldData = [
				{
					id:31,
					skins:[
						{
							code:"31_standard",
							folder:"31",
							name:"TXID_CHAINSKIN_CLASSIC",
							numFiles:1
						}				
					],
					isLockedByDefault:false,
					defaultSkinId:1,
					cls:ChainWorld,
					hudCLS:ChainHUD,
					purchCLS:ChainPurchaser,
					balCLS:ChainBallanser,
					name:"TXID_WORLDNAME_CHAIN",
					desc:"TXID_WORLDDESC_CHAIN",
					discordIcon:":world_babel_tower:",
					frame:"wadd_WorldsIcons4new0013",//Чтобы потом Assets.manager.getTexture("wadd_WorldsIcons4new0011");//readjustSize();
					availableGiftCodes:[
					//	/*00*/{rewardType:'bonusTime', rewardValue:1000, notAvailable:true}//not used yet
					]
				}
			]
			
			
			purchasesData = [
				//new PurchaseObject({
				//	uid:1,
				//	code:"golden_pickaxe",
				//	name:"TXID_AFT_NAME_GPICKAXE",
				//	desc:"TXID_AFT_DESC_GPICKAXE",
				//	txtKey:"w011_artifactsSymbols4new0000",
				//	price:"$1.99",
				//	isUnlockable:true,
				//	providedCurrencies:[{code: "currency_ads_skips", value:42}]//- only for !Consumables
				//})

			]
			
			consumableCurrencies = [
				//new CurrencyObject({
				//	uid:0,
				//	code:"currency_ads_skips",
				//	name:"TXID_CURR_NAME_ADSSKIPS",
				//	desc:"TXID_CURR_DESC_ADSSKIPS"
				//})
			]			
		}
		
		public function isWorldUnlockedFromStart(wid:int):Boolean{
			var ob:Object = getObOfId(wid);
			var res:Boolean = true;
			if (ob){
				if (ob.hasOwnProperty("isLockedByDefault")){
					res = !ob["isLockedByDefault"]
				}
			}
			return res;
		}
		
		public function getObOfId(id:int):Object{
			var res:Object = null;
			for (var i:int = 0; i < worldData.length; i++ ){
				var ob:Object = worldData[i];
				if (ob.id == id){
					res = ob;
					break;
				}
			}
			return res;
		}
		public function getObOfIdRemainder(val:int, mod:int):Object{
			var res:Object = null;
			for (var i:int = 0; i < worldData.length; i++ ){
				var ob:Object = worldData[i];
				if (ob.id % mod == val % mod){
					res = ob;
					break;
				}
			}
			return res;			
		}
		
		public function getIdOfWorldSkin(wid:int, skinCode:String):int 
		{
			var res:int =-1;
			var skins:Array = worldData[wid].skins;
			for (var i:int = 0; i < skins.length; i++ ){
				if (skins[i].code == skinCode){
					res = i;
					break;
				}
			}
			return res;
		}		
	}

}