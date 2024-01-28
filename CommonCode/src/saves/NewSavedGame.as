package saves 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import globals.PlayersAccount;
	/**
	 * ...
	 * @author ...
	 */
	public class NewSavedGame 
	{
		//весь мир пишем в один массив
		//public var generalParams:Array;
		public var bigSaveAr1:Array;
		public var bigSaveAr2:Array;
		public var bigSaveAr3:Array;
		public var bigSaveAr4:Array;
		public var bigSaveAr5:Array;
		public var bigSaveAr6:Array;
		public var bigSaveAr7:Array;
		public var bigSaveAr8:Array;
		public var bigSaveAr9:Array;
		public var bigSaveAr0:Array;
		
		public var saveVersion1:String;
		public var saveVersion2:String;
		public var saveVersion3:String;
		public var saveVersion4:String;
		public var saveVersion5:String;
		public var saveVersion6:String;
		public var saveVersion7:String;
		public var saveVersion8:String;
		public var saveVersion9:String;
		public var saveVersion0:String;
		public var defaultLoadedWorldId:int = 0;
		public var initializedArrays:Array;
		public function NewSavedGame(src:Object) 
		{
			//generalParams = [];
			
			bigSaveAr1 = [];
			bigSaveAr2 = [];
			bigSaveAr3 = [];
			bigSaveAr4 = [];
			bigSaveAr5 = [];
			bigSaveAr6 = [];
			bigSaveAr7 = [];
			bigSaveAr8 = [];
			bigSaveAr9 = [];
			bigSaveAr0 = [];
			
			initializedArrays = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			
			if (src) {
				saveVersion1 = src.saveVersion1;
				saveVersion2 = src.saveVersion2;
				saveVersion3 = src.saveVersion3;
				saveVersion4 = src.saveVersion4;
				saveVersion5 = src.saveVersion5;
				saveVersion6 = src.saveVersion6;
				saveVersion7 = src.saveVersion7;
				saveVersion8 = src.saveVersion8;
				saveVersion9 = src.saveVersion9;
				saveVersion0 = src.saveVersion0;
				defaultLoadedWorldId = src.defaultLoadedWorldId;
				initializedArrays = src.initializedArrays.slice();
				
				//generalParams = src.generalParams.slice();
				
				bigSaveAr1 = src.bigSaveAr1.slice();
				bigSaveAr2 = src.bigSaveAr2.slice();
				bigSaveAr3 = src.bigSaveAr3.slice();
				bigSaveAr4 = src.bigSaveAr4.slice();
				bigSaveAr5 = src.bigSaveAr5.slice();
				bigSaveAr6 = src.bigSaveAr6.slice();
				bigSaveAr7 = src.bigSaveAr7.slice();
				bigSaveAr8 = src.bigSaveAr8.slice();
				bigSaveAr9 = src.bigSaveAr9.slice();
				bigSaveAr0 = src.bigSaveAr0.slice();
			}
		}
		
		public function replicate2Object(dsc:Object):void {
			dsc.saveVersion1 = saveVersion1;
			dsc.saveVersion2 = saveVersion2;
			dsc.saveVersion3 = saveVersion3;
			dsc.saveVersion4 = saveVersion4;
			dsc.saveVersion5 = saveVersion5;
			dsc.saveVersion6 = saveVersion6;
			dsc.saveVersion7 = saveVersion7;
			dsc.saveVersion8 = saveVersion8;
			dsc.saveVersion9 = saveVersion9;
			dsc.saveVersion0 = saveVersion0;
			dsc.defaultLoadedWorldId = defaultLoadedWorldId;
			if (dsc.initializedArrays){dsc.initializedArrays.length = 0}else{dsc.initializedArrays = []}
			//if (dsc.generalParams){dsc.generalParams.length = 0}else{dsc.generalParams = []}
			if (dsc.bigSaveAr1){dsc.bigSaveAr1.length = 0}else{dsc.bigSaveAr1 = []}
			if (dsc.bigSaveAr2){dsc.bigSaveAr2.length = 0}else{dsc.bigSaveAr2 = []}
			if (dsc.bigSaveAr3){dsc.bigSaveAr3.length = 0}else{dsc.bigSaveAr3 = []}
			if (dsc.bigSaveAr4){dsc.bigSaveAr4.length = 0}else{dsc.bigSaveAr4 = []}
			if (dsc.bigSaveAr5){dsc.bigSaveAr5.length = 0}else{dsc.bigSaveAr5 = []}
			if (dsc.bigSaveAr6){dsc.bigSaveAr6.length = 0}else{dsc.bigSaveAr6 = []}
			if (dsc.bigSaveAr7){dsc.bigSaveAr7.length = 0}else{dsc.bigSaveAr7 = []}
			if (dsc.bigSaveAr8){dsc.bigSaveAr8.length = 0}else{dsc.bigSaveAr8 = []}
			if (dsc.bigSaveAr9){dsc.bigSaveAr9.length = 0}else{dsc.bigSaveAr9 = []}
			if (dsc.bigSaveAr0){dsc.bigSaveAr0.length = 0}else{dsc.bigSaveAr0 = []}
			
			var myArs:Array = [
				initializedArrays,
				//generalParams,
				bigSaveAr1,
				bigSaveAr2,
				bigSaveAr3,
				bigSaveAr4,
				bigSaveAr5,
				bigSaveAr6,
				bigSaveAr7,
				bigSaveAr8,
				bigSaveAr9,
				bigSaveAr0
			]
			var dscArs:Array = [
				dsc.initializedArrays,
				//dsc.generalParams,
				dsc.bigSaveAr1,
				dsc.bigSaveAr2,
				dsc.bigSaveAr3,
				dsc.bigSaveAr4,
				dsc.bigSaveAr5,
				dsc.bigSaveAr6,
				dsc.bigSaveAr7,
				dsc.bigSaveAr8,
				dsc.bigSaveAr9,
				dsc.bigSaveAr0
			]
			for (var i:int = 0; i < myArs.length; i++){
				var mar1:Array = myArs[i];
				var dar1:Array = dscArs[i];
				for (var j:int = 0; j < mar1.length; j++ ){
					dar1.push(mar1[j]);
				}
			}
		}
		
		public function clearSave(sid:int):void 
		{
			initializedArrays[sid%10] = 0;
			switch (sid%10){
				case 0:{if (bigSaveAr0){bigSaveAr0.length = 0; }else{bigSaveAr0 = []; }break; }
				case 1:{if (bigSaveAr1){bigSaveAr1.length = 0; }else{bigSaveAr1 = []; }break; }
				case 2:{if (bigSaveAr2){bigSaveAr2.length = 0; }else{bigSaveAr2 = []; }break; }
				case 3:{if (bigSaveAr3){bigSaveAr3.length = 0; }else{bigSaveAr3 = []; }break; }
				case 4:{if (bigSaveAr4){bigSaveAr4.length = 0; }else{bigSaveAr4 = []; }break; }
				case 5:{if (bigSaveAr5){bigSaveAr5.length = 0; }else{bigSaveAr5 = []; }break; }
				case 6:{if (bigSaveAr6){bigSaveAr6.length = 0; }else{bigSaveAr6 = []; }break; }
				case 7:{if (bigSaveAr7){bigSaveAr7.length = 0; }else{bigSaveAr7 = []; }break; }
				case 8:{if (bigSaveAr8){bigSaveAr8.length = 0; }else{bigSaveAr8 = []; }break; }
				case 9:{if (bigSaveAr9){bigSaveAr9.length = 0; }else{bigSaveAr9 = []; }break; }
			}
		}
		
		//public function importFromBMD(bmd:BitmapData):void{
		//	trace('importFrom2BMD');
		//	var numPixels:uint = bmd.getPixel(0, 0);
		//	var x0:int = 1;
		//	var y0:int = 0;
		//	var bar:ByteArray = new ByteArray();
		//	for (var i:int = 0; i < numPixels; i++ ){
		//		var b:int = bmd.getPixel(x0, y0) - 128;
		//		bar.writeByte(b);
		//		
		//		x0++;
		//		if (x0 >= bmd.width){
		//			x0 = 0;
		//			y0++;
		//		}
		//	}
		//	
		//	//var numAr:Array = [];
		//	bigSaveAr0.length = 0;
		//	bar.position = 0;
		//	for (i = 0; i < numPixels/8; i++){
		//		var n:Number = bar.readDouble();
		//		bigSaveAr0.push(n);
		//	}
		//	//trace(numAr);
		//}
		//
		//public function export2BMD():BitmapData{
		//	trace('export2BMD');
		//	trace(bigSaveAr0);
		//	var bar:ByteArray = new ByteArray();
		//	for (var i:int = 0; i < bigSaveAr0.length; i++ ){
		//		bar.writeDouble(bigSaveAr0[i]);
		//	}
		//	//if (needCompress){
		//		//bar.compress();
		//	//}
		//	
		//	var numDoubles:int = bigSaveAr0.length;
		//	
		//	bar.position = 0;
		//	trace('bar.bytesAvailable:', bar.bytesAvailable);
		//	trace('numDoubles:', numDoubles);
		//	
		//	var numPixels:uint = numDoubles*8;
		//	var side:int = Math.ceil(Math.sqrt(numPixels + 1));
		//	
		//	var bmd:BitmapData = new BitmapData(side, side, false, 0);
		//	bmd.lock();
		//	bmd.setPixel(0, 0, numPixels);
		//	var x0:int = 1;
		//	var y0:int = 0;
		//	for (i = 0; i < numPixels; i++ ){
		//		//var n:uint = bar.readUnsignedInt();
		//		var n:uint = bar.readByte()+128;
		//		//trace('setting ',n)
		//		bmd.setPixel(x0, y0, n);
		//		x0++;
		//		if (x0 >= side){
		//			x0 = 0;
		//			y0++;
		//		}
		//	}
		//	bmd.unlock();
		//	return bmd;
		//}
		
		
		//public function importWorldSaveFromByteArray(bar:ByteArray ):int
		//{
		//	bar.position = 0;
		//	var tmpNumAr:Array = [];
		//	Routines.readArray2ByteArray(tmpNumAr, bar);
		//	var saveVerDigs:Array = [];
		//	Routines.readArray2ByteArray(saveVerDigs, bar);
		//	var saveId:int = bar.readDouble();
		//	
		//	var bigSaveAr:Array = getBigSaveArOfId(saveId);
		//	bigSaveAr.length = 0;
		//	for (var i:int = 0; i < tmpNumAr.length; i++){
		//		bigSaveAr.push(tmpNumAr[i]);
		//	}
		//	var gameVersion:String = Routines.glueSaveDigits2String(saveVerDigs);
		//	setSaveVersion(saveId, gameVersion);
		//	return saveId;	
		//}	
		
		public function doesSaveExist(wid:int):Boolean{
			var bigSaveAr:Array = getBigSaveArOfId(wid);
			return bigSaveAr.length > 0;
		}
		//public function exportWorldSave2ByteArray(wid:int):ByteArray 
		//{
		//	var bigSaveAr:Array = getBigSaveArOfId(wid);
		//	var gameVersion:String = getSaveVersion(wid);
		//	var bar:ByteArray = new ByteArray();
		//	Routines.writeArray2ByteArray(bigSaveAr, bar);
		//	var arOfDigs:Array = Routines.transformSaveVersion2NumArray(gameVersion);
		//	Routines.writeArray2ByteArray(arOfDigs, bar);
		//	bar.writeDouble(wid);				
		//	return bar;
		//}
		
		//public function importWorldSaveFromBMD(bmd:BitmapData):int{//world id
		//	//trace('importWorldSaveFromBMD');
		//	var side:int = bmd.width;
		//	var pt2Read:Point = new Point(0, side);
		//	
		//	var len:int = bmd.getPixel(pt2Read.x, pt2Read.y);//берём из последней строки (высота на 1больше ширины)
		//	Routines.movePt2ReadInBMD(pt2Read, side);
		//	var versionDigs:Array = [];
		//	for (var i:int = 0; i < len; i++ ){
		//		versionDigs.push(bmd.getPixel(pt2Read.x, pt2Read.y));
		//		Routines.movePt2ReadInBMD(pt2Read, side);
		//	}
		//	var gameVersion:String = Routines.glueSaveDigits2String(versionDigs);
		//	var saveId:int = bmd.getPixel(pt2Read.x, pt2Read.y);
		//	
		//	//trace('loaded saveId:', saveId);
		//	//trace('loaded gameVersion:', gameVersion);
		//	
		//	pt2Read.x = 0;
		//	pt2Read.y = 0;
		//	
		//	var numPixels:uint = bmd.getPixel(pt2Read.x, pt2Read.y);
		//	Routines.movePt2ReadInBMD(pt2Read, side);
		//	var bar:ByteArray = new ByteArray();
		//	for (i = 0; i < numPixels; i++ ){
		//		var b:int = bmd.getPixel(pt2Read.x, pt2Read.y) - 128;
		//		bar.writeByte(b);
		//		Routines.movePt2ReadInBMD(pt2Read, side);
		//	}
		//	
		//	var bigSaveAr:Array = getBigSaveArOfId(saveId);
		//	 
		//	//var numAr:Array = [];
		//	bigSaveAr.length = 0;
		//	bar.position = 0;
		//	for (i = 0; i < numPixels/8; i++){
		//		var num:Number = bar.readDouble();
		//		bigSaveAr.push(num);
		//	}
		//	setSaveVersion(saveId, gameVersion);
		//	return saveId;		
		//}		
		

		//public function exportWorldSave2BMD(wid:int):BitmapData{
		//	var bigSaveAr:Array = getBigSaveArOfId(wid);
		//	var gameVersion:String = getSaveVersion(wid);
		//	
		//	var bar:ByteArray = new ByteArray();
		//	for (var i:int = 0; i < bigSaveAr.length; i++ ){
		//		bar.writeDouble(bigSaveAr[i]);
		//	}
		//	
		//	var numDoubles:int = bigSaveAr.length;
		//	
		//	bar.position = 0;
		//	
		//	var numPixels:uint = numDoubles*8;
		//	var side:int = Math.ceil(Math.sqrt(numPixels + 1));
		//	
		//	var bmd:BitmapData = new BitmapData(side, side+3, false, 0);
		//	bmd.lock();
		//	bmd.setPixel(0, 0, numPixels);
		//	var x0:int = 1;
		//	var y0:int = 0;
		//	for (i = 0; i < numPixels; i++ ){
		//		//var n:uint = bar.readUnsignedInt();
		//		var n:uint = bar.readByte()+128;
		//		//trace('setting ',n)
		//		bmd.setPixel(x0, y0, n);
		//		x0++;
		//		if (x0 >= side){
		//			x0 = 0;
		//			y0++;
		//		}
		//	}
		//	
		//	//writing version from pixel [0,side] and further
		//	var arOfParts:Array = gameVersion.split('.');
		//	var arOfDigs:Array = [];
		//	for (i = 0; i < arOfParts.length; i++ ){
		//		arOfDigs.push(int(arOfParts[i]));
		//	}
		//	//количество блоков в номере версии
		//	bmd.setPixel(0, side, arOfDigs.length);
		//	x0 = 1;
		//	y0 = side;			
		//	//номер версии
		//	for (i = 0; i < arOfDigs.length; i++){
		//		bmd.setPixel(x0, y0, arOfDigs[i]);
		//		x0++;
		//		if (x0 >= side){
		//			x0 = 0;
		//			y0++;
		//		}
		//	}
		//	//номер сейчас,откуда это взято
		//	bmd.setPixel(x0, y0, wid);
		//	
		//	bmd.unlock();
		//	return bmd;			
		//}

		
		public function exportWorldSave2String(wid:int, needCompress:Boolean = false):String{
			var bigSaveAr:Array = getBigSaveArOfId(wid);
			var gameVersion:String = getSaveVersion(wid);

			var res:String = '';// saveVersion0;
			var bar:ByteArray = new ByteArray();
			//trace('converting array to string:');
			
			
			for (var i:int = 0; i < bigSaveAr.length; i++ ){
				bar.writeDouble(bigSaveAr[i]);
			}
			if (needCompress){
				bar.compress();
			}
			
			bar.position = 0;
			var barLen:int = bar.bytesAvailable;
			//it was an error in this code (fixed now), also this code in never used
			for (i = 0; i < barLen; i+=4 ){
				var n:uint = bar.readUnsignedInt();
			//	res += n.toString();
				var codingSmbs:String = '`1234567890-=~!@#$%^&*()_+qwertyuiop[]QWERTYUIOP{}|asdfghjkl;ASDFGHJKL:zxcvbnm,./ZXCVBNM<>?';
				var base91Digits:Array = [];
				var baseVal:uint = codingSmbs.length;
				for (i = 0; i < 5; i++ ){
					var dg:uint = n % baseVal;
					base91Digits.push(dg);
					n = (n - dg) / baseVal;
				}
				for (i = 5 - 1; i >= 0; i-- ){
					var smb:String = codingSmbs.charAt(base91Digits[i]);
					res += smb;
				}
			}
			//res += bar.toString();
			//res += bar.readUTFBytes(bar.length);
			trace(res);
			return res;
		}
		
		public function importFromString(str:String):void{
			//trace('converting string to Array:');
			trace(str);
			var codingSmbs:String = '`1234567890-=~!@#$%^&*()_+qwertyuiop[]QWERTYUIOP{}|asdfghjkl;ASDFGHJKL:zxcvbnm,./ZXCVBNM<>?';
			var baseVal:uint = codingSmbs.length;
			var bar:ByteArray = new ByteArray();
			//trace('strLen:', str.length)
			var numNumbers:int = str.length / 5;
			for (var i:int = 0; i < str.length; i += 5 ){
				var codedInt:String = str.substr(i, 5);
				//trace('i=', i, 'codedInt=', codedInt);
				var res:uint = 0;
				for (var j:int = 0; j < codedInt.length; j++ ){
					var ch:String = codedInt.charAt(j);
					var dig:int = codingSmbs.indexOf(ch);
					res = res * baseVal + dig;
					//trace('j=', j, 'ch=', ch, 'dig=', dig, 'res=', res);
				}
				bar.writeUnsignedInt(res);
			}
			var numAr:Array = [];
			bar.position = 0;
			for (i = 0; i < numNumbers/2; i++){
				var n:Number = bar.readDouble();
				numAr.push(n);
			}
			trace(numAr);
		}
		
		public function getSaveVersion(wid:int):String 
		{
			switch (wid%10){
				case 0:{return saveVersion0;break; }
				case 1:{return saveVersion1;break; }
				case 2:{return saveVersion2;break; }
				case 3:{return saveVersion3;break; }
				case 4:{return saveVersion4;break; }
				case 5:{return saveVersion5;break; }
				case 6:{return saveVersion6;break; }
				case 7:{return saveVersion7;break; }
				case 8:{return saveVersion8;break; }
				case 9:{return saveVersion9; break; }
				default:{return saveVersion0; break; }
			}			
		}
		
		public function getBigSaveArOfId(wid:int, toLoad:Boolean=true):Array 
		{
			var resAr:Array = null;
			switch (wid%10){
				case 0: {resAr = bigSaveAr0;break; }
				case 1: {resAr = bigSaveAr1;break; }
				case 2: {resAr = bigSaveAr2;break; }
				case 3: {resAr = bigSaveAr3;break; }
				case 4: {resAr = bigSaveAr4;break; }
				case 5: {resAr = bigSaveAr5;break; }
				case 6: {resAr = bigSaveAr6;break; }
				case 7: {resAr = bigSaveAr7;break; }
				case 8: {resAr = bigSaveAr8;break; }
				case 9: {resAr = bigSaveAr9; break; }
				default:{resAr = bigSaveAr0; break; }
			}
			if (toLoad){
				var ar2:Array = PlayersAccount.account.loadArFromFile(PlayersAccount.account.getSavePath4World(wid+1));
				return PlayersAccount.account.getBestArOf2(resAr, ar2);
			}else{
				return resAr;
			}
			
		}
		
		
		public function backupSave2File(wid:int):void 
		{
			var ar:Array = getBigSaveArOfId(wid, false);
			PlayersAccount.account.saveAr2File(ar, PlayersAccount.account.getSavePath4World(wid + 1));
		}
		
		public function setSaveVersion(wid:int, val:String):void 
		{
			switch (wid%10){
				case 0: {saveVersion0=val;break; }
				case 1: {saveVersion1=val;break; }
				case 2: {saveVersion2=val;break; }
				case 3: {saveVersion3=val;break; }
				case 4: {saveVersion4=val;break; }
				case 5: {saveVersion5=val;break; }
				case 6: {saveVersion6=val;break; }
				case 7: {saveVersion7=val;break; }
				case 8: {saveVersion8=val;break; }
				case 9: {saveVersion9=val; break; }
				default:{saveVersion0=val; break; }
			}			
		}		
		
		public function fixSavedInitialization(wid:int):void 
		{
			initializedArrays[wid%10] = 1;
		}
		
	}

}