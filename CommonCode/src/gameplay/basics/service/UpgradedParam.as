package gameplay.basics.service 
{
	import gameplay.basics.ProcessorOfItems;
	/**
	 * ...
	 * @author ...
	 */
	public class UpgradedParam 
	{
		private var cachedLevel:int;
		private var cachedValue:Number;
		public var paramName:String;
		public var ownerMachine:ProcessorOfItems;
		public var paramExplanation:String;
		public var paramUnits:String;
		public var coef2VisualizeUnits:Number;
		public var valAt0:Number;
		public var isLevelANodeFunc:Function;
		public var simpleValIncFunc:Function;
		public var nodeValIncFunc:Function;
		public var isReciprocal4Show:Boolean;
		public var masterCoef:Number;
		public var levelCap:int;
		public var isTime:Boolean=false;
		
		public function UpgradedParam(nm:String, mch:ProcessorOfItems, v0:Number, expl:String, unts:String, cf2u:Number, nodeDefF:Function, valSimpleF:Function, valNodeF:Function, isRec4Show:Boolean, isTm:Boolean=false){
			this.paramName = nm;
			this.ownerMachine = mch;
			
			this.paramExplanation = expl;
			this.paramUnits = unts;
			this.coef2VisualizeUnits = cf2u;
			
			this.valAt0 = v0;
			
			this.isLevelANodeFunc = nodeDefF;//f(k)-> boolean
			this.simpleValIncFunc = valSimpleF;//f(prevRes, numNodesMet, k)->number
			this.nodeValIncFunc = valNodeF;//f(prevRes, numNodesMet)-> number
			
			this.cachedLevel = -1;
			this.cachedValue = 0;
			
			this.isReciprocal4Show = isRec4Show;//отображать ли обратное значение при формировании строки
			
			this.isTime = isTm;
			
			this.masterCoef = 1;//сюда рименяются глобальные модификаторы мира
			this.levelCap = -1;//максимлаьный уровень апгрейда			
		}
		public function getValue4Level(lvl:int):Number{
			if (lvl != this.cachedLevel){
				this.cachedValue = this.updateCachedValue4Level(lvl);
				this.cachedLevel = lvl;
			}
			return this.cachedValue * this.masterCoef;
		}
		
		public function getValue2Show4Level(lvl:int):Number{
			var val:Number = this.getValue4Level(lvl);
			if (this.isReciprocal4Show ){
				val = 1/val;
			}
			val*=this.coef2VisualizeUnits;
			
			return val;
		}
		
		private function updateCachedValue4Level(lvl:int):Number{
			// //console.log('updateCachedValue4Level', lvl,  this.valAt0)
			var res:Number = this.valAt0;
			var numNodesMet:int = 0;
			
			for (var i:int=1; i <= lvl; i++){
				if (this.isLevelANodeFunc(i)){
					res = this.nodeValIncFunc(res, numNodesMet);
					numNodesMet++;
				}else{
					res = this.simpleValIncFunc(res, numNodesMet, i);
				}
				// //console.log('res=', res);
			}
			// //console.log('==res=', res);
			return res;
		}
		
		
		public function clone4Machine(mch:ProcessorOfItems):UpgradedParam{
			return new UpgradedParam(this.paramName, mch, this.valAt0, 
									this.paramExplanation, this.paramUnits, this.coef2VisualizeUnits,
									this.isLevelANodeFunc, this.simpleValIncFunc, this.nodeValIncFunc,
									this.isReciprocal4Show,this.isTime);
		}	
		
		public function willHaveNodeInNext(dL):Boolean{
			var res:Boolean = false;
			for (var i:int=this.ownerMachine.upgradeLevel+1; i<=this.ownerMachine.upgradeLevel+dL; i++){
				if (this.isLevelANodeFunc(i)){
					res=true;
					break;
				}
			}
			return res;
		}
		//outerCoef - чтобы показать внешний бонус, действующий на апгрейдный параметр
		public function buildCurrentStringAsAr(dL:int=0, outerCoef:Number=1):Array{
			return buildCurrentStringAsArWoMachine(this.ownerMachine.upgradeLevel, dL, outerCoef);	
		}
		
		public function showEffectString(dL:int):String{
			return showEffectStringWoMachine(this.ownerMachine.upgradeLevel, dL);
		}
		
		public function willHaveNodeInNextWoMachine(L0:int, dL:int):Boolean{
			var res:Boolean = false;
			for (var i:int=L0+1; i<=L0+dL; i++){
				if (this.isLevelANodeFunc(i)){
					res=true;
					break;
				}
			}
			return res;
		}

		//outerCoef to show effect of the world's bonuses
		public function buildCurrentStringAsArWoMachine(L0:int, dL:int=0, outerCoef:Number=1):Array{
			
			var val:Number = this.getValue2Show4Level(L0);
			val *= outerCoef;
			if (this.isTime){
				var resAr:Array = [
							this.paramName+': ', 
							Routines.convertSeconds2SmallTimeString(val)
				]				
				
			}else{
				resAr = [
							this.paramName+': ', 
							Routines.showNumberInAAFormat(val)+' '+this.paramUnits
				]				
			}


			
			if (dL>0){
				var val2:Number = this.getValue2Show4Level(L0 + dL);
				val2 *= outerCoef;
				
				if (this.isTime){
					resAr.push(
						" => ",
						"("+Routines.convertSeconds2SmallTimeString(val2)+")"
					)					
					
				}else{
					resAr.push(
						" => ",
						"("+Routines.showNumberInAAFormat(val2)+")"
					)					
				}

			}
			
			return resAr;		
		}
		
		public function showEffectStringWoMachine(L0, dL):String{
			var val1:Number = this.getValue2Show4Level(L0);
			var val2:Number = this.getValue2Show4Level(L0+dL);
			
			if (this.isTime){
				return Routines.convertSeconds2SmallTimeString(val1)
								+' -> '+
						Routines.convertSeconds2SmallTimeString(val2);				
			}else{
				return Routines.showNumberInAAFormat(val1)
								+' -> '+
						Routines.showNumberInAAFormat(val2);				
			}
		}		
	}

}