package gameplay.worlds.service 
{
	import gameplay.worlds.World;
	import globals.PlayersAccount;
	import globals.Translator;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CodeBonusesController extends SavedWorldParamsController 
	{
		private var usedCodes:Array = [];
		private var alphabet:String = Translator.translator.alphabet4Gifts;
		private var availableGiftsArray:Array = [];
		public function CodeBonusesController(w:World) 
		{
			super(w);
			this.initParamsFromCurrentWorld();
		}
		
		private function initParamsFromCurrentWorld():void 
		{
			var ob:Object = NewGameScreen.screen.worldsController.getObOfId(this.world.worldTypeId);
			if (ob){
				if (ob.hasOwnProperty("availableGiftCodes")){
					availableGiftsArray = ob.availableGiftCodes;
				}
			}

		}
		
		public function handleCodeChecking(cd:String):String{
			var resObj:Object = checkCode(cd);
			
			var res:String = 'OK';
			if (resObj.resultCode != 0){
				res = informOfCodeError(resObj);
			}
			return res;
		}
		
		private function checkCode(cd:String):Object 
		{
			var resObj:Object = {resultCode:0, additionalData:0};
			cd = cd.toUpperCase();
			while (cd.indexOf("0") !=-1){
				cd = cd.replace("0", "O");
			}
			var isValid:Boolean = true;
			for (var i:int = 0; i < cd.length; i++ ){
				if (alphabet.indexOf(cd.charAt(i)) ==-1){
					isValid = false;
					break;
				}
			}
			if (!isValid){
				resObj.resultCode = 1; //must be only numbers and capital letters
				
				return resObj;
			}	
			
			var num:uint = Routines.decodeCode(cd, alphabet);
		
			var num0:uint = num;
			
			var wasUsed:Boolean = false;
			for (i = 0; i < usedCodes.length; i++ ){
				if (usedCodes[i] == num){
					wasUsed = true;
					break;
				}
			}
			if (wasUsed){
				resObj.resultCode = 5;//already used
				return resObj;
			}	
			
			//макс uint 4294967295
			
			//миров - 101 (мир 903 это будет мир 95)
			//бонусов - 307
			//дат 31*12+5 запасных 379 (чтобы было простое число)
			//остаток 365
			//для адресности остаток>1000 (в идеале >10000)
			
			//миров 61 (ну и пусть что будут коллизии)
			//дат: 107, это номер недель и сдвинутых недель + 1 для неограниченного срока
			//подарков 61?
			//398147
			//остаётся 10787для адресности
			//если от 0 до 9999 - это адресный подарок, а если 10000 до 10787 - это всем
			
			
			
			var worldId:uint = num % 61;
			num = Math.floor(num / 61);
			var dateId:uint = num % 107;
			num = Math.floor(num / 107);
			var giftId:uint = num % 61;//61 разных гифтов достаточно?	
			num = Math.floor(num / 61);
			var receiverId:int = num;
			
			
			if (world.worldTypeId%61==worldId){//мир тот, что нужно
				if (dateId == 106){//always available
					var isDateOK:Boolean = true;
				}else{
					trace('dateId=', dateId);
					var dtNow:Date = new Date();//today
					var nowDate:int = dtNow.getDate()//1..31
					var nowMonth:int = dtNow.getMonth()//0..11
					var nowYear:int = dtNow.getFullYear();//2019+
					
					var yearStart:Date = new Date(nowYear, 0, 1, 0, 0, 0, 0);
					if (dateId%2==0){
						yearStart.date+= Math.floor(dateId/2) * 7;
					}else{
						yearStart.date+= 3 + Math.floor(dateId / 2) * 7;
					}
					trace('yearStart=',yearStart)
					
					
					var dayId:int = yearStart.date;
					var monthId:int = yearStart.month;
					
					isDateOK = false;								
					//var dt0:Date = new Date(2019, 8, 17, 0, 0, 0, 0);
					var dt1:Date = new Date(nowYear, monthId, dayId, 0, 0, 0, 0);
					var dt2:Date = new Date(nowYear-1, monthId, dayId, 0, 0, 0, 0);
					var dt3:Date = new Date(nowYear+1, monthId, dayId, 0, 0, 0, 0);
					
					//разница в секундах между сейчас и когда надо
					var delta1:Number = (dtNow.getTime() - dt1.getTime()) / 1000;
					var delta2:Number = (dtNow.getTime() - dt2.getTime()) / 1000;
					var delta3:Number = (dtNow.getTime() - dt3.getTime()) / 1000;
					
					if ((Math.abs(delta1) < 3600 * 24 * 4)||(Math.abs(delta2) < 3600 * 24 * 4)||(Math.abs(delta3) < 3600 * 24 * 4)){
						isDateOK = true;
					}else{
						isDateOK = false;
					}								
				}
				
				if (isDateOK){//дата та, что нужна
					if (receiverId>=10000){//код для всех
						resObj.resultCode = 0;
					}else{
						if (PlayersAccount.account.isCurrentPlayersCodeEqualTo(receiverId)){
							resObj.resultCode = 0;
						}else{
							resObj.resultCode = 7;//wrong receiver
						}
					}
					
				}else{
					resObj.resultCode = 4;//wrong date
				}				
			}else{//мир не тот
				resObj.resultCode = 2;//wrong world
				resObj.additionalData = worldId;
			}
			
			if (resObj.resultCode == 0){
				if (giftId<availableGiftsArray.length){
					var giftOb:Object = availableGiftsArray[giftId];
					if (giftOb.hasOwnProperty("notAvailable")){
						if (giftOb.notAvailable){
							resObj.resultCode = 3;//wrong version
						}
					}
					if (resObj.resultCode == 0){
						if (!world.willRewardHaveEffect(giftOb)){
							resObj.resultCode = 6;//world not ready
						}else{
							
							
							world.giveReward(giftOb, true);
							usedCodes.push(num0);
						}						
					}
				}else{
					resObj.resultCode = 3;//wrong version
				}
			}
			
			return resObj;
		}
		
		private function informOfCodeError(ob:Object):String 
		{
			var resCode:int = ob.resultCode;
			var res:String = 'Error';
			switch (resCode){
				case 1:{
					//trace('wrong symbols')
					res="TXID_CODEERR_ONLYNUMBERS"
					break;
				}
				case 2:{
					res = "TXID_CODEERR_WRONGWORLD";
					var wob:Object = NewGameScreen.screen.worldsController.getObOfIdRemainder(ob.additionalData, 61)
					
					if (wob){
						res += " TXID_CODEERR_MAYBEWOLD " + wob.name;
					}
					//trace('wrong world, must be:')
					break;
				}
				case 3:{
					res="TXID_CODEERR_WRONGVERSION"
					//trace('wrong version, must be:')
					break;
				}
				case 4:{
					res = "TXID_CODEERR_EXPIRED"
					//trace('wrong date, must be:')
					break;
				}
				case 5:{
					res = "TXID_CODEERR_ALREADYUSED";//а что если использовал год назад ровно?
					//trace('already used')
					break;
				}
				case 6:{
					res = "TXID_CODEERR_NOEFFECT";//код верен, но эффекта при текущем сетапе не даст
					//trace('no effect')
					break;
				}
				case 7:{
					res = "TXID_CODEERR_WRONGPLAYER";//это адресный код для конкретного игрока
					//trace('no effect')
					break;
				}
			}
			return res;
		}
																		//при -1 генерируем на всё время
		public function buildCodeForBonus(giftId:int, receiverId:int=-1, deltaDaysFromNow:int=0):String{
			var num:uint = 0;
			if (receiverId==-1){
				receiverId = Math.floor(10000 + Math.random() * 700);
			}else{
				receiverId %= 10000;
			}
			num = receiverId
			num *= 61;
			num += giftId;
			num *= 107;
			if (deltaDaysFromNow==-1){
				var dateId:int = 106;
			}else{
				var dtNow:Date = new Date();//today
				dtNow.date+= deltaDaysFromNow;
				var nowDate:int = dtNow.getDate()//1..31
				var nowMonth:int = dtNow.getMonth()//0..11
				var nowYear:int = dtNow.getFullYear();//2019+
				
				var yearStart:Date = new Date(nowYear, 0, 1, 0, 0, 0, 0);
				//разница в днях между сейчас и когда надо
				var daysDelta:int = (dtNow.getTime() - yearStart.getTime()) / (1000 * 3600 * 24);
				var weekShift:int = daysDelta % 7;
				if (weekShift>=3){
					var weekId:int = Math.floor((daysDelta - 3) / 7);
					dateId = 1;
				}else{
					weekId = Math.floor(daysDelta / 7);
					dateId = 0;
				}
				dateId += weekId * 2;
			}
			num += dateId;
			
			num *= 61;
			num += world.worldTypeId % 61;
			
			var num0:uint = num;
			
			var str:String = Routines.encodeCode(num, alphabet)
			
			var giftOb:Object = availableGiftsArray[giftId];
			var explanationStr:String = 'TXID_CODE_CODE **'+str+'**: ';
			explanationStr += world.buildRewardInfo(giftOb);
			explanationStr += ' TXID_CODE_WORLD '+world.getMyName()+' '+world.getMyDiscordIcon()+' '+NewGameScreen.screen.worldsController.gameDiscordChannel;
			if (dateId==106){
				explanationStr+=' TXID_CODE_VALIDINF'
			}else{
				explanationStr += ' TXID_CODE_VALIDFROM '
				yearStart = new Date(nowYear, 0, 1, 0, 0, 0, 0);
				if (dateId%2==0){
					yearStart.date+= Math.floor(dateId/2) * 7;
				}else{
					yearStart.date+= 3 + Math.floor(dateId / 2) * 7;
				}
				yearStart.date-= 3;
				explanationStr +=yearStart.toDateString();
				yearStart.date+= 6;
				explanationStr +=' TXID_CODE_TILL '+yearStart.toDateString();
			}
			if (receiverId>=10000){
				explanationStr+=' TXID_CODE_FOREVERYONE '
			}else{
				explanationStr += ' TXID_CODE_FORPLAYER ' + receiverId.toString();
			}
			
			trace(Translator.translator.getLocalizedVersionOfText(explanationStr));
			
			return explanationStr;
		}
		
		override public function save2Ar(ar:Array, nxtId:int):int 
		{
			nxtId = super.save2Ar(ar, nxtId);
			ar[nxtId + 0] = 0;
			ar[nxtId + 1] = 0;
			ar[nxtId + 2] = 0;
			ar[nxtId + 3] = 0;
			//ar[nxtId + 4] = 0;
			nxtId = Routines.saveArOfNumbers2Ar(usedCodes,ar,nxtId+4)
			return nxtId;
		}
		override public function loadFromAr(ar:Array, nxtId:int):int 
		{
			nxtId = super.loadFromAr(ar, nxtId);
			
			if (PlayersAccount.account.currentlyLoadedIntSaveVersion>=2){
				nxtId = Routines.loadArOfNumbersFromAr(usedCodes,ar,nxtId+4)
			}else{
				nxtId = nxtId + 5;
			}
			//nxtId = Routines.loadArOfNumbersFromAr(usedCodes,ar,nxtId+4)
			return nxtId;
		}			
		
		public function generateNewCodes():void 
		{
			for (var i:int = 0; i < this.availableGiftsArray.length; i++ ){
				buildCodeForBonus(i,-1,3);
			}
			
			for (i = 0; i < 3; i++ ){
				buildCodeForBonus(Math.floor(Math.random() * this.availableGiftsArray.length), -1, 3);
			}			
			//buildCodeForBonus(1);
			//buildCodeForBonus(4,-1,0);
			//buildCodeForBonus(4,-1,1);
			//buildCodeForBonus(4,-1,2);
			//buildCodeForBonus(4,-1,3);
			//buildCodeForBonus(23,-1,-1);
			//buildCodeForBonus(16,-1,-1);
			//buildCodeForBonus(2,-1,4);
			//buildCodeForBonus(14,-1,4);
			//buildCodeForBonus(18,-1,4);
			//buildCodeForBonus(4,-1,5);
			//buildCodeForBonus(4,-1,6);
			//buildCodeForBonus(4,-1,7);
			//buildCodeForBonus(4,-1,8);
					
		}
	}

}