package
{
	import flash.utils.ByteArray;
	import globals.Translator;
	import gui.buttons.BitBtn;
	import gui.pages.PreStartPage;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gui.text.MultilangTextField;
	import starling.display.Image;
	import starling.display.MovieClip;
	
	/**
	 * ...
	 * @author Alexey Izvalov
	 */
	public class Routines
	{
		static private var bigNumbersEndings:Array=['K','M', 'B', 'T', 'Qa', 'Qi', 'Sx', 'Sp', 'Oc', 'N', 'D', 'UD', 'DD', 'TD', 'QaD', 'QiD', 'SxD', 'SpD', 'OD', 'ND', 'V', 'UV', 'DV', 'TV', 'QaV', 'QiV', 'SxV', 'SpV', 'OV', 'NV'];
		
		public function Routines()
		{
		
		}
		
		//_____________________________ALGEBRA______________________________________//
		static public function getValFromPartiallyLinearFuntion(val:Number, ys:Array, xs:Array):Number
		{
			var res:Number = ys[0];
			var len:int = xs.length;
			if (val <= xs[0])
			{
				res = ys[0];
			}
			else
			{
				if (val >= xs[len - 1])
				{
					res = ys[len - 1];
				}
				else
				{
					for (var i:int = 0; i < len - 1; i++)
					{
						if (val < xs[i + 1])
						{
							var lambda:Number = (val - xs[i]) / (xs[i + 1] - xs[i]);
							res = (ys[i + 1] - ys[i]) * lambda + ys[i];
							break;
						}
					}
				}
			}
			return res;
		}
		
		static public function makeLinearInterpolation(x0:Number, t0:Number, x1:Number, t1:Number, t:Number):Number
		{
			var dt:Number = t - t0;
			var deltaT:Number = t1 - t0;
			var deltaX:Number = x1 - x0;
			var res:Number = x0 + dt * deltaX / deltaT;
			return res;
		}
		
		static public function lint(lambda:Number, valFrom:Number, valTo:Number):Number
		{
			return valFrom + (valTo - valFrom) * lambda;
		}
		
		static public function isValBetween(val:Number, bound1:Number, bound2:Number):Boolean
		{
			if (bound1 <= bound2)
			{
				return ((val >= bound1) && (val <= bound2));
			}
			else
			{
				return ((val >= bound2) && (val <= bound1));
			}
		}
		
		static public function areValuesEqualByMod(val1:int, val2:int, cycleLength:int):Boolean
		{
			var delta:int = val1 - val2;
			return (delta % cycleLength) == 0;
		}
		
		static public function Fib(id:int, a:Number, b:Number):Number
		{
			if (id == 0)
			{
				return a;
			}
			if (id == 1)
			{
				return b;
			}
			while (id >= 2)
			{
				var c:Number = a + b;
				a = b;
				b = c;
				id--;
			}
			return c;
		}
		
		static public function isNumberInSequenceOfNodesWithGrowingDistances(k:int, firstNodeVal:int, increasingDistStep:int):Boolean 
		{
			//DONE: надо не просто проверять, целый ли дискриминант, а и решать само уравнение и проверять целость
			var res:Boolean = false;
			if (k<firstNodeVal){
				return res;
			}
			if(increasingDistStep == 0){
				return k % firstNodeVal == 0;
			}			
			var a:int = firstNodeVal;
			var b:int = increasingDistStep;
			var D:int = (2 * a - b) * (2 * a - b) + 8 * b * k;
			var sq:Number = Math.sqrt(D);
			if (sq % 1 == 0){
				var n:Number = 0.5 * (b - 2 * a + sq) / b
				if (n%1==0){
					res = true;
				}
			}
			return res;			
		}
		
		//_____________________________GEOM______________________________________//
		static public function getDistBetweenPoints(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		static public function isDistBetweenPointsSmallerThan(x1:Number, y1:Number, x2:Number, y2:Number, threshold:Number):Boolean
		{
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			
			return (dx * dx + dy * dy <= threshold * threshold);
		}
		
		static public function findYOfLineIntersectionWithVertical(x1:Number, y1:Number, x2:Number, y2:Number, xV:Number):Number{
			return y1 + (y2 - y1) * (xV - x1) / (x2 - x1);
		}
		static public function findXOfLineIntersectionWithHorizontal(x1:Number, y1:Number, x2:Number, y2:Number, yH:Number):Number{
			return x1 + (x2 - x1) * (yH - y1) / (y2 - y1);
		}
		
		//results like on NumPad:
		//7 8 9
		//4 5 6
		//1 2 3
		static public function findSectorIdOfPointRelated2Rect(pt:Point, rct:Rectangle):int{
			var resY:int = 0;
			if (pt.y < rct.top){//7 8 9
				resY = 6;
			}else{
				if (pt.y > rct.bottom){//1 2 3
					resY = 0;
				}else{//4 5 6
					resY = 3;
				}
			}
			var resX:int = 0;
			if (pt.x < rct.left){//7 4 1
				resX = 1;
			}else{
				if (pt.x > rct.right){//9 6 3
					resX = 3;
				}else{//8 5 2
					resX = 2;
				}
			}
			
			return resX + resY;
		}
		
		static public function doesCircleIntersectWithRect(rct:Rectangle, cx:Number, cy:Number, rad:int):Boolean
		{
			var res:Boolean = false;
			//рассматриваем 9 полоений центра кргуа и прамоугольника
			var xId:int = 0;
			var yId:int = 0;
			
			var pt2Check:Point = new Point();
			if (cx < rct.left)
			{
				pt2Check.x = rct.left;
				xId = -1;
			}
			else
			{
				if (cx > rct.right)
				{
					pt2Check.x = rct.right;
					xId = 1;
				}
			}
			if (cy < rct.top)
			{
				pt2Check.y = rct.top;
				yId = -1;
			}
			else
			{
				if (cy > rct.bottom)
				{
					pt2Check.y = rct.bottom;
					yId = 1;
				}
			}
			
			switch (xId)
			{
			case -1: 
			{
				if ((cx >= rct.left - rad) && (yId == 0))
				{
					res = true;
				}
				break;
			}
			case 0: 
			{
				if ((cy >= rct.top - rad) && (cy <= rct.bottom + rad))
				{
					res = true;
				}
				break;
			}
			case 1: 
			{
				if ((cx <= rct.right + rad) && (yId == 0))
				{
					res = true;
				}
				break;
			}
			}
			
			if (!res)
			{
				if ((xId == 1) || (xId == -1) || (yId == 1) || (yId == -1))
				{
					if (isDistBetweenPointsSmallerThan(pt2Check.x, pt2Check.y, cx, cy, rad))
					{
						res = true;
					}
				}
			}
			
			return res;
		}
		
		static public function getAngleFromTo(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			var dx:Number = x1 - x0;
			var dy:Number = y1 - y0;
			
			return Math.atan2(dx, -dy);
		}
		
		static public function subtractAngles(phi1:Number, phi0:Number):Number
		{
			var dPhi:Number = phi1 - phi0;
			while (dPhi < -Math.PI)
			{
				dPhi += 2 * Math.PI;
			}
			while (dPhi > Math.PI)
			{
				dPhi -= 2 * Math.PI;
			}
			return dPhi;
		}
		
		static public function getDistFromLine2Point(xA:Number, yA:Number, xB:Number, yB:Number, x0:Number, y0:Number):Number
		{
			var dA:Number = Routines.getDistBetweenPoints(xA, yA, x0, y0);
			var dB:Number = Routines.getDistBetweenPoints(xA, yA, x0, y0);
			var d0:Number = Routines.getDistBetweenPoints(xA, yA, xB, yB);
			var p:Number = (dA + dB + d0) / 2;
			var S:Number = Math.sqrt(p * (p - dA) * (p - dB) * (p - d0));
			if (d0 != 0)
			{
				var res:Number = 2 * S / d0;
			}
			else
			{
				res = dA;
			}
			return res;
		}
		
		static public function rotateRect(rct:Rectangle, rot:Number):void
		{
			var topLeftPt:Point = new Point(rct.left, rct.top);
			var topRightPt:Point = new Point(rct.right, rct.top);
			var botLeftPt:Point = new Point(rct.left, rct.bottom);
			var botRightPt:Point = new Point(rct.right, rct.bottom);
			
			Routines.rotatePointByAngle(topLeftPt, rot);
			Routines.rotatePointByAngle(topRightPt, rot);
			Routines.rotatePointByAngle(botLeftPt, rot);
			Routines.rotatePointByAngle(botRightPt, rot);
			
			rct.left = Math.min(topLeftPt.x, topRightPt.x, botLeftPt.x, botRightPt.x);
			rct.right = Math.max(topLeftPt.x, topRightPt.x, botLeftPt.x, botRightPt.x);
			rct.top = Math.min(topLeftPt.y, topRightPt.y, botLeftPt.y, botRightPt.y);
			rct.bottom = Math.max(topLeftPt.y, topRightPt.y, botLeftPt.y, botRightPt.y);
		}
		
		static public function scaleRect(rct:Rectangle, scaleX:Number, scaleY:Number):void
		{
			
			if (scaleX == -1)
			{
				var tmpLeft:Number = rct.left;
				var tmpRight:Number = rct.right;
				rct.left = -tmpRight;
				rct.right = -tmpLeft;
			}
			if (scaleY == -1)
			{
				var tmpTop:Number = rct.top;
				var tmpBottom:Number = rct.bottom;
				rct.top = -tmpBottom;
				rct.bottom = -tmpTop;
			}
		
		}
		
		static public function expandRectByFrame(rct:Rectangle, frame:Number):void
		{
			rct.left -= frame;
			rct.right += frame;
			rct.top -= frame;
			rct.bottom += frame;
		}
		
		static public function getPointOnLineABWhichWillHaveTheSameDistance2AasC(ptA:Point, ptB:Point, ptC:Point):Point
		{
			var vecBA:Point = new Point(ptB.x - ptA.x, ptB.y - ptA.y);
			var vecCA:Point = new Point(ptC.x - ptA.x, ptC.y - ptA.y);
			//пока делаем по простому: берём расстояние и не смотрим,что точка может быть на продолжении
			var dAB:Number = vecBA.length;
			var dAC:Number = vecCA.length;
			if (dAB > 0.000001)
			{
				var lambda:Number = dAC / dAB;
				var resPt:Point = new Point(ptA.x + lambda * vecBA.x, ptA.y + lambda * vecBA.y);
			}
			else
			{
				resPt = new Point(ptA.x, ptA.y);
			}
			return resPt;
		}
		
		static public function doesCircleIntersectWithLine(fromPoint:Point, toPoint:Point, cx:Number, cy:Number, rad:int):Boolean
		{
			var res:Boolean = false;
			var a:Number = getDistBetweenPoints(fromPoint.x, fromPoint.y, toPoint.x, toPoint.y);
			var b:Number = getDistBetweenPoints(fromPoint.x, fromPoint.y, cx, cy);
			var c:Number = getDistBetweenPoints(cx, cy, toPoint.x, toPoint.y);
			var p:Number = (a + b + c) / 2;
			var S:Number = Math.sqrt(p * (p - a) * (p - b) * (p - c));
			var h:Number = 2 * S / a;
			if (h <= rad)
			{
				var mx:Number = (c > b) ? c : b;
				var mn:Number = (c <= b) ? c : b;
				if (mx * mx <= mn * mn + a * a)
				{
					res = true;
				}
				else
				{
					if (mx == c)
					{
						res = isDistBetweenPointsSmallerThan(fromPoint.x, fromPoint.y, cx, cy, rad);
					}
					else
					{
						res = isDistBetweenPointsSmallerThan(toPoint.x, toPoint.y, cx, cy, rad);
					}
				}
			}
			return res;
		}
		
		/*касаются ли 2 окружности в точке (нужно для зацепления шестерёнок)*/
		static public function doTwoCirclesOuterTouchInPoint(xA:Number, yA:Number, rA:Number, xB:Number, yB:Number, rB:Number, xC:Number, yC:Number, prec:Number):Boolean
		{
			var dxAB:Number = xB - xA;
			var dyAB:Number = yB - yA;
			var dAB:Number = Math.sqrt(dxAB * dxAB + dyAB * dyAB);
			var sumRad:Number = rA + rB;
			var lambda:Number = rA / sumRad;
			
			var xC1:Number = xA * (1 - lambda) + xB * lambda;//теоретическая точка касания
			var yC1:Number = yA * (1 - lambda) + yB * lambda;
			
			//расстояние между теоретической и актуальной
			var dC:Number = Routines.getDistBetweenPoints(xC, yC, xC1, yC1);
			return (dC <= prec);
		}
		
		static public function doTwoCirclesInnerTouchInPoint(xA:Number, yA:Number, rA:Number, xB:Number, yB:Number, rB:Number, xC:Number, yC:Number, prec:Number):Boolean
		{//будут  некоторые отличия в точности, но пусть
			return doTwoCirclesOuterTouchInPoint(xA, yA, rA - rB, xC, yC, rB, xB, yB, prec);
		}
		
		static public function rotatePointByAngle(pt:Point, phi:Number):void
		{
			var newX:Number = pt.x * Math.cos(phi) - pt.y * Math.sin(phi);
			var newY:Number = pt.x * Math.sin(phi) + pt.y * Math.cos(phi);
			pt.x = newX;
			pt.y = newY;
		}
		
		static public function addTag2VectorMidpoint(x0:Number, y0:Number, x1:Number, y1:Number, dist:Number, resPt:flash.geom.Point):void 
		{
			var cx:Number = (x0 + x1) / 2;
			var cy:Number = (y0 + y1) / 2;
			resPt.setTo(x1 - x0, y1 - y0);
			//if (resPt.length>0){
			resPt.normalize(dist);
			if (x1<x0){
				rotatePointByAngle(resPt, -Math.PI/2)
			}else{
				rotatePointByAngle(resPt, Math.PI/2)
			}
			resPt.x += cx;
			resPt.y += cy;
		}
		
		
		//_____________________________BITS______________________________________//
		
		static public function calcBitsInNumber(n:uint):uint
		{
			var res:uint = 0;
			while (n > 0)
			{
				res += (n & 1);
				n >>= 1;
			}
			return res;
		}
		
		static public function doesFlagExistInNumber(id:int, flgs:uint):Boolean
		{
			var flag2Find:uint = (1 << id);
			var findRes:uint = flag2Find & flgs;
			return findRes != 0;
		}
		
		//_____________________________COLOR______________________________________//
		static public function getColorBetweenWithLambda(cl0:uint, cl1:uint, lambda:Number):uint
		{
			var r0:int = cl0 & 0xff;
			cl0 >>= 8;
			var g0:int = cl0 & 0xff;
			var b0:int = cl0 >> 8;
			
			var r1:int = cl1 & 0xff;
			cl1 >>= 8;
			var g1:int = cl1 & 0xff;
			var b1:int = cl1 >> 8;
			
			var r2:int = r0 * (1 - lambda) + r1 * lambda;
			var g2:int = g0 * (1 - lambda) + g1 * lambda;
			var b2:int = b0 * (1 - lambda) + b1 * lambda;
			
			if (r2 > 255)
			{
				r2 = 255;
			}
			if (r2 < 0)
			{
				r2 = 0;
			}
			
			if (g2 > 255)
			{
				g2 = 255;
			}
			if (g2 < 0)
			{
				g2 = 0;
			}
			
			if (b2 > 255)
			{
				b2 = 255;
			}
			if (b2 < 0)
			{
				b2 = 0;
			}
			
			var res:uint = (b2 << 16) | (g2 << 8) | (r2);
			return res;
		}
		
		static public function convertHSV2Color(h:int, s:int, v:int):uint
		{
			var rgbAr:Array = convertHSV2RGB(h, s, v);
			for (var i:int = 0; i < rgbAr.length; i++)
			{
				rgbAr[i] = Math.min(255, Math.max(0, Math.round(rgbAr[i])));//на всякий случай
			}
			return ((rgbAr[0] << 16) | (rgbAr[1] << 8) | rgbAr[2]);
		}
		
		static public function convertHSV2RGB(h:int, s:int, v:int):Array
		{
			if (h == 360)
			{
				h = 0
			}
			var Hi:int = int(h / 60);
			var Vmin:Number = ((100 - s) * v) / 100;
			var a:Number = (v - Vmin) * (h % 60) / 60;
			
			var Vinc:Number = Vmin + a;
			var Vdec:Number = v - a;
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			switch (Hi)
			{
			case 0: 
			{
				r = v;
				g = Vinc;
				b = Vmin;
				break;
			}
			case 1: 
			{
				r = Vdec;
				g = v;
				b = Vmin;
				break;
			}
			case 2: 
			{
				r = Vmin;
				g = v;
				b = Vinc;
				break;
			}
			case 3: 
			{
				r = Vmin;
				g = Vdec;
				b = v;
				break;
			}
			case 4: 
			{
				r = Vinc;
				g = Vmin;
				b = v;
				break;
			}
			case 5: 
			{
				r = v;
				g = Vmin;
				b = Vdec;
				break;
			}
			}
			var res:Array = [Math.round(2.55 * r), Math.round(2.55 * g), Math.round(2.55 * b)];
			//	trace('convertedHSV ', h, s, v, ' to ', res);
			return res;
		}
		
		static public function convertRGB2HSV(r:int, g:int, b:int):Array
		{//r, g, b [0..100]
			var rH:Number = 0;
			var rS:Number = 0;
			var rV:Number = 0;
			
			var minRGB:Number = Math.min(r, g, b);
			var maxRGB:Number = Math.max(r, g, b);
			if (minRGB == maxRGB)
			{
				rV = minRGB;
			}
			else
			{
				var d:Number = (r == minRGB) ? (g - b) : ((b == minRGB) ? (r - g) : b - r);
				var h:Number = (r == minRGB) ? 3 : ((b == minRGB) ? 1 : 5);
				rH = 60 * (h - d / (maxRGB - minRGB));
				rS = (maxRGB - minRGB) / maxRGB;
				rV = maxRGB;
			}
			var res:Array = [Math.round(rH), Math.round(100 * rS), Math.round(rV)];
			//	trace('converted ', r, g, b, ' to ', res);
			return res;
		}
		
		//_____________________________SAVE/LOAD______________________________________//
		static public function clearNumberFromInfinityAndNaN(n:Number):Number
		{
			var res:Number = n;
			if (isNaN(n))
			{
				res = 0;
			}
			if (n >= 0.5 * Number.MAX_VALUE)
			{
				res = 0;
			}
			if (n <= -0.5 * Number.MAX_VALUE)
			{
				res = 0;
			}
			return res;
		}
		
		static public function saveString2Ar(ar:Array, nxtId:int, str:String):int
		{
			if (!str || (str == ''))
			{
				ar[nxtId + 0] = 0;
				return nxtId + 1;
			}
			else
			{
				ar[nxtId + 0] = str.length;
				nxtId++;
				for (var i:int = 0; i < str.length; i++)
				{
					var ch:String = str.charAt(i);
					var id:int = globals.Translator.translator.westernSymbols.indexOf(ch);
					ar[nxtId + 0] = id;
					nxtId++;
				}
				return nxtId;
			}
		}
		
		static public function loadStringFromAr(ar:Array, nxtId:int, strAr:Array):int
		{
			var len:int = ar[nxtId + 0];
			strAr[0] = '';
			nxtId++;
			for (var i:int = 0; i < len; i++)
			{
				var id:int = ar[nxtId];
				
				if (id == -1)
				{
					var ch:String = ' ';
				}
				else
				{
					ch = globals.Translator.translator.westernSymbols.charAt(id);
				}
				
				strAr[0] += ch;
				nxtId++;
			}
			return nxtId;
		}
		
				
		static public function loadArOfNumbersFromAr(dataAr:Array, ar:Array, nxtId:int):int 
		{
			var len:int = ar[nxtId + 0];
			dataAr.length = 0;
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				dataAr[i] = ar[nxtId + 0];
				nxtId++;
			}
			
			return nxtId;
		}	
		
		static public function saveArOfNumbers2Ar(dataAr:Array, ar:Array, nxtId:int):int 
		{
			var len:int = dataAr.length;
			ar[nxtId + 0] = len;
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				ar[nxtId + 0] = dataAr[i];
				nxtId++;
			}
			
			return nxtId;
		}
		
		static public function loadArOfStringsFromAr(dataAr:Array, ar:Array, nxtId:int):int {
			var len:int = ar[nxtId + 0];
			dataAr.length = 0;
			nxtId++;
			var tmpAr:Array = [];
			for (var i:int = 0; i < len; i++ ){
				tmpAr.length = 0;
				nxtId = loadStringFromAr(ar, nxtId, tmpAr);
				dataAr[i] = tmpAr[0];
			}
			
			return nxtId;			
		}
		
		static public function saveArOfStrings2Ar(dataAr:Array, ar:Array, nxtId:int):int 
		{
			var len:int = dataAr.length;
			ar[nxtId + 0] = len;
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				nxtId = Routines.saveString2Ar(ar, nxtId, dataAr[i]);
			}
			
			return nxtId;
		}
		
		
		
		static public function loadVecOfNumbersFromAr(dataAr:Vector.<Number>, ar:Array, nxtId:int):int 
		{
			var len:int = ar[nxtId + 0];
			dataAr.length = 0;
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				dataAr[i] = ar[nxtId + 0];
				nxtId++;
			}
			
			return nxtId;
		}	
		
	
		
		static public function saveVecOfNumbers2Ar(dataAr:Vector.<Number>, ar:Array, nxtId:int):int 
		{
			var len:int = dataAr.length;
			ar[nxtId + 0] = len;
			nxtId++;
			for (var i:int = 0; i < len; i++ ){
				ar[nxtId + 0] = dataAr[i];
				nxtId++;
			}
			
			return nxtId;
		}
		
		static public function isSaveVersionIsAtLeast(saveVersion:String, minVersion:String):Boolean
		{
			if (!saveVersion)
			{
				return false;
			}
			
			var ar1:Array = saveVersion.split('.');
			var ar2:Array = minVersion.split('.');
			var digAr1:Array = [];
			var digAr2:Array = [];
			for (var i:int = 0; i < ar1.length; i++)
			{
				digAr1.push(int(ar1[i]));
			}
			for (i = 0; i < ar2.length; i++)
			{
				digAr2.push(int(ar2[i]));
			}
			//0.1.1>0.1
			//0.2>0.1.3
			//0.2.1>0.1
			//0.1.5<0.1.6
			//0.1.5>0.1.4
			
			for (i = 0; i < digAr1.length; i++)
			{
				if (digAr1[i] > digAr2[i])
				{
					return true;
				}
				if (digAr1[i] < digAr2[i])
				{
					return false;
				}
			}
			return digAr1.length >= digAr2.length;
		}
		
		//_____________________________RANDOM______________________________________//
		static public function randomIntNumberFromToIncl(a:int, b:int):int{
			if (b < a)
			{
				var t:int = b;
				b = a;
				a = t;
			}
			return a+Math.floor(Math.random()*(b-a+1))
		}
		static public function randomNumberFromToIncl(a:Number, b:Number):Number
		{
			if (b < a)
			{
				var t:Number = b;
				b = a;
				a = t;
			}
			var rand:Number = Math.random() * 1.000001;
			if (rand > 1)
			{
				rand = 1;
			}
			return a + rand * (b - a);
		}
		
		static public function getRandomIndexFromWeightedAr(ar:Array):int
		{
			if (ar.length == 1){
				if (ar[0]==0){
					return -1
				}else{
					return 0;
				}
			}
			var res:int = -1;
			var s:Number = 0;
			for (var i:int = 0; i < ar.length; i++)
			{
				s += ar[i];
			}
			if (s > 0)
			{
				var rnd:Number = s * Math.random();
				var rid:int = 0;
				while (rnd >= ar[rid])
				{
					rnd -= ar[rid];
					rid++;
				}
				res = rid;
			}
			else
			{
				res = -1;
			}
			return res;
		}
		
		static public function getRandomIntValueFromAr(ar:Array):int
		{
			return ar[int(Math.random() * ar.length)]
		}
		
		static public function getRandomStringValueFromAr(ar:Array):String
		{
			return ar[int(Math.random() * ar.length)]
		}
		
		//_____________________________ARRAYS______________________________________//
		
		static public function findIdOfMaxValInAr(ar:Array):int
		{
			var res:int = 0;
			var mxVal:Number = ar[0];
			var numSameVals:int = 1;
			for (var i:int = 1; i < ar.length; i++)
			{
				if (ar[i] > mxVal)
				{
					res = i;
					mxVal = ar[i];
					numSameVals = 1;
				}
				else
				{
					if (ar[i] == mxVal)
					{
						numSameVals++;
						if (Math.random() < 1 / numSameVals)
						{
							res = i;
						}
					}
				}
			}
			return res;
		}
		
		static public function findIdOfMinInAr(ar:Array):int
		{
			var res:int = 0;
			var resVal:int = 0;
			var numSameVal:int = 1;
			for (var i:int = 1; i < ar.length; i++)
			{
				if (ar[i] < resVal)
				{
					resVal = ar[i];
					res = i;
					numSameVal = 1;
				}
				else
				{
					if (ar[i] == resVal)
					{
						numSameVal++;
						if (Math.random() < 1 / numSameVal)
						{
							res = i;
						}
					}
				}
			}
			return res;
		}
		
		static public function findIdOfBoxInGrowingOrder(ar:Array, val:Number):int{
			var res:int =0;
			//ar= [1,5,15]
			//ar= [(-Infty;1],(1;5],(5;15],(15;Infty)]
			//указываем номер ячейки
			//val=3 -> res
			for (var i:int = 0; i < ar.length; i++){
				if (val<=ar[i]){
					break;
				}
			}
			res = i;
			return res;
		}
		
		static public function findPointIdInArray(ar:Array, pt:Point):int
		{
			var res:int = -1;
			for (var i:int = 0; i < ar.length; i++)
			{
				var pt0:Point = ar[i];
				if ((pt0.x == pt.x) && (pt0.y == pt.y))
				{
					res = i;
					break;
				}
			}
			return res;
		}
		
		static public function findPointXYIdInArray(ar:Array, ptx:int, pty:int):int
		{
			var res:int = -1;
			for (var i:int = 0; i < ar.length; i++)
			{
				var pt0:Point = ar[i];
				if ((pt0.x == ptx) && (pt0.y == pty))
				{
					res = i;
					break;
				}
			}
			return res;
		}
		
		static public function shiftAr2MakeEqual2Ar(ar2Shift:Array, ar2Get:Array):int
		{
			var res:int =-1;
			if (ar2Get.length == ar2Shift.length){
				var len:int = ar2Get.length;
				var numOnes0:int = 0;
				var numOnes1:int = 0;
				for (var i:int = 0; i < len; i++){
					numOnes0 += ar2Shift[i];
					numOnes1 += ar2Get[i];
				}
				if (numOnes0 == numOnes1){
					for (var ans:int = 0; ans < len; ans++){
						var hasEqual:Boolean = true;
						
						for (i = 0; i < len; i++ ){
							if (ar2Get[(i + ans) % len] != ar2Shift[i]){
								hasEqual = false;
								break;
							}
						}
						
						if (hasEqual){
							res = ans;
							break;
						}
					}
				}
			}
			return res;
		}
		
		static public function trace2DimAr(cells:Array):void 
		{
			trace('--------------------')
			for (var i:int = 0; i < cells.length; i++ ){
				var ar:Array = cells[i];
				var str:String = '';
				for (var j:int = 0; j < ar.length; j++){
					str += ar[j].toString() + ', ';
				}
				trace(str);
			}
			trace('====================')
		}
		
		
		static public function calcNonZeroElems(ar:Array):int 
		{
			var res:int = 0;
			for (var i:int = 0; i < ar.length; i++) {
				if (ar[i] != 0){
					res++;
				}
			}
			return res;
		}
		static public function writeArray2ByteArray(ar:Array, bar:ByteArray):void 
		{
			bar.writeDouble(ar.length);
			for (var i:int = 0; i < ar.length; i++ ){
				bar.writeDouble(ar[i]);
			}
		}
	
		static public function readArrayFromByteArray(ar:Array, bar:ByteArray):void 
		{
			bar.position = 0;
			var len:int = bar.readDouble();
			ar.length = len;
			for (var i:int = 0; i < len; i++ ){
				ar[i] = bar.readDouble();
			}
		}
		static public function encodeByteArray2Base64(bar:flash.utils.ByteArray):String {
			var res:String = "";
			var digs:String = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+=";
			bar.position = 0;
			
			while (bar.bytesAvailable > 0){
				if (bar.bytesAvailable>=3){
					var bt0:int = bar.readByte();//от -128 до 127
					var bt1:int = bar.readByte();//от -128 до 127
					var bt2:int = bar.readByte();//от -128 до 127
					bt0 += 128;
					bt1 += 128;
					bt2 += 128;
					var b1:int = bt0 >> 2;
					var b2:int = ((bt0 & 3)<<4)|(bt1>>4);
					var b3:int = ((bt1 & 15)<<2)|(bt2>>6);
					var b4:int = bt2 & 63;
					res += digs.charAt(b1);
					res += digs.charAt(b2);
					res += digs.charAt(b3);
					res += digs.charAt(b4);
				}else{
					if (bar.bytesAvailable==2){
						bt0 = bar.readByte();//от -128 до 127
						bt1 = bar.readByte();//от -128 до 127
						bt0 += 128;
						bt1 += 128;	
						b1 = bt0 >> 2;
						b2 = ((bt0 & 3)<<4)|(bt1>>4);
						b3 = ((bt1 & 15) << 2);
						res += digs.charAt(b1);
						res += digs.charAt(b2);
						res += digs.charAt(b3);						
					}else{
						bt0 = bar.readByte();//от -128 до 127
						bt0 += 128;
						b1 = bt0 >> 2;
						b2 = ((bt0 & 3) << 4);	
						res += digs.charAt(b1);
						res += digs.charAt(b2);						
					}
				}
			}
			
			return res;
		}
		
		static public function decodeBase642ByteArray(str:String, bar:flash.utils.ByteArray):void {
			var digs:String = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+=";
			var remLen:int = str.length % 4;
			for (var i:int = 0; i < str.length-remLen; i += 4 ){
				var s1:String = str.charAt(i);
				var s2:String = str.charAt(i + 1);
				var s3:String = str.charAt(i + 2);
				var s4:String = str.charAt(i + 3);
				var b1:int = digs.indexOf(s1);
				var b2:int = digs.indexOf(s2);
				var b3:int = digs.indexOf(s3);
				var b4:int = digs.indexOf(s4);
				
				bar.writeByte(((b1 << 2) | (b2>>4)) - 128);
				bar.writeByte((((b2&15) << 4) | (b3>>2)) - 128);
				bar.writeByte((((b3&3) << 6) | (b4)) - 128);
			}
			//остаток от деления на 4 может быть только 2 или 3 (когда записывали 3n+1 или 3n+2 8-битных чисел
			if (remLen==3){
				s1 = str.charAt(str.length-remLen);
				s2 = str.charAt(str.length-remLen + 1);
				s3 = str.charAt(str.length - remLen + 2);		
				b1 = digs.indexOf(s1);
				b2 = digs.indexOf(s2);
				b3 = digs.indexOf(s3);
				bar.writeByte(((b1 << 2) | (b2>>4)) - 128);
				bar.writeByte((((b2&15) << 4) | (b3>>2)) - 128);				
			}else{
				if (remLen == 2){
					s1 = str.charAt(str.length-remLen);
					s2 = str.charAt(str.length-remLen + 1);		
					b1 = digs.indexOf(s1);
					b2 = digs.indexOf(s2);
					bar.writeByte(((b1 << 2) | (b2>>4)) - 128);					
				}
			}
		}
		
		static public function encodeByteArray2Hex(bar:flash.utils.ByteArray):String 
		{
			var res:String = "";
			var digs:String="0123456789abcdef"
			bar.position = 0;
			
			while (bar.bytesAvailable > 0){
				var bt:int = bar.readByte();//от -128 до 127

				bt = bt + 128;
				
				var b1:int = bt >> 4;
				var b2:int = bt & 15;
				res += digs.charAt(b1);
				res += digs.charAt(b2);
			}
			
			return res;
		}	
		
		static public function decodeHex2ByteArray(str:String, bar:flash.utils.ByteArray):void 
		{
			var digs:String = "0123456789abcdef"
			for (var i:int = 0; i < str.length; i += 2 ){
				var s1:String = str.charAt(i);
				var s2:String = str.charAt(i + 1);
				var b1:int = digs.indexOf(s1);
				var b2:int = digs.indexOf(s2);
				
				bar.writeByte(((b1 << 4) | b2) - 128);
			}
		}
		
		//длина строки на входе будет чётной
		static public function packHexString(str:String):String{
			var res:String = "";
			//counting "80"
			var isCounting80:Boolean = false; 
			var num802Count:int = 0;
			for (var i:int = 0; i < str.length; i+=2 ){
				var ch1:String = str.charAt(i);
				var ch2:String = str.charAt(i+1);
				if ((ch1 == "8") && (ch2 == "0")){
					if (isCounting80){
						num802Count++;
					}else{
						isCounting80 = true;
						num802Count = 1;
					}
				}else{
					if (isCounting80){
						if (num802Count > 2){
							res+='g'+num802Count.toString()+"g"
						}else{
							for (var k:int = 0; k < num802Count; k++ ){
								res += "80";
							}
						}
						isCounting80 = false;
					}
					
					res += ch1;
					res += ch2;
				}
			}
			//если строка завершилась на 80
			if (isCounting80){
				if (num802Count > 2){
					res+='g'+num802Count.toString()+"g"
				}else{
					for (k = 0; k < num802Count; k++ ){
						res += "80";
					}
				}
				isCounting80 = false;
			}
			
			str = res;
			res = replacePairsOfMostUsedSymbols(str, "0123456789abcdefg", "ABCDEFGH");			
			str = res;
			res = replacePairsOfMostUsedSymbols(str, "0123456789abcdefgABCDEFGH", "IJKLMNOP");		
			str = res;
			res = replacePairsOfMostUsedSymbols(str, "0123456789abcdefgABCDEFGHIJKLMNOP", "QRSTUVWXYZ");
			str = res;
			return res;
		}
		
		static private function replacePairsOfMostUsedSymbols(str:String, initialAlphabet:String, swappingAlphabet:String):String 
		{
			var chars:String = initialAlphabet;
			var numChars:int = chars.length;
			
			var charPaisCodes:Vector.<int> = new Vector.<int>()
			var charsPairs:Vector.<int> = new Vector.<int>()
			
			for (var i:int = 0; i < numChars; i++ ){
				for (var j:int = 0; j < numChars; j++){
					charsPairs.push(0);
					charPaisCodes.push(i * numChars + j);
				}
			}
			//ищем самые частые комбинации
			var prevCharId:int =-1;
			for (i = 0; i < str.length; i++ ){
				var ch1:String = str.charAt(i);
				var charId:int = chars.indexOf(ch1);
				if (prevCharId !=-1){
					charsPairs[prevCharId*numChars+charId]++;
				}
				prevCharId = charId;
			}
			
			//sorting
			for (i = 0; i < charsPairs.length; i++ ){
				for (j = i + 1; j < charsPairs.length; j++ ){
					if (charsPairs[i] < charsPairs[j]){
						var t:int = charsPairs[i];
						charsPairs[i] = charsPairs[j];
						charsPairs[j] = t;
						
						t = charPaisCodes[i];
						charPaisCodes[i] = charPaisCodes[j];
						charPaisCodes[j] = t;
					}
				}
			}
			
			//на что будем заменять пары
			var swapSymbols:String = swappingAlphabet
			var swapSymbolsByPairs:Vector.<Vector.<int>>=new Vector.<Vector.<int>>();
			for (i = 0; i < numChars; i++){
				var vec: Vector.<int> = new Vector.<int>();
				for (j = 0; j < numChars; j++){
					vec.push( -1);
				}
				swapSymbolsByPairs.push(vec);
			}
			
			var res:String = "";
			var numSwaps:int = swapSymbols.length;
			for (i = 0; i < numSwaps; i++){
				var code:int = charPaisCodes[i];
				var ch1Code:int = int(code/numChars)
				var ch2Code:int = code % numChars;
				swapSymbolsByPairs[ch1Code][ch2Code] = i;
				res += (swapSymbols.charAt(i) + chars.charAt(ch1Code) + chars.charAt(ch2Code));
			}
			
			ch1 = "";
			for (i = 0; i < str.length; i++ ){
				var ch2:String = str.charAt(i);
				if (ch1 != ""){
					ch1Code = chars.indexOf(ch1);
					ch2Code = chars.indexOf(ch2);
					var swapCode:int = swapSymbolsByPairs[ch1Code][ch2Code];
					if (swapCode >-1){
						//надо заменить эту пару символов
						res += swapSymbols.charAt(swapCode);
						ch1 = "";
						ch2 = "";
					}else{
						//замены не находится - пишем символ 1 и надеемся найти замену для символа 2, когда он станет 1м
						res += ch1;
						ch1 = ch2;
					}
				}else{
					ch1 = ch2;
				}
			}
			if (ch2 != ""){
				res += ch2;
			}
			return res;
		}
		
		static private function unwrapPairsOfMostUsedSymbols(str:String, swappingAlphabet:String):String {
			var res:String = "";
			
			var numSwaps:int = swappingAlphabet.length;
			var swapPart:String = str.substr(0, numSwaps * 3);
			
			str = str.substr(numSwaps * 3);
			
			var vecOfSwapResults:Vector.<String> = new Vector.<String>();
			for (var i:int = 0; i < swappingAlphabet.length; i++){
				vecOfSwapResults.push(swapPart.substr(3*i+1,2))
			}
			
			for (i = 0; i < str.length; i++){
				var ch:String = str.charAt(i);
				var id:int = swappingAlphabet.indexOf(ch);
				if (id !=-1){
					res += vecOfSwapResults[id];
				}else{
					res += ch;
				}
			}
			
			return res;
		}
		
		static public function unpackHexString(str:String):String{
				
			str = unwrapPairsOfMostUsedSymbols(str, "QRSTUVWXYZ");
			str = unwrapPairsOfMostUsedSymbols(str, "IJKLMNOP");
			str = unwrapPairsOfMostUsedSymbols(str, "ABCDEFGH");			

			var res:String = "";
			var i:int = 0;
			while (i < str.length){
				var ch:String = str.charAt(i);
				if (ch == "g"){
					var k:int = i + 1;
					var num80:String = "";
					var need1More:Boolean = true;
					while (need1More){
						var ch2:String = str.charAt(k);
						if (ch2 == "g"){
							need1More = false;
						}else{
							num80 += ch2;
						}
						k++;
						if (k >= str.length){//аварийный выход при неправильной строке
							break;
						}
					}
					i = k;
					var N80:int = int(num80);
					
					for (k = 0; k < N80; k++){
						res += "80";
					}
					
				}else{
					res += ch;
					i++;
				}
			}
			return res;
		}
		//_____________________________GRAPHICS______________________________________//
		
		static public function buildImageFromTexture(tx:Texture, par:DisplayObjectContainer, posX:Number = 0, posY:Number = 0, horzAlign:String = "center", vertAlign:String = "center"):Image
		{
			var res:Image = new Image(tx);
			if ((horzAlign != null)&&(vertAlign != null))
			{
				res.alignPivot(horzAlign, vertAlign);
			}
			res.x = posX;
			res.y = posY;
			if (par)
			{
				par.addChild(res);
			}
			return res;
		}
		
		static public function buildMCFromTextures(txs:Vector.<Texture>, par:DisplayObjectContainer, posX:Number = 0, posY:Number = 0, horzAlign:String = "center", vertAlign:String = "center"):MovieClip
		{
			var res:MovieClip = new MovieClip(txs);
			if (horzAlign != null)
			{
				res.alignPivot(horzAlign, vertAlign);
			}
			res.x = posX;
			res.y = posY;
			if (par)
			{
				par.addChild(res);
			}
			return res;
		}
		
		static public function createNewFrameAroundRect(frmTex:Texture, rct:Rectangle, par:Sprite, existingSidesAr:Array = null):void
		{
			if (!existingSidesAr)
			{
				var brdLeft:Image = Routines.buildImageFromTexture(frmTex, par, 0, 0, "left", "top");
				var brdTop:Image = Routines.buildImageFromTexture(frmTex, par, 0, 0, "right", "top");
				var brdRight:Image = Routines.buildImageFromTexture(frmTex, par, 0, 0, "right", "top");
				var brdBottom:Image = Routines.buildImageFromTexture(frmTex, par, 0, 0, "left", "top");
			}
			else
			{
				if (!existingSidesAr[0])
				{
					brdLeft = Routines.buildImageFromTexture(frmTex, par, 0, 0, "left", "top");
					existingSidesAr[0] = brdLeft;
				}
				else
				{
					brdLeft = existingSidesAr[0];
					brdLeft.rotation = 0;
				}
				if (!existingSidesAr[1])
				{
					brdTop = Routines.buildImageFromTexture(frmTex, par, 0, 0, "right", "top");
					existingSidesAr[1] = brdTop;
				}
				else
				{
					brdTop = existingSidesAr[1];
					brdTop.rotation = 0;
				}
				if (!existingSidesAr[2])
				{
					brdRight = Routines.buildImageFromTexture(frmTex, par, 0, 0, "right", "top");
					existingSidesAr[2] = brdRight;
				}
				else
				{
					brdRight = existingSidesAr[2];
					brdRight.rotation = 0;
				}
				if (!existingSidesAr[3])
				{
					brdBottom = Routines.buildImageFromTexture(frmTex, par, 0, 0, "left", "top");
					existingSidesAr[3] = brdBottom;
				}
				else
				{
					brdBottom = existingSidesAr[3];
					brdBottom.rotation = 0;
				}
			}
			
			brdLeft.height = rct.height;
			brdLeft.x = rct.left;
			brdLeft.y = rct.top;
			par.addChild(brdLeft);
			
			brdTop.height = rct.width;
			brdTop.x = rct.left;
			brdTop.y = rct.top;
			brdTop.rotation = -Math.PI/2
			par.addChild(brdTop);
			
			//brdRight.alignPivot("left", "bottom");
			brdRight.height = rct.height;
			brdRight.x = rct.right;
			brdRight.y = rct.top;
			par.addChild(brdRight);
			
			//brdBottom.alignPivot("left", "top");
			brdBottom.height = rct.width;
			brdBottom.x = rct.left;
			brdBottom.y = rct.bottom;
			brdBottom.rotation = -Math.PI / 2;
			par.addChild(brdBottom);
		}
		
		static public function createImageL2LayBetween2Points(tex:Texture, x0:int, y0:int, x1:int, y1:int):Image
		{
			var img:Image = new Image(tex);
			img.alignPivot("center", "bottom");
			placeVerticalImageBetween2Points(img, x0, y0, x1, y1);
			return img;
		}
		
		static public function placeVerticalImageBetween2Points(img:Image, x0:int, y0:int, x1:int, y1:int):void
		{
			img.rotation = 0;
			img.scaleY = 1;
			
			var dx:int = x1 - x0;
			var dy:int = y1 - y0;
			var d:Number = Math.sqrt(dx * dx + dy * dy);
			img.height = d;
			var phi:Number = Math.atan2(dx, -dy);
			img.rotation = phi;
			
			img.x = x0;
			img.y = y0;
		}
		
		
		static public function showImagesVisibilityInVector(vec:Vector.<Image>, lambda:Number, vis0:Boolean = false, scl0:Number = 1, alpha0:Number = 0, vis1:Boolean = true, scl1:Number = 1, alpha1:Number = 1 ):void 
		{
			var idNum:Number = lambda * vec.length;
			var id:int = Math.floor(idNum);
			var frac:Number = idNum - id;
			for (var i:int = 0; i < vec.length; i++ ){
				var im:Image = vec[i];
				if (i<id){
					im.visible = vis1;
					im.alpha = alpha1;
					im.scale = scl1;
				}
				if (i==id){
					im.visible = vis0||vis1;
					im.alpha = alpha0 + (alpha1 - alpha0) * frac;
					im.scale = scl0 + (scl1 - scl0) * frac;
				}
				if (i>id){
					im.visible = vis0;
					if (vis0){
						im.alpha = alpha0;
						im.scale = scl0;						
					}
				}
			}
		}		
		
		//_____________________________TEXT______________________________________//
		
		static public function showNumberInAAFormat(n:Number, mustShowTiny:Boolean = false):String
		{
			if (n<0){
				return '-'+showNumberInAAFormat( -n);
			}
			var res:String = '0';
			
			if (n<1){
				if (n < 0.00049999999){
					if (n > 0){
						if (mustShowTiny){
							var log:Number = Math.log(n) * Math.LOG10E;
							var orderDigs:int = Math.floor(log/3);
							var n1:Number = n / Math.pow(10, 3 * orderDigs);	
							res = convertSmallNumber2String(n1);
							res+='e'+orderDigs*3;							
						}else{
							res = '0';
						}

					}else{
						res = '0';
					}
					
				}else{
					res = (Math.round(n*1000)/1000).toString();
					if (res.length>5){//0.12000000004
						res = res.substr(0,5);
					}
				}
			}else{
				if (n<1000){
					res = convertSmallNumber2String(n);
				}else{
					log = Math.log(n)*Math.LOG10E;
					orderDigs = Math.floor(log/3);
					n1 = n/Math.pow(10,3*orderDigs);

					res = convertSmallNumber2String(n1);
					
					if (orderDigs<=bigNumbersEndings.length){
						res+=bigNumbersEndings[orderDigs-1];
					}else{
						res+='e'+orderDigs*3;
						//if (orderDigs>=this.bigNumbersEndings.length+1+this.alphabet.length*this.alphabet.length){
						//	res+='zz';
						//}else{
						//	var id1 = (orderDigs-this.bigNumbersEndings.length-1)%this.alphabet.length;
						//	var id2 = Math.floor((orderDigs-this.bigNumbersEndings.length-1)/this.alphabet.length);
						//	res+=this.alphabet[id2]+this.alphabet[id1];
						//}
					}
					
				}
			}
			return res;
		}
		
		//1<=n<1000
		static public function convertSmallNumber2String(n:Number):String{
			var res:String = (Math.round(100*n)/100).toString();
			if (res.length>4){//0.12000000004
				res = res.substr(0,4);
			}
			if (res.charAt(res.length-1)=='.'){
				res = res.substr(0,res.length-1);
			}
			return res;
		}		
		
		static public function showNumberInOldFormat(n:Number):String
		{
			if (isNaN(n) || (n == Infinity) || (n == -Infinity))
			{
				//trace('NAN!!!')
				return '0';
			}
			var fracPart:Number = n - Math.floor(n);
			if (n < 1)
			{
				if (fracPart < 0.001)
				{
					return n.toFixed(0);
				}
				else
				{
					return n.toFixed(3);
				}
				
			}
			if (n < 10)
			{
				if (fracPart < 0.01)
				{
					return n.toFixed(0);
				}
				else
				{
					return n.toFixed(2);
				}
			}
			if (n < 100)
			{
				if (fracPart < 0.1)
				{
					return n.toFixed(0);
				}
				else
				{
					return n.toFixed(1);
				}
			}
			if (n < 10000)
			{
				return (n.toFixed(0));
			}
			
			var ln:Number = Math.log(n);
			var log10:Number = ln * Math.LOG10E;
			var numDigsInN:int = Math.floor(log10) + 1;
			var numDigs2Leave:int = numDigsInN % 3;
			if (numDigs2Leave == 0)
			{
				numDigs2Leave = 3;
			}
			var numDigs2Remove:int = numDigsInN - numDigs2Leave;
			
			var n2:Number = n / (Math.pow(10, numDigs2Remove));
			var orderSmb:String = 'z';
			switch (numDigs2Remove)
			{
			case 3: 
			{
				orderSmb = 'k';
				break;
			}
			case 6: 
			{
				orderSmb = 'm';
				break;
			}
			case 9: 
			{
				orderSmb = 'b';
				break;
			}
			case 12: 
			{
				orderSmb = 't';
				break;
			}
			case 15: 
			{
				orderSmb = 'q';
				break;
			}
			case 18: 
			{
				orderSmb = 'Q';
				break;
			}
			case 21: 
			{
				orderSmb = 's';
				break;
			}
			case 24: 
			{
				orderSmb = 'S';
				break;
			}
			case 27: 
			{
				orderSmb = 'o';
				break;
			}
			case 30: 
			{
				orderSmb = 'n';
				break;
			}
			case 33: 
			{
				orderSmb = 'd';
				break;
			}
			default: 
			{
				orderSmb = 'z';
				break;
			}
			}
			
			return n2.toFixed(3 - numDigs2Leave) + orderSmb;
		
		/*
		   //0123			0123
		   //12653			012k
		   //2375016		002m
		   //b
		   //z
		   var digs:Array = ['0', '0', '0', '0'];
		
		   if ((n >= 0.001) && (n < 1)){
		   digs[0] = '.';
		   var num:Number = n;// * 1000;
		   var id:int = 1;
		   while (id < 4){
		   num *= 10;
		   digs[id] = (Math.floor(num) % 10).toString();
		   id++;
		   }
		   }
		
		   if (n > 9999){
		   var ln:Number = Math.log(n);
		   var log10:Number = ln * Math.LOG10E;
		   var numDigsInN:int = Math.floor(log10) + 1;
		   var numDigs2Leave:int = numDigsInN % 3;
		   if (numDigs2Leave == 0){numDigs2Leave = 3; }
		   var numDigs2Remove:int = numDigsInN - numDigs2Leave;
		   var n1:int = Math.round(n / (Math.pow(10, numDigs2Remove)));
		
		   switch (numDigs2Remove){
		   case 3:{digs[digs.length - 1] = 'k'; break; }
		   case 6:{digs[digs.length - 1] = 'm'; break; }
		   case 9:{digs[digs.length - 1] = 'b'; break; }
		   case 12:{digs[digs.length - 1] = 't'; break; }
		   case 15:{digs[digs.length - 1] = 'q'; break; }
		   case 18:{digs[digs.length - 1] = 'Q'; break; }
		   case 21:{digs[digs.length - 1] = 's'; break; }
		   case 24:{digs[digs.length - 1] = 'S'; break; }
		   case 27:{digs[digs.length - 1] = 'o'; break; }
		   case 30:{digs[digs.length - 1] = 'n'; break; }
		   case 33:{digs[digs.length - 1] = 'd'; break; }
		   default:{digs[digs.length - 1] = 'z'; break; }
		   }
		
		   id = digs.length-2;
		
		   }else{
		   id = digs.length - 1;
		   n1 = n;
		   }
		   while (n1 != 0){
		   digs[id] = (n1 % 10).toString();
		   n1 = int(n1 / 10);
		   id--;
		   }
		   var res:String = '';
		   var hasLeadZero:Boolean = true;
		   for (var i:int = 0; i < digs.length; i++ ){
		   if ((digs[i] != '0')&&(hasLeadZero)){
		   hasLeadZero = false;
		   }
		   if (!hasLeadZero){
		   res += digs[i];
		   }
		   }
		   if (res == ''){
		   res='0'
		   }
		   if (res == 'z'){
		   StatsWrapper.stats.logText('WARNING! number ' + n.toString() + ' shown as z!');
		   }
		   //trace('showNUmberinFormat called', n, res)
		   return res;*/
		}
		
		static public function convertSeconds2SmallTimeString(sec:Number):String
		{
			if (sec < 10)
			{
				return sec.toFixed(1);
			}
			else
			{
				if (sec < 3600)
				{
					var mm:int = sec / 60;
					var ss:int = sec % 60;
					var res:String = mm.toString() + ':';
					if (ss < 10)
					{
						res += '0';
					}
					res += ss.toString();
					
					return res;
				}
				else
				{
					if (sec < 24 * 3600)
					{
						var hh:int = (sec / 60) / (60);
						mm = (sec / 60) % 60;
						
						return hh.toString() + 'TXID_TIMEUNIT_HOUR ' + mm.toString() + 'TXID_TIMEUNIT_MIN';
					}
					else
					{
						if (sec < 365 * 24 * 3600)
						{
							var dd:int = (sec / 3600) / (24);
							hh = (sec / 3600) % (24);
							return dd.toString() + 'TXID_TIMEUNIT_DAY ' + hh.toString() + 'TXID_TIMEUNIT_HOUR';
						}
						else
						{
							if (sec < 100 * 365.25 * 24 * 3600)
							{
								var yy:int = (sec / (3600 * 24)) / (365.25);
								dd = (sec / (3600 * 24)) % (365.25);
								return yy.toString() + 'TXID_TIMEUNIT_YEAR ' + dd.toString() + 'TXID_TIMEUNIT_DAY';
							}
							else
							{
								return ('ages');
							}
						}
					}
				}
			}
		}
		
		static public function convertSeconds2TimeString(sec:int):String
		{
			if (sec == 0)
			{
				return '0:00'
			}
			var ss:int = sec % 60;
			sec = sec / 60;
			var mm:int = sec % 60;
			sec = sec / 60;
			var hh:int = sec % 24;
			var dd:int = sec / 24;
			var ar:Array = [dd, hh, mm, ss];
			var smbs:Array = [':', ':', ':', ''];
			var res:String = '';
			var hasLeadingZero:Boolean = true;
			for (var i:int = 0; i < ar.length; i++)
			{
				if (hasLeadingZero && (ar[i] != 0))
				{
					hasLeadingZero = false;
				}
				if (!hasLeadingZero)
				{
					var val:int = ar[i];
					if (val < 10)
					{
						res += '0';
					}
					res += val.toString();
					res += smbs[i];
						//if (i < smbs.length - 1){
						//	res += ' ';
						//}
				}
			}
			
			if (sec < 60)
			{
				res = '0:' + res;
			}
			return res;
		}
		
		static public function breakNumToDigits(val:int, numDis:int):Array
		{
			var res:Array = [];
			var n:int = val;
			var id:int = numDis;
			while (id >= 0)
			{
				res[id] = n % 10;
				n = Math.floor(n / 10);
				id--;
			}
			return res;
		}
		
		static public function glueArrayDigits(ar:Array):int
		{
			var res:int = 0;
			for (var i:int = ar.length - 1; i >= 0; i--)
			{
				res *= 10;
				res += ar[i];
			}
			return res;
		}
		
		static public function romanNumber(n:int):String
		{
				var romanDigitsGroups:Array=[
					["","","",""],
					["I", "X", "C","M"],
					["II", "XX" , "CC" , "MM"],
					["III", "XXX" , "CCC" , "MMM"],
					["IV" , "XL" , "CD" , "MMMM"],
					["V" , "L" , "D" ,"" ],
					["VI" , "LX" , "DC" ,""],
					["VII" , "LXX" , "DCC" ,"" ],
					["VIII" , "LXXX" , "DCCC" ,""],
					["IX" , "XC" ,"CM" ,"" ]
				]
			var res:String = "";
			
			var id:int=0;//номер розряду (рахуючи справа)
			var n1:int = n%5000;
			while (n1>0){
				var d:int = n1%10;
				n1 = Math.floor(n1/10);
				res=romanDigitsGroups[d][id]+res;
				id++;
			}
			
			return res
		}
		
		static public function decodeCode(cd:String, alphabet:String):uint 
		{
			var num:uint = 0;
			for (var i:int = 0; i < cd.length; i++ ){
				var ch:String = cd.charAt(i);
				var id:int = alphabet.indexOf(ch);
				num = num * alphabet.length;
				num = num + id;
			}
			return num;
		}
		
		static public function encodeCode(num:uint, alphabet:String):String {
			var str:String = '';
			while (num > 0){
				var rem:uint = num % alphabet.length;
				str = alphabet.charAt(rem) + str;
				num = Math.floor(num / alphabet.length)
			}
			if (str == ''){
				str = alphabet[0];
			}
			return str;
		}
		
		static public function getJunkString(len:uint, alphabet:String):String {
			var res:String = "";
			for (var i:int = 0; i < len; i++ ){
				res += alphabet.charAt(Math.floor(Math.random() * alphabet.length));
			}
			return res;
		}
		
		static public function ratio2String(ratio:Number, maxDigsTot:int):String
		{
			ratio = Math.abs(ratio);
			var bestDelta:Number = 0;
			var bestM:int;
			var bestN:int;
			
			var a:int = 0;
			var b:int = 1;
			var c:int = 1;
			var d:int = 0;
			while (true)
			{
				var m:int = a + c;
				var n:int = b + d;
				var frac:Number = m / n;
				var delta:Number = Math.abs(frac - ratio);
				if (delta < 0.01 * ratio)
				{
					var res:String = m.toString() + ':' + n.toString();
					return res;
					break;
				}
				if (frac < ratio)
				{
					a = m;
					b = n;
				}
				else
				{
					c = m;
					d = n;
				}
				
				var digsM:int = Math.floor(Math.log(m) / Math.LN10) + 1;
				var digsN:int = Math.floor(Math.log(n) / Math.LN10) + 1;
				
				if (digsM + digsN > maxDigsTot)
				{
					res = bestM.toString() + ':' + bestN.toString();
					return res;
					break;
				}
				
				if (bestDelta == 0)
				{
					bestDelta = delta;
					bestM = m;
					bestN = n;
				}
				else
				{
					if (delta < bestDelta)
					{
						bestDelta = delta;
						bestM = m;
						bestN = n;
					}
				}
			}
			return ":"
		}
		
		static public function isStringInArray(str:String, ar:Array):Boolean
		{
			var res:Boolean = false;
			for (var i:int = 0; i < ar.length; i++)
			{
				if (str == ar[i])
				{
					res = true;
					break;
				}
			}
			return res;
		
		}
		
		static public function doesStringHaveSomethingExcept(str:String, allowedSymbols:String):Boolean 
		{
			var res:Boolean = false;
			for (var i:int = 0; i < str.length; i++ ){
				var ch:String = str.charAt(i);
				if (allowedSymbols.indexOf(ch) ==-1){
					res = true;
					break;
				}
			}
			return res;
		}
		
		static public function buildBitBtn(cap:String, icId:int, par:DisplayObjectContainer, onClick:Function=null, ax:int=0, ay:int=0):BitBtn 
		{
			var res:BitBtn = new BitBtn();
			if (icId ==-1){
				res.setIconTextMode("text");
			}else{
				res.setIcon(icId);
			}
			res.setCaption(cap);
			res.x = ax;
			res.y = ay;
			res.registerOnUpFunction(onClick);
			if (par){
				par.addChild(res);
			}
			
			return res;
		}

		
		static public function selectValueByKey(arOfValues:Array, arOfKeys:Array, key:String):String 
		{
			var id:int = arOfKeys.indexOf(key);
			if (id==-1){
				id = 0;
			}
			return arOfValues[id];
		}

		
		static public function selectNumValueByKey(arOfValues:Array, arOfKeys:Array, key:String):Number 
		{
			var id:int = arOfKeys.indexOf(key);
			if (id==-1){
				id = 0;
			}
			return arOfValues[id];
		}
		
		static public function getObjectPropertyValue(ob:Object, code:String, defVal:*):* 
		{
			if (ob.hasOwnProperty(code)){
				return ob[code];
			}else{
				return defVal
			}
		}
		
		//static public function findCorrectFrameForCoinVal(coinVal:Number):int 
		//{
		//	//TODO: чтобы не возникало непоняток у игроков, надо показывать всегда монету, не превосходящую реального значения денег 
		//	var coinValsAr:Array = [1, 2, 4, 8, 12, 32, 64, 128, 256, 512, 
		//				1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288,
		//				1048576, 2097152, 4194304, 8388608, 16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 
		//				1073741824, 2147483648, 4294967296, 8589934592, 17179869184, 34359738368, 68719476736, 137438953472, 274877906944, 549755813888
		//							];
		//	var coinId:int = 0;
		//	if (coinVal > coinValsAr[coinValsAr.length - 1]){
		//		coinId = coinValsAr.length - 1;
		//	}else{
		//		var minDelta:Number = coinVal - coinValsAr[coinId];
		//		for (var i:int = 0; i < coinValsAr.length; i++ ){
		//			var delta:Number = coinVal - coinValsAr[i];
		//			if (delta >= 0){
		//				if (delta < minDelta){
		//					minDelta = delta;
		//					coinId = i;
		//				}					
		//			}
		//
		//		}				
		//	}
		//
		//	return coinId;
		//}
	
		//static public function convertNumber2SignedFloatString(val:Number, needsPlus:Boolean=true):String 
		//{
		//	var absVal:Number = Math.abs(val);
		//	var decVal:Number = absVal - Math.floor(absVal);
		//	if (Math.abs(val) < 10){
		//		if (decVal < 0.1){
		//			var res:String = val.toFixed(0);
		//		}else{
		//			res = val.toFixed(1);
		//		}
		//	}else{
		//		res = val.toFixed(0);
		//	}
		//	if (needsPlus){
		//		if (val > 0){
		//			res = '+' + res;
		//		}
		//	}
		//	
		//	return res;
		//}
	
		//static public function nameBonusSizeLoc(val:int):String 
		//{
		//	var names:Array = ['tiny', 'very small', 'small', 'average', 'sufficient', 'quite big', 'big', 'huge', 'fantastic'];
		//	var numSeparators:Array = [1, 2, 3, 5, 8, 13, 21, 34];//working as <=
		//	var resId:int = 0;
		//	for (var i:int = 0; i < numSeparators.length; i++){
		//		if (val <= numSeparators[i]){
		//			//resId = i;
		//			break;
		//		}
		//	}
		//	resId = i;
		//	return Translator.translator.getLocalizedVersionOfText(names[resId]);
		//}
	
		//static public function canSeeVideo():Boolean
		//{
		//	//Cc.log('Checiking canSeeVideo');
		//	//return true;
		//	var res:Boolean = false;
		//	//Cc.log('Main.self.isReleasingWithSDKs:',Main.self.isReleasingWithSDKs);
		//	if (Main.self.isReleasingWithSDKs){
		//		//Cc.log('checking Enhance');
		//		//Cc.log(Enhance);
		//		//Cc.log(Enhance.getInstance());
		//		//Cc.log('EnhanceWrapper.isRewardedAdReady()',EnhanceWrapper.isRewardedAdReady(), 'EnhanceWrapper.isInterstitialReady()', EnhanceWrapper.isInterstitialReady());
		//		if (EnhanceWrapper.isRewardedAdReady()){
		//			res = true;
		//		}else{
		//			if (EnhanceWrapper.isInterstitialReady()){
		//				res = true;
		//			}
		//		}
		//	}
		//	//if (res){
		//	//	if (PlayersAccount.account.GDPRConsentAnswer == 'denied'){
		//	//		res = false;
		//	//	}
		//	//}
		//	return res;
		//}
	
		//static public function logPropsOfOb(ob:Machine):void{
		//	trace(ob, ob.coefFromSystem, ob.coef2System);
		//}
	
		//static public function loadValueFromSaveOrUseDefault(saveAr:Array, readId:int, ar2Unload:Array, defaultVal:Number, minVersion:String):int
		//{
		//	if (isSaveVersionIsAtLeast(PlayersAccount.account.currentlyLoadedSaveVersion, minVersion)){
		//		ar2Unload[0] = saveAr[readId];
		//		return readId + 1;
		//	}else{
		//		ar2Unload[0] = defaultVal;
		//		return readId;
		//	}
		//}
	
		//static public function movePt2ReadInBMD(pt:Point, side:int):void 
		//{
		//	pt.x++;
		//	if (pt.x >= side){
		//		pt.x = 0;
		//		pt.y++;
		//	}
		//}
	
		//static public function glueSaveDigits2String(versionDigs:Array):String 
		//{
		//	var res:String = versionDigs[0].toString();
		//	for (var i:int = 1; i < versionDigs.length; i++ ){
		//		res += ('.' + versionDigs[i].toString());
		//	}
		//	return res;
		//}
	
		//static public function transformSaveVersion2NumArray(gameVersion:String):Array 
		//{
		//	var arOfParts:Array = gameVersion.split('.');
		//	var arOfDigs:Array = [];
		//	for (var i:int = 0; i < arOfParts.length; i++ ){
		//		arOfDigs.push(int(arOfParts[i]));
		//	}
		//	return arOfDigs;
		//}
	
		//static public function getStringOfInWithLeadingZeroes(n:int, len:int):String 
		//{
		//	var res:String = n.toString();
		//	while (res.length < len){
		//		res = '0' + res;
		//	}
		//	return res;
		//}
	
		//static public function showDateAsFileName(date:Date):String 
		//{
		//	var allowedFileSymbols:String = '1234567890-_|qwertyuiopasdfghjklzxcvbnm.';
		//	
		//	var res:String = date.toString();
		//	res = res.toLowerCase();
		//	var id:int = 0;
		//	for (var i:int = 0; i < res.length; i++ ){
		//		var ch:String = res.charAt(i);
		//		if (allowedFileSymbols.indexOf(ch) ==-1){
		//			res.replace(ch, '_');
		//		}
		//	}
		//	return res;
		//}
	
		//static public function convertString2Int(str:String):int
		//{
		//	for (var i:int = 0; i < str.length-1; i++ ){
		//		if (str.charAt(i) != '0'){
		//			break;
		//		}
		//	}
		//	var str2:String = str.substr(i, str.length - i);
		//	return int(str2);
		//}
	
		//static public function conversion2String(ratio:Number, isRight:Boolean = true):String {
		//	if (ratio == 0){
		//		return ('0-0')
		//	}
		//	var valFrom:Number = 1;
		//	var valTo:Number = ratio;
		//	if (ratio < 1){
		//		valFrom = 1/ratio;
		//		valTo = 1;
		//	}
		//	
		//	if (isRight){
		//		return Routines.showNumberInAAFormat(valFrom) + ' \u21e8 ' + Routines.showNumberInAAFormat(valTo);
		//	}else{
		//		return Routines.showNumberInAAFormat(valTo) + ' \u21e6 ' + Routines.showNumberInAAFormat(valFrom);
		//	}
		//	
		//}
	
		//static public function showNumberInSmallFormat(n:Number):String{
		//	if (isNaN(n) || (n==Infinity) ||(n==-Infinity)){
		//		//trace('NAN!!!')
		//		return '0';
		//	}
		//	var fracPart:Number = n - Math.floor(n);
		//	if (n < 1){
		//		if (fracPart < 0.05){
		//			if (fracPart < 0.001){
		//				return "0"
		//			}else{
		//				return ">0"
		//			}
		//		}else{
		//			return (Math.round(n * 10) / 10).toFixed(1);
		//		}
		//	}
		//	n = Math.round(n * 10) / 10;
		//	
		//	if (n < 10){
		//		return n.toFixed(1);
		//	}
		//	
		//	if (n < 100){
		//		return n.toFixed(0);
		//	}
		//	
		//	if (n < 1000){
		//		return showNumberInAAFormat(n);
		//	}
		//	
		//	if (n < 999999){
		//		return showNumberInSmallFormat(n / 1000) + 'k';
		//	}
		//	
		//	return showNumberInAAFormat(n);
		//	
		//}		
	
		////работает с 3м радиусам
		//static public function selectCircleImageFrameAndScaleFromRad(mc:MovieClip, rad:Number, dobRads:Array):void 
		//{//20,80,160
		//	if (rad < dobRads[0]){
		//		var frid:int = 0;
		//		var baseR:Number = dobRads[0];
		//	}else{
		//		if (rad < (dobRads[1]+dobRads[2])/2){
		//			frid = 1;
		//			baseR = dobRads[1];
		//		}else{
		//			frid = 2;
		//			baseR = dobRads[2];
		//		}
		//	}
		//	mc.currentFrame = frid;
		//	mc.scale = rad / baseR;			
		//}
	
		//static public function findScale4MC2FitRad(rad:Number, dobRads:Array):int{
		//	if (rad < dobRads[0]){
		//		//var frid:int = 0;
		//		var baseR:Number = dobRads[0];
		//	}else{
		//		if (rad < (dobRads[1]+dobRads[2])/2){
		//			//frid = 1;
		//			baseR = dobRads[1];
		//		}else{
		//			//frid = 2;
		//			baseR = dobRads[2];
		//		}
		//	}
		//	return rad / baseR;		;			
		//}
	
		//static public function findFrame4MC2FitRad(rad:Number, dobRads:Array):int
		//{
		//	if (rad < dobRads[0]){
		//		var frid:int = 0;
		//	//	var baseR:Number = dobRads[0];
		//	}else{
		//		if (rad < (dobRads[1]+dobRads[2])/2){
		//			frid = 1;
		//		//	baseR = dobRads[1];
		//		}else{
		//			frid = 2;
		//		//	baseR = dobRads[2];
		//		}
		//	}
		//	return frid;
		//}
	
		//static public function buildLinearAndAsyptoticGrowth(inVal:Number, transitionBetweelLinearAndAsypt:Number, out4Min:Number, out4Infty:Number, out4Transition:Number):Number 
		//{
		//	var res:Number = 0;
		//
		//	var linearSpeed:Number = (out4Transition - out4Min) / transitionBetweelLinearAndAsypt;
		//	if (inVal < transitionBetweelLinearAndAsypt){
		//		res = out4Min + linearSpeed * inVal;
		//	}else{
		//		var coef:Number = (out4Infty - out4Transition) / (0.5 * Math.PI);
		//		var coef2:Number = (out4Transition - out4Min) / (transitionBetweelLinearAndAsypt - 0);
		//		
		//		res = Math.atan(coef2/coef * (inVal - transitionBetweelLinearAndAsypt)) * coef + out4Transition;
		//		
		//		//
		//		//
		//		//var addVal4Infty:Number = out4Infty - out4Transition;
		//		////при каком сходном значении будет достигнут потолок, если сохранится скорость линейная
		//		//var valInf:Number = addVal4Infty / linearSpeed + transitionBetweelLinearAndAsypt;
		//		////с каждой такой дистанцией скорость будет убывать в 2 раза
		//		//var speedDecStep:Number = (valInf - transitionBetweelLinearAndAsypt) / 2;
		//		//
		//		//var stepIndex:Number = (inVal - transitionBetweelLinearAndAsypt) / speedDecStep;
		//		//var intIndex:int = Math.floor(stepIndex);
		//		//var addVal0:Number = (1 - Math.pow(0.5, intIndex)) * addVal4Infty;
		//		//
		//		//var currentSpeed:Number = linearSpeed * Math.pow(0.5, intIndex);
		//		//addVal0 += (stepIndex - intIndex) * speedDecStep * currentSpeed;
		//		//
		//		//res = out4Transition + addVal0;
		//		////var frac:Number = inVal / transitionBetweelLinearAndAsypt;
		//		////res = out4Infty - (out4Infty - out4Transition) / frac;
		//	}
		//	return res;			
		//}		
	
		//static public function buildRootAndAsyptoticGrowth(inVal:Number, transitionBetweelLinearAndAsypt:Number, out4Min:Number, out4Infty:Number, out4Transition:Number):Number 
		//{
		//	var res:Number = 0;
		//
		//	if (inVal < transitionBetweelLinearAndAsypt){
		//		var a:Number = (out4Transition - out4Min) / (Math.sqrt(Math.sqrt(transitionBetweelLinearAndAsypt)) - 1);
		//		var b:Number = out4Min - a;
		//		res = a * Math.sqrt(Math.sqrt(inVal)) + b;
		//		//res = out4Min + (out4Transition - out4Min) * inVal / transitionBetweelLinearAndAsypt;
		//	}else{
		//		var frac:Number = inVal / transitionBetweelLinearAndAsypt;
		//		res = out4Infty - (out4Infty - out4Transition) / frac;
		//	}
		//	return res;			
		//}
	
		//static public function formatNumberInKSymbols(val:Number, k:int):String
		//{
		//	if (val < 0){
		//		return '-' + formatNumberInKSymbols( -val, k - 1);
		//	}
		//	
		//	if (val < 1){
		//		if (val < 1 * Math.pow(10, -(k - 1))){
		//			var res:String = '';
		//			for (var i:int = 0; i < k; i++ ){
		//				res += '0';
		//			}
		//			return res;
		//		}else{
		//			var val2:int = Math.floor(val * Math.pow(10, (k - 1)));
		//			var str:String = val2.toFixed(0);
		//			var len:int = str.length;
		//			for (i = len; i < k - 1; i++ ){
		//				str = '0' + str;
		//			}
		//			res = '0.' + str;
		//			return res;
		//		}
		//	}
		//	
		//	
		//	
		//	var ln:Number = Math.log(val);
		//	var log10:Number = ln * Math.LOG10E;
		//	var numDigsInN:int = Math.floor(log10) + 1;
		//	
		//	if (numDigsInN <= k){
		//		res = val.toFixed(k-numDigsInN);
		//		return res;
		//	}else{
		//		var numDigs2Remove:int = numDigsInN - k+1;
		//		var orderOfMagnitude:int = Math.ceil(numDigs2Remove / 3);
		//		
		//		numDigs2Remove = orderOfMagnitude * 3;
		//		
		//		val2 = val / Math.pow(10, 3 * orderOfMagnitude);
		//		
		//		var lettersSmbs:String = 'kmbtqQsSondUDTz';
		//		if (orderOfMagnitude-1 >= lettersSmbs.length){
		//			var ch:String = 'z';
		//		}else{
		//			ch=lettersSmbs.charAt(orderOfMagnitude-1);
		//		}
		//		return formatNumberInKSymbols(val2, k - 1) + ch;
		//	}
		//}
	
		//static public function buildCWOfRadius(par:Sprite, baseTex:Texture, r:Number, toothTex:Texture = null, toothW:Number=40):void
		//{
		//	var base:Image = Routines.buildImageFromTexture(baseTex, par);
		//	base.scale = (r - 5) / 100;
		//	
		//	base.rotation = 2 * Math.PI * Math.random();
		//	
		//	if (toothTex){
		//		var circumference:Number = 2 * Math.PI * (r-5);
		//	//	var toothW:Number = 40;
		//		var toothNumber:int = Math.round(circumference / toothW);
		//		if (toothNumber == 0){toothNumber = 1}
		//		toothW = circumference / toothNumber;
		//		var toothPhi:Number = 2 * Math.PI / toothNumber;
		//		
		//		for (var i:int = 0; i < toothNumber; i++ ){
		//			var tx:Number = (r-4-5) * Math.sin(i * toothPhi);
		//			var ty:Number = -(r-4-5) * Math.cos(i * toothPhi);
		//			var tooth:Image = Routines.buildImageFromTexture(toothTex, par, tx, ty, "center", "bottom");
		//			tooth.scale = 0.75;
		//			tooth.rotation = i * toothPhi;
		//			
		//			tooth.touchable = false;
		//			//tooth.color = cl;
		//		}				
		//	}			
		//}
	
		//static public function findValIncrease(val0:Number, val1:Number):String{
		//	var res:String = '+0';
		//	if (val0 == 0){
		//		res = '+' + showNumberInAAFormat(val1-val0);
		//	}else{
		//		var frac:Number = val1 / val0;
		//		if (frac >= 1.999){
		//			res='x'+showNumberInAAFormat(frac);
		//		}else{
		//			res = '+' + showNumberInAAFormat(val1-val0);
		//		}
		//	}
		//	return res;
		//}
	
		//static public function simplePlusFunction(prevRes:Number, numNodesMet:int, k:int):Number 
		//{
		//	return prevRes + 1 * Math.pow(2, numNodesMet);
		//}
		//
		//static public function doubleAtNodeFunction(prevRes:Number, numNodesMet:int):Number 
		//{
		//	return prevRes * 2;
		//}
	
		//static public function findValueInArray(ar:Array, ch:String, defVal:Number):Number 
		//{
		//	var res:Number = defVal;
		//	for (var k:int = 0; k < ar.length; k++ ){
		//		var str:String = ar[k];
		//		if (str.charAt(0) == ch){
		//			res = Number(str.substr(1, str.length - 1));
		//			break;
		//		}
		//	}
		//	return res;
		//}
	
		//static public function getProjectionOfPoint2Line(ptX:Number, ptY:Number, ptStart:Point, ptEnd:Point):Point
		//{
		//	var res:Point = new Point();
		//	//проекция будет вертикальная
		//	//var yIntersection:Number = (trk.ptEnd.y - trk.ptStart.y) / (trk.ptEnd.x - trk.ptStart.x) * (fx - trk.ptStart.x) + trk.ptStart.y;
		//	//res.x = ptX;
		//	//res.x = ptStart.x + (ptEnd.x - ptStart.x) / (ptEnd.y - ptStart.y) * (ptX - ptStart.x);
		//}
	
	}

}