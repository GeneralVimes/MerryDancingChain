package gameplay.basics 
{
	import flash.geom.Rectangle;
	import gameplay.basics.service.MouseController;
	import gameplay.visual.PooledObject;

	import gameplay.worlds.World;
	import service.TouchInfo;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	/**
	 * ...
	 * @author ...
	 */
	public class BasicGameObject extends Sprite
	{
		protected var nameStr:String;
		protected var descStr:String;
		
		public var myClass:Class;
		public var myWorld:World;
		public var arId:int;//номер этого объекта в векторе
		public var vecId:int;//в каком из векторов главного мира хранится объект

		public var timeOfCreation:Number = 0;
		public var totalLifeTime:Number = 0;
		public var lastCalculatedMomentInSeconds:Number = 0;//
		public var timePassedSinceLastCheck:Number = 0;//
		
		//это для перформанса и анимаций
		public var timeofCreationInRealTime:Number = 0;
		public var lastCalculatedRealTimeMoment:Number = 0;
		public var realTimePassedSinceLastCheck:Number = 0;
		
		//для обновления параметров, требующих нечастого обновления
		protected var lastParamsActualizationMoment:Number = 0;
		protected var lastInterfaceActualizationMoment:Number = 0;
		protected var delayBetweenParamsActualizations:Number = 0.5+0.1*Math.random();
		protected var delayBetweenInterfaceActualizations:Number = 0.5+0.1*Math.random();

		public var isQueued4Removeal:Boolean = false;
		public var canBRolledBack:Boolean = false;//чтоы быстро откатить непринятую покупку
		
		protected var mouseController:MouseController;
		
		protected var cachedRect:Rectangle = null;
		public var distributedSprites:Array = [];
		public var layersIds:Array = [0];//будут назначаться миром при создании
		public var skipsVisualization:Boolean = false;
		
		public var purchaseId:int=-1
		public var purchasedOrder:int = -1;//в каком порядке объекты появлялись на экране среди др. объектов этого типа -> от этого будет зависеть цена апгрейда
		
		
		public function BasicGameObject() 
		{
			//var img:Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_TMP_WHITESQUARE"], this, 0, 0);
			//img.color = 0xff0000;

		}
		
		public function functionFromConstructor():void 
		{
			touchable = false;
			touchGroup = true;			
		}
		
		public function initProperties(ar:Array):int{
			x = ar[0];
			y = ar[1];
			return 2; //следующий индекс для вычитки
		}
		//вызыается сразу, как пройдёт initProperties по классу и потомкам.Все данные на момент её вызова, инициализированны
		public function afterInitProcessing():void 
		{
			
		}
		
		public function initVisuals():void{
			//тут создаём графику, идущую в главный объект, а аткже доп.объекты, которые распределяются по слоям 
		}
		
		//если вдруг графика зависит от связей с другими обхектами (которые определяются после secondAfterLoadFunction
		public function changeGraphicsFromAfterLoadParams():void 
		{
			
		}		
		protected function initBorderRect():void{
			cachedRect = getBounds(this);
		}
		
		public function getBoundsOfBiggestPart(rct:Rectangle):void{
			if (!cachedRect){
				initBorderRect();
			}
			if (cachedRect){
				rct.copyFrom(cachedRect);
				
				if (scaleX ==-1){
					Routines.scaleRect(rct, scaleX, scaleY);
				}
				
				if (rotation != 0){
					Routines.rotateRect(rct, rotation);
				}
				
				rct.x += this.x;
				rct.y += this.y;				
			}
		}
		
		protected function initMouseController():void{
			if (!mouseController){
				mouseController = new MouseController(0);
				mouseController.registerMouseHandlers(reaction2MouseDown, reaction2MouseUp, reaction2MouseEnter, reaction2MouseExit, reaction2MouseMoveTouched, reaction2MouseMoveUntouched);
				touchable = true;
				touchGroup = true;				
			}
		}
		
		public function distribute2Layers(lyrsAr:Array):void{
			//trace('distribute2Layers called',this);
			//trace(lyrsAr);
			lyrsAr[0].addChild(this);
			var len:int = lyrsAr.length;
			var mx:int = distributedSprites.length-1
			for (var i:int = 0; i <= mx; i++ ){
				lyrsAr[(i + 1)%len].addChild(distributedSprites[i]);
				distributedSprites[i].touchable = false;
				if (distributedSprites[i] is starling.display.DisplayObjectContainer){
					distributedSprites[i][i].touchGroup = false;
				}
				
			}
		}
		
		public function changePos(newX:Number, newY:Number):void{
			var dx:Number = newX - this.x;
			var dy:Number = newY - this.y;
			for (var i:int = 0; i < distributedSprites.length; i++ ){
				var dob:DisplayObject = distributedSprites[i] as DisplayObject;
				dob.x += dx;
				dob.y += dy;
			}
			
			x = newX;
			y = newY;
			//TODO: тут можно расширить, если этот объект - контейнер для других объектов
		}
		
		protected function reflectVertically():void 
		{
			
		}
		
		public function setCreatedAndCurrentRealTimeMoment(realTime:Number):void 
		{
			lastCalculatedRealTimeMoment = timeofCreationInRealTime = realTime;
		}
		
		public function setCreatedAndCurrentMoment(tm:Number):void 
		{
			timeOfCreation = lastCalculatedMomentInSeconds = tm;
		}
		
		public function calcStateInMoment(mt:Number):void{
			timePassedSinceLastCheck = mt - lastCalculatedMomentInSeconds;
			if (timePassedSinceLastCheck < 0){timePassedSinceLastCheck = 0}//на всякий случай: часовые пояса там и т.п.
			totalLifeTime = mt - timeOfCreation;
			lastCalculatedMomentInSeconds = mt;
			
			//централизованно выносим обновление параметров с задержкой
			if (lastParamsActualizationMoment > lastCalculatedRealTimeMoment){//исправляем глюк с заходом в будущее
				lastParamsActualizationMoment = lastCalculatedRealTimeMoment;
			}
			if (lastCalculatedRealTimeMoment >= lastParamsActualizationMoment + delayBetweenParamsActualizations){
				seldomActualizeParams();
				lastParamsActualizationMoment = lastCalculatedRealTimeMoment;
			}			
		}		
		
		public function react2NewRealTime(rt:Number):void{
			realTimePassedSinceLastCheck = rt - lastCalculatedRealTimeMoment;
			if (realTimePassedSinceLastCheck < 0){timePassedSinceLastCheck = 0}//на всякий случай: часовые пояса там и т.п.
			lastCalculatedRealTimeMoment = rt;
		}
		
		protected function seldomActualizeInterface():void 
		{
			
		}
		
		protected function seldomActualizeParams():void 
		{
			
		}
		
		//меняется визуализация в зависимости от текущего состояния объекта
		public function actualizeVisuals():void 
		{
			if (lastInterfaceActualizationMoment > lastCalculatedRealTimeMoment){//исправляем глюк с заходом в будущее
				lastInterfaceActualizationMoment = lastCalculatedRealTimeMoment;
			}
			if (lastCalculatedRealTimeMoment >= lastInterfaceActualizationMoment + delayBetweenParamsActualizations){
				seldomActualizeInterface();
				lastInterfaceActualizationMoment = lastCalculatedRealTimeMoment;
			}
		}
		
		public function toString():String{
			return 'BasiGameObject ' + myClass.toString() + ' ID: ' + arId.toString();
		}	
		
		public function prepare4Removal():void{
			isQueued4Removeal = true;
		}
		
		public function getRemovedFromScreenCompletely():void 
		{
			mouseController = null;
			for (var i:int = 0; i < distributedSprites.length; i++ ){
				(distributedSprites[i] as DisplayObject).removeFromParent(true);
			}
			
			////чайльдами могут быть пины-визуализации, из диспозить не надо
			for (i = this.numChildren - 1; i >= 0; i--){
				var ch:DisplayObject = this.getChildAt(i);
				if (ch is PooledObject){
					removeChild(ch, false);
					(ch as PooledObject).back2Pool();
				}
			}
			
			removeFromParent(true);
		}

		public function modObjScalesBy(coefX:Number, coefY:Number):void 
		{
			
		}
		
		public function reflectInsideRect(rct:Rectangle):void 
		{
			//trace('reflectInsideRect:')
			//trace('was:', this, this.x);
			if (rct){
				var dx:Number = this.x - rct.left;
				this.changePos(rct.right - dx, this.y);
			}
			this.reflectVertically();
			//trace('now', this.x);
		}
		
		public function getRotatedBy(phi:Number):void 
		{
			//trace('hello');
		}		
		
		public function getRotatedRelativelyByAngle(dphi:Number):void 
		{
			
		}
		
		public function setAllVisible(b:Boolean):void 
		{
			for (var i:int = 0; i < distributedSprites.length; i++ ){
				var dob:DisplayObject = distributedSprites[i] as DisplayObject;
				dob.visible = b;
			}			
			visible = b;
		}

		public function setAllAlpha(val:Number):void 
		{
			for (var i:int = 0; i < distributedSprites.length; i++ ){
				var dob:DisplayObject = distributedSprites[i] as DisplayObject;
				dob.alpha = val;
			}			
			alpha = val;			
		}
		
		public function moveAll2Layer(lyr:DisplayObjectContainer):void 
		{
			lyr.addChild(this);
			for (var i:int = 0; i < distributedSprites.length; i++ ){
				lyr.addChild(distributedSprites[i]);
			}
		}
		
		//это заготовки для раскрытия в монетках или чём ещё - реакция на взаимодействие с мышью
		protected function reaction2MouseDown():Boolean{
			return false;
		}
		
		protected function reaction2MouseUp():Boolean{
			return false;
		}
		
		protected function reaction2MouseEnter():Boolean{
			return false;
		}
		
		protected function reaction2MouseExit():Boolean{
			return false;
		}
		
		protected function reaction2MouseMoveTouched():Boolean{
			return false;
		}	
		
		protected function reaction2MouseMoveUntouched():Boolean{
			return false;
		}
		
		public function react2TouchLeave(tch:Touch, tinf:TouchInfo):void{
			if (mouseController){
				mouseController.react2Touch(tinf.arId,null,this,this.lastCalculatedMomentInSeconds);
			}
		}
		
		public function react2Touch(tch:Touch, tinf:TouchInfo):Boolean 
		{
			if (mouseController){
				return mouseController.react2Touch(tinf.arId,tch,this, tch.timestamp);
			}else{
				return false;
			}
		}	
		

		
		public function onCreated():void 
		{
			
		}
		
		public function initSpecialCallBacksFromWorld():void 
		{
			
		}
		
		public function save2Ar(ar:Array, nxtId:int):int 
		{
			ar[nxtId + 0] = myWorld.getIndexOfClass(myClass);
			ar[nxtId + 1] = this.arId;
			ar[nxtId + 2] = this.vecId;
			ar[nxtId + 3] = this.x;
			ar[nxtId + 4] = this.y;
			ar[nxtId + 5] = this.timeOfCreation;
			ar[nxtId + 6] = this.lastCalculatedMomentInSeconds;
			ar[nxtId + 7] = this.totalLifeTime;
			ar[nxtId + 8] = this.timeofCreationInRealTime;
			ar[nxtId + 9] = this.lastCalculatedRealTimeMoment;
			ar[nxtId + 10] = this.purchaseId;
			ar[nxtId + 11] = this.purchasedOrder;
			ar[nxtId + 12] = 0;
			ar[nxtId + 13] = 0;
			ar[nxtId + 14] = 0;
			return nxtId + 15;
		}
				
		public function loadPropertiesFromAr(ar:Array, nxtId:int):int{
			//ar[nxtId + 0] = myWorld.getIndexOfClass(myClass); //-это пропускаем
			this.arId = ar[nxtId + 1];
			this.vecId = ar[nxtId + 2];
			this.x = ar[nxtId + 3];
			this.y = ar[nxtId + 4];
			
			this.timeOfCreation					 = ar[nxtId + 5]
			this.lastCalculatedMomentInSeconds   = ar[nxtId + 6]
			this.totalLifeTime                   = ar[nxtId + 7]
			this.timeofCreationInRealTime        = ar[nxtId + 8]
			this.lastCalculatedRealTimeMoment	 = ar[nxtId + 9]
			this.purchaseId	 = ar[nxtId + 10]
			this.purchasedOrder	 = ar[nxtId + 11]
			
			
			return nxtId + 15;			
		}		
		
		//что-то может быть понадобится сделать после загрузки всех объектов
		public function afterLoadProcessing():void{
			
		}
		//а это - когда загрузятся все объекты и прогонят свой afterLoadProcessing (пример: объекты, потом коннекшены (регистрируясь на объектах), а потом надо снова обекты пройти
		public function secondAfterLoadProcessing():void 
		{
			
		}
		
		public function registerMyWorld(world:gameplay.worlds.World):void 
		{
			this.myWorld = world;
		}
		
		public function copyWorldPropertiesFromRecord(objRecord:Object):void 
		{
			//{	cls:Forest,	name:"TXID_NAME_FOREST", desc:"TXID_DESC_FOREST",	layers:[0]	
			if (objRecord.hasOwnProperty("layers")){
				this.layersIds = objRecord.layers.slice();
			}
			if (objRecord.hasOwnProperty("name")){
				this.nameStr = objRecord.name;
			}
			if (objRecord.hasOwnProperty("desc")){
				this.descStr = objRecord.desc;
			}
		}
		
		public function getNameStr():String{
			if (this.purchaseId!=-1){
				return myWorld.purchaser.getNameOfPurchaseId(this.purchaseId)
			}
			return nameStr;
		}
		public function getDescStr():String{
			if (this.purchaseId!=-1){
				return myWorld.purchaser.getDescOfPurchaseId(this.purchaseId)
			}			
			return descStr;
		}
		
		public function hasSpecificProperties(props:Object):Boolean 
		{
			return false;
		}
		
		public function getX():Number{return this.x}
		public function getY():Number{return this.y}
		public function getArId():int{return this.arId}
		public function getVecId():int{return this.vecId}
		
	}

}