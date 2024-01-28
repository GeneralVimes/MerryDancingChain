package gui.pages 
{
	import com.junkbyte.console.Cc;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import gameplay.worlds.World;
	import gameplay.worlds.service.ArtifactObject;
	import gui.buttons.BasicButton;
	import gui.buttons.BitBtn;
	import gui.buttons.SmallButton;
	import gui.elements.NinePartsBgd;
	import gui.pages.InterfacePage;
	import gui.pages.UpdatedInterfacePage;
	import gui.text.MultilangTextField;
	/**
	 * ...
	 * @author ...
	 */
	public class BabelArtifactsPanel extends UpdatedInterfacePage
	{
		private var bgd:NinePartsBgd;
		private var closeBtn:SmallButton;
		public var myWorld:World
		private var cap:MultilangTextField;
		private var infsPool:Vector.<gui.pages.ArtifactInformer>;
		private var btnInfoSize:int = 410;
		private var btnHeightSize:int=280;
		private var restoreBtn:gui.buttons.BitBtn;
		
		private var pageId:int = 0;
		private var nxtBtn:BitBtn;
		private var prevBtn:BitBtn;
		
		public function BabelArtifactsPanel() 
		{
			super();
			
			bgd = new NinePartsBgd();
			addChild(bgd);
			bgd.alpha = 0.8;

			closeBtn = new SmallButton(0);
			closeBtn.setIconByCode("close")
			closeBtn.registerOnUpFunction(this.closeBtnHandler);
			addChild(closeBtn);
			closeBtn.x = Main.self.sizeManager.fitterWidth*0.5-70
			closeBtn.y = 0
			
			this.cap = new MultilangTextField("TXID_CAP_ARTIFACTS", 0, 40, sizeWidth-20, 1, 1, 0xffffff, "center", "scale", true, true);
			addChild(cap);
			this.infsPool = new Vector.<ArtifactInformer>()
			
			this.nxtBtn = Routines.buildBitBtn('', 9, this, onNextClick, 200, 10);
			this.prevBtn = Routines.buildBitBtn('', 10, this, onPrevClick, -200, 10);
			nxtBtn.setIconTextMode("icon");
			nxtBtn.setBaseWidth(60);
			prevBtn.setIconTextMode("icon");
			prevBtn.setBaseWidth(60);
			
			this.restoreBtn = new BitBtn();
			restoreBtn.registerOnUpFunction(onRestorePurchClick);
			restoreBtn.setIconTextMode("text");
			restoreBtn.setCaption("TXID_RESTOREPURCHASES");
			addChild(restoreBtn);
		}
		
		private function onNextClick(b:BasicButton):void 
		{
			pageId++;
			updateView();
		}
		
		private function onPrevClick(b:BasicButton):void 
		{
			pageId--;
			updateView();
		}
		
		private function onRestorePurchClick(b:BasicButton):void 
		{
			Cc.log('calling Restore Purchases');
			EnhanceWrapper.manuallyRestorePurchases(onRestoreSuccess, onRestoreFail);
		}
		
		private function onRestoreSuccess():void 
		{
			myWorld.showMessage("TXID_SUCCESS", "TXID_PURCHASESRESTORED", ["TXID_MSGANS_OK"]);
			Cc.log('success!');
			Cc.log('trying to actualize purchases from Purchases controller');
			this.myWorld.artifactsController.actualizeArtifactsFromPurchaser();
			updateView();
		}
		
		private function onRestoreFail():void 
		{
			myWorld.showMessage("TXID_RESTOREFAILED", "TXID_TRYAGAIN", ["TXID_MSGANS_OK"]);
			Cc.log('Fail...');
			Cc.log('still, trying to actualize purchases from Purchases controller');
			
			this.myWorld.artifactsController.actualizeArtifactsFromPurchaser();
			updateView();
		}
		
		private function closeBtnHandler(b:BasicButton):void 
		{
			this.hide();
		}
		
		override public function updateView():void 
		{
			super.updateView();
			closeBtn.x = sizeWidth / 2 - 30;
			
			var numInLine:int = (sizeWidth - 10) / btnInfoSize;
			var numInVertLine:int = Math.round((Main.self.sizeManager.gameHeight - 370)/btnHeightSize);
			
			var numOnScreen:int = numInLine * numInVertLine;
			
			var i0:int = pageId * numOnScreen;
			var i1:int = Math.min((pageId + 1) * numOnScreen, this.myWorld.artifactsController.artifacts.length);
			
			var cy:int = 100;
			for (var i:int = 0; i < i1-i0; i++ ){
				var aft:ArtifactObject = this.myWorld.artifactsController.artifacts[i+i0];
				var inf:ArtifactInformer = this.createOfFindInformer4Artifact(i, aft);
				
				var idX:int = i % numInLine;
				var idY:int = Math.floor(i / numInLine);
				
				var cx:int = (idX - (numInLine-1) / 2) * btnInfoSize;
				cy = 100 + idY * btnHeightSize;
				inf.x = cx;
				inf.y = cy;
			}
			while (i < infsPool.length){
				infsPool[i].visible = false;
				i++;
			}
			restoreBtn.y = cy + 270;
			
			if (this.myWorld.artifactsController.artifacts.length <= i1){
				nxtBtn.visible = false;
			}else{
				nxtBtn.visible = true;
			}
			
			if (i0 <= 0){
				prevBtn.visible = false;
			}else{
				prevBtn.visible = true;
			}
			
			bgd.setDims(this.sizeWidth, cy + 330);			
		}

		
		private function createOfFindInformer4Artifact(id:int, aft:gameplay.worlds.service.ArtifactObject):ArtifactInformer 
		{
			var res:ArtifactInformer = null;
			if (id < infsPool.length){
				res = infsPool[id];
			}else{
				res = new ArtifactInformer(this);
				addChild(res);
				infsPool.push(res);
			}
			res.showForArtifact(aft);
			return res;			
		}
		
		override public function alignOnScreen():void 
		{
			super.alignOnScreen();
			sizeWidth = Main.self.sizeManager.gameWidth - 40;
			this.x = Main.self.sizeManager.gameWidth / 2;
			this.y = 70+Main.self.sizeManager.topMenuDelta;
			
			bgd.setDims(sizeWidth, Main.self.sizeManager.gameHeight - 50);
		}
		
		override protected function initParamsFromObject(paramsOb:Object):void 
		{
			super.initParamsFromObject(paramsOb);
			myWorld = paramsOb.world;
			if (paramsOb.hasOwnProperty("specificCurrency")){
				var currCode:String = paramsOb["specificCurrency"];
				var aftId:int = this.myWorld.artifactsController.findIdOfArtifactWhichGivesCurrency(currCode);
				pageId = findPageIdWhichContainsArtifactId(aftId);		
			}
			this.myWorld.artifactsController.actualizeArtifactsFromPurchaser();
		}		
		
		private function findPageIdWhichContainsArtifactId(aftId:int):int 
		{
			if (aftId !=-1){
				var sw:Number = Main.self.sizeManager.gameWidth - 40;
				var numInLine:int = (sw - 10) / btnInfoSize;
				var numInVertLine:int = Math.round((Main.self.sizeManager.gameHeight - 370)/btnHeightSize);
				var numOnScreen:int = numInLine * numInVertLine;
				
				//нм надо установить pageId такой, чтобы на экране показался нужный нам артефакт
				return Math.floor(aftId / numOnScreen);					
			}else{
				return 0;
			}
			
		}
		
		override public function handleKeyboardEvent(e:KeyboardEvent):Boolean 
		{
			if (!this.visible){return false}
			var b:Boolean = super.handleKeyboardEvent(e);
			if (!b){
				if (e.keyCode==Keyboard.BACK){
					if (closeBtn.visible){
						this.hide(true);
						b = true;
					}
				}
				if (e.keyCode==Keyboard.ESCAPE){
					if (closeBtn.visible){
						this.hide(true);
						b = true;
					}
				}				
			}
			return b;			
		}
	}

}