package service 
{
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author ...
	 */
	public class ImageModifier 
	{
		private var affectedDob:DisplayObject;
		public var phiGathered:Number = 0;
		public var phiCycleLength:Number = 0;
		private var maxNumCycles:int = 1;
		private var cyclesMade:int = 0;
		public var isAnimating:Boolean = false;
		
		public var isRelative:Boolean = false;
		public var relativeSnapshot:DobViewSnapshot = new DobViewSnapshot();
		
		public var viewsSnapshots:Vector.<DobViewSnapshot>;

		private var modifiedPropsNames:Array = ["x", "y", "rotation", "scaleX", "scaleY", "skewX", "skewY", "alpha", "visible"];
		private var modifiedProperties:Vector.<Boolean> = new Vector.<Boolean>();
		private var modifiedPropsIds:Vector.<int> = new Vector.<int>();
		//private var arrayOfMatrixesq
		
		public var lambdaAfterAnimCompletion:Number = 1;
		public var isPhiBased:Boolean = true;
		public var debugName:String = '';
		public var isLogging:Boolean = false;
		public var hasCycleCompleted:Boolean = false;
		public var lastLambda:Number = 0;
		public var preLastLambda:Number = 0;
		
		private var timeRunFunction:Function//(0..1->0..1)
		
		public function ImageModifier() 
		{
			viewsSnapshots = new Vector.<DobViewSnapshot>();
			for (var i:int = 0; i < 9; i++ ){
				modifiedProperties[i] = false;
			}
			
			relativeSnapshot = new DobViewSnapshot();
		}
		
		public function registerDob(dob:DisplayObject, phTot:Number):void{
			affectedDob = dob;
			phiCycleLength = phTot;
			
			var dvs:DobViewSnapshot = new DobViewSnapshot();
			if (!isRelative){
				dvs.fromDob(0, affectedDob);
			}else{
				dvs.fromData(0);
			}
			
			viewsSnapshots.push(dvs);
			dvs = new DobViewSnapshot();
			if (!isRelative){
				dvs.fromDob(1, affectedDob);
			}else{
				dvs.fromData(1);
			}
			
			viewsSnapshots.push(dvs);
			//dob.transformationMatrix
		}

		private function getDobPropertyId(id:int):Number{
			switch (id){
				case 0:{
					return affectedDob.x;
					break;
				}
				case 1:{
					return affectedDob.y;
					break;
				}
				case 2:{
					return affectedDob.rotation;
					break;
				}
				case 3:{
					return affectedDob.scaleX;
					break;
				}
				case 4:{
					return affectedDob.scaleY;
					break;
				}
				case 5:{
					return affectedDob.skewX;
					break;
				}
				case 6:{
					return affectedDob.skewY;
					break;
				}
				case 7:{
					return affectedDob.alpha;
					break;
				}
				case 8:{
					return affectedDob.visible?1:0;
					break;
				}
			}
			return 0;
		}
		
		public function addAnimNode(lambda:Number, cx:Number=0, cy:Number=0, rot:Number=0, scaleX:Number=1, scaleY:Number=1, skewX:Number=0, skewY:Number=0, alpha:Number=1, vis:Number=1):void{
			var dvs:DobViewSnapshot = new DobViewSnapshot();
			dvs.fromData(lambda, cx, cy, rot, scaleX, scaleY, skewX, skewY, alpha, vis);
			for (var i:int = 0; i < modifiedProperties.length; i++ ){
				if (
					((dvs.getPropertyId(i) != getDobPropertyId(i))&&!isRelative) ||
					((dvs.getPropertyId(i)!=viewsSnapshots[0].getPropertyId(i))&&isRelative)
				){
					modifiedProperties[i] = true;
					if (modifiedPropsIds.indexOf(i) ==-1){
						modifiedPropsIds.push(i);
					}
				}
			}	
			if ((lambda != 1) && (lambda != 0)){
				viewsSnapshots.push(null);
				for (i = viewsSnapshots.length - 1; i>0; i-- ){
					if (viewsSnapshots[i - 1].momentLambda > lambda){
						viewsSnapshots[i] = viewsSnapshots[i - 1];
					}else{
						viewsSnapshots[i] = dvs;
						break;
					}
				}
			}else{
				if (lambda == 1){
					viewsSnapshots[viewsSnapshots.length - 1] = dvs;
				}else{
					viewsSnapshots[0] = dvs;
				}
				
			}
		}
		
		public function startAnimation(nCYcles:int, phi0:Number):void{
			if (!affectedDob){return}
			if (viewsSnapshots.length<2){return}			
			
			cyclesMade = 0;
			maxNumCycles = nCYcles;
			//if (phi0 !=-1){
				phiGathered = phi0;
			//}
			
			isAnimating = true;
			hasCycleCompleted = false;
			//if (isLogging){
				//trace(debugName, ' startAnimation:', nCYcles, phi0, 'IsAnimating:', isAnimating );
			//}
			
			if (!isRelative){
				relativeSnapshot.fromData(0);
			}
		}
		
		public function doAnimStep(dPh:Number):void{
			hasCycleCompleted = false;
			if (dPh < 0){dPh = 0; }
			if (isAnimating){
				//Main.self.debugTimesController.prepare2LogTimeOfFunction(9000, 'doAnimStep Init');
				//if (isLogging){
					//isAnimating = true;
					//trace(debugName, 'isAnimating doAnimStep:','IsAnimating:',isAnimating, phiGathered, dPh)
				//}
				var mustStop:Boolean = false;
				phiGathered += dPh;
				if (phiGathered >= phiCycleLength){
					var numCyclesCompleted:int = Math.floor(phiGathered / phiCycleLength);
					phiGathered %= phiCycleLength;
					cyclesMade+= numCyclesCompleted;
					if (maxNumCycles > 0){
						if (cyclesMade >= maxNumCycles){
							mustStop = true;
						}						
					}
					hasCycleCompleted = true;
				}

				if (!mustStop){
					var lambda:Number = phiGathered / phiCycleLength;	
				}else{
					lambda = lambdaAfterAnimCompletion;//может быть, тут 1 может быть? Надо добавить настройку
					isAnimating = false;
				}
				preLastLambda = lastLambda;
				lastLambda = lambda;
				//Main.self.debugTimesController.copleteLogTimeOfFunction();
				//Main.self.debugTimesController.prepare2LogTimeOfFunction(9001, 'setDobPropertiesByLambda');
				setDobPropertiesByLambda(lambda);
				//Main.self.debugTimesController.copleteLogTimeOfFunction();
			}
		}
		
		public function setLambdaDirectly(lmb:Number):void 
		{
			setPhiGatheredDirectly(lmb * phiCycleLength);
		}
		public function interpolate2Lambda(lmb:Number, coef:Number):void 
		{
			var ph0:Number = this.phiGathered;
			var ph1:Number = lmb * this.phiCycleLength;
			this.setPhiGatheredDirectly(ph0*(1-coef)+ph1*coef);
		}		
		public function stopAfterThisRun():void{
			if (isAnimationRunning){
				maxNumCycles = cyclesMade+1;
				setLambdaDirectly(0.999);				
			}
		}
		public function setNewNumCycles(n:int):void{
			maxNumCycles = n;
		}
		
		//direct control of animation position
		public function setPhiGatheredDirectly(ph:Number):void{
			phiGathered = ph;
			if (phiGathered < 0){
				phiGathered = 0;
			}
			if (phiGathered>=phiCycleLength){
				var lambda:Number = 1;
			}else{
				lambda = phiGathered / phiCycleLength;
			}
			
			setDobPropertiesByLambda(lambda);			
		}
		
		public function doBackwardsAnimStep(dPh:Number):void 
		{
			dPh %= phiCycleLength;
			doAnimStep(phiCycleLength - dPh);//пока что некорректно будет себя вести, если циклов конечное число
		}		
		
		public function setCycle(phiGath:Number, phiNeed:Number):void 
		{
			phiGathered = phiGath;
			phiCycleLength = phiNeed;
		}
		
		private function setDobPropertiesByLambda(lmb:Number):void 
		{
			var lambda:Number = lmb
			if (lambda<0){lambda=0}
			if (timeRunFunction){
				lambda = timeRunFunction(lambda);
			}
			//if (isLogging){
				//trace(debugName, 'setDobPropertiesByLambda', lambda)
			//}
			//////Main.self.debugTimesController.prepare2LogTimeOfFunction(1001, 'viewId');
			var viewId:int = 0;
			for (var i:int = 0; i < viewsSnapshots.length - 1; i++ ){
				if ((viewsSnapshots[i].momentLambda <= lambda) && (viewsSnapshots[i + 1].momentLambda >= lambda)){
					viewId = i;
					break;
				}
			}
			//////Main.self.debugTimesController.copleteLogTimeOfFunction();
			//////Main.self.debugTimesController.prepare2LogTimeOfFunction(1002, 'interpolateDobStateBetween');
			//trace('setDobPropertiesByLambda', lambda);
			if (i != viewsSnapshots.length - 1){
				interpolateDobStateBetween(viewsSnapshots[i], viewsSnapshots[i + 1], lambda);
			}else{
				interpolateDobStateBetween(viewsSnapshots[viewsSnapshots.length - 1], viewsSnapshots[viewsSnapshots.length - 1], 0);
			}
			if (isLogging){
				trace(debugName, 'setDobPropertiesByLambda', lambda, affectedDob.rotation, affectedDob.scaleX, affectedDob.scaleY)//, affectedDob.visible, affectedDob.alpha, affectedDob.parent);
			}			
			//////Main.self.debugTimesController.copleteLogTimeOfFunction();
		}
		
		[Inline]
		private function interpolateDobStateBetween(dvs1:DobViewSnapshot, dvs2:DobViewSnapshot, lambda:Number):void 
		{
			//TODO: некоторые параметры можно не выставлять
			//if (isLogging){
			//	trace(modifiedPropsIds);
			//	trace(affectedDob.rotation);
			//}
			var calcLambda:Number = (lambda - dvs1.momentLambda) / (dvs2.momentLambda - dvs1.momentLambda);
			for (var i:int = 0; i < modifiedPropsIds.length; i++ ){
				var propId:int = modifiedPropsIds[i];
				
				if (isLogging){
					trace(i, 'propId:',propId);
				}
				
				if (!isRelative){
					if (propId==0)
					{affectedDob.x = dvs1.cx + (dvs2.cx - dvs1.cx) * calcLambda; continue; }
					if (propId==1)	
					{affectedDob.y = dvs1.cy + (dvs2.cy - dvs1.cy) * calcLambda; continue;}
					if (propId==2)
					{affectedDob.rotation = dvs1.rot + (dvs2.rot - dvs1.rot) * calcLambda; continue;}
					if (propId==3)
					{affectedDob.scaleX = dvs1.scaleX + (dvs2.scaleX - dvs1.scaleX) * calcLambda; continue;}
					if (propId==4)
					{affectedDob.scaleY = dvs1.scaleY + (dvs2.scaleY - dvs1.scaleY) * calcLambda; continue;}
					if (propId==5)
					{affectedDob.skewX = dvs1.skewX + (dvs2.skewX - dvs1.skewX) * calcLambda; continue;}
					if (propId==6)
					{affectedDob.skewY = dvs1.skewY + (dvs2.skewY - dvs1.skewY) * calcLambda; continue;}
					if (propId==7)
					{affectedDob.alpha = dvs1.alpha + (dvs2.alpha - dvs1.alpha) * calcLambda; continue;}
					if (propId==8)
					{affectedDob.visible = dvs1.visible == 1; continue; }//визибл по последнему					
				}else{
					var num:Number = 0;
					if (propId==0)
					{	num = dvs1.cx + (dvs2.cx - dvs1.cx) * calcLambda;
						affectedDob.x = affectedDob.x + num - relativeSnapshot.cx; 
						relativeSnapshot.cx = num; 
															continue; }
					if (propId==1)	
					{
						num = dvs1.cy + (dvs2.cy - dvs1.cy) * calcLambda; 
						affectedDob.y = affectedDob.y + num - relativeSnapshot.cy; 
						relativeSnapshot.cy = num; 
						continue;}
					if (propId==2)
					{
						num = dvs1.rot + (dvs2.rot - dvs1.rot) * calcLambda; 
						affectedDob.rotation =  affectedDob.rotation + num - relativeSnapshot.rot; 
						relativeSnapshot.rot = num;
						continue;}
					if (propId==3)
					{
						num = dvs1.scaleX + (dvs2.scaleX - dvs1.scaleX) * calcLambda; 
						affectedDob.scaleX = affectedDob.scaleX + num - relativeSnapshot.scaleX; 
						relativeSnapshot.scaleX = num;
						continue;}
					if (propId==4)
					{
						num = dvs1.scaleY + (dvs2.scaleY - dvs1.scaleY) * calcLambda; 
						affectedDob.scaleY = affectedDob.scaleY + num - relativeSnapshot.scaleY; 
						relativeSnapshot.scaleY = num;
						continue;}
					if (propId==5)
					{
						num = dvs1.skewX + (dvs2.skewX - dvs1.skewX) * calcLambda; 
						affectedDob.skewX = affectedDob.skewX + num - relativeSnapshot.skewX; 
						relativeSnapshot.skewX = num;
						continue;}
					if (propId==6)
					{
						num = dvs1.skewY + (dvs2.skewY - dvs1.skewY) * calcLambda; 
						affectedDob.skewY = affectedDob.skewY + num - relativeSnapshot.skewY; 
						relativeSnapshot.skewY = num;
						continue;}
					if (propId==7)
					{
						num = dvs1.alpha + (dvs2.alpha - dvs1.alpha) * calcLambda; 
						affectedDob.alpha = affectedDob.alpha + num - relativeSnapshot.alpha; 
						relativeSnapshot.alpha = num;
						continue;}
					if (propId==8)
					{affectedDob.visible = dvs1.visible == 1; continue; }//визибл по последнему						
				}
			}
			
		}
		
		public function get viewsSnapshotsLength():int 
		{
			return viewsSnapshots.length;
		}
		
		
		public function clear():void{
			viewsSnapshots.length = 0;
			for (var i:int = 0; i < 9; i++ ){
				modifiedProperties[i] = false;
			}		
			isAnimating = false;
		}
		
		public function modCycleLength(mod:Number):void 
		{
			phiCycleLength *= mod;
		}
		
		public function addRandomPush2PhiGathered():void 
		{
			var delta:Number = phiCycleLength - phiGathered;
			phiGathered += delta * Math.random();
		}
		
		public function pauseAnimation():void 
		{
			isAnimating = false;
		}		
		public function resulmeAnimation():void 
		{
			isAnimating = true;
		}
		
		public function hasJustCrossedLambda(lmb:Number):Boolean
		{
			var res:Boolean = false;
			if (preLastLambda <= lmb){
				if (lastLambda >= lmb){
					res = true;
				}else{
					if (lastLambda < preLastLambda){
						res = (lmb >= preLastLambda) || (lmb <= lastLambda);
						//res = true;
					}
				}
			}
			return res;
		}
		
		public function modNodeProperty(id:int, propName:String, val:Number):void 
		{
			var propId:int = modifiedPropsNames.indexOf(propName);
			if (propId !=-1){
				viewsSnapshots[id].setPropertyId(propId, val);
				
				modifiedProperties[propId] = true;
				if (modifiedPropsIds.indexOf(propId) ==-1){
					modifiedPropsIds.push(propId);
				}				
			}else{
				if (propName == 'lambda'){
					viewsSnapshots[id].momentLambda = val;
				}
			}
			

			
			if (isLogging){
				trace('modNodeProperty');
			}				
		}
		
		public function getGatheredPhi():Number{
			return phiGathered;
		}

		
	//	public function startAnimationTillPhase(number:Number, number1:Number):void 
	//	{
	//		
	//	}
	
		public function setTimeRunFunction(md:String):void{
			switch (md){
				case 'none':{
					timeRunFunction = null;
					break;
				}
				case 'accelerate':{
					timeRunFunction = null;
					break;
				}
				case 'deccelerate':{
					timeRunFunction = null;
					break;
				}
			}
		}
		
		public function getCycleLength():Number 
		{
			return phiCycleLength;
		}
		
		public function changeDob(dob:DisplayObject):void 
		{
			affectedDob = dob;
		}
		
		public function revert():void 
		{
			viewsSnapshots.reverse();
			for (var i:int = 0; i < viewsSnapshots.length; i++){
				viewsSnapshots[i].momentLambda = 1 - viewsSnapshots[i].momentLambda;
			}
		}
		
		private function accelFunc(x:Number):Number{
			return x * x;
		}
		private function deccelFunc(x:Number):Number{
			return 1-(1 - x) * (1 - x);
		}
		
		public function get isAnimationRunning():Boolean 
		{
			return this.isAnimating;
		}
	}
}