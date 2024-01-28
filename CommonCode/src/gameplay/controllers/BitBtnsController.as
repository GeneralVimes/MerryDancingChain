package gameplay.controllers 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gui.buttons.BasicButton;

	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author General
	 */
	public class BitBtnsController 
	{
		private var btns:Vector.<BasicButton>;
		private var preClickedBtnId:int =-1;
		private var justUpBtnId:int =-1;
		
		private var tmpRct:Rectangle;
		private var tmpGlobPt:Point;
		private var tmpLocPt:Point;
		public function BitBtnsController() 
		{
			btns = new Vector.<BasicButton>();
			tmpRct = new Rectangle();
			tmpGlobPt = new Point();
			tmpLocPt = new Point();
		}
		
		public function registerButton(btn:BasicButton):void{
			btns.push(btn);
		}
		
		public function unRegisterButton(btn:BasicButton):void 
		{
			var id:int = btns.indexOf(btn);
			if (id !=-1){
				btns.splice(id, 1);
				if (preClickedBtnId == id){
					preClickedBtnId =-1;
				}else{
					if (preClickedBtnId > id){
						preClickedBtnId--;
					}
				}
				
				if (justUpBtnId == id){
					justUpBtnId=-1
				}else{
					if (justUpBtnId > id){
						justUpBtnId--;
					}
				}
			}
		}
				
		public function handleBitBtnTouch(tch:Touch, spr:Sprite):void 
		{
			if (btns.length == 0){
				justUpBtnId =-1;
				return; }
			if (tch){
				switch (tch.phase){
					case TouchPhase.BEGAN:{
						var bid:int = findButtonIdUnderTouch(tch, spr);
						preClickedBtnId = bid;
						setPreclickedBtn2DownState();
						justUpBtnId =-1;
						break;
					}
					case TouchPhase.ENDED:{
						setPreclickedBtn2UpState();
						if (preClickedBtnId !=-1){
							if (wasTouchedOnButtonId(tch, spr, preClickedBtnId)){
								performPreclickedButtonEffect();
							}
						}
						justUpBtnId = preClickedBtnId;
						preClickedBtnId =-1;
						break;
					}
					case TouchPhase.HOVER:{
						preClickedBtnId =-1;
						justUpBtnId =-1;
						break;
					}
					case TouchPhase.MOVED:{
						if (preClickedBtnId !=-1){
							if (!wasTouchedOnButtonId(tch, spr, preClickedBtnId)){
								setPreclickedBtn2UpState();
								preClickedBtnId =-1;
							}
						}
						justUpBtnId =-1;
						break;
					}
				}
			}else{
				preClickedBtnId =-1;
				justUpBtnId =-1;
				setPreclickedBtn2UpState();
			}
		}
		
		public function isInteractingWithButton():Boolean 
		{
			return (preClickedBtnId !=-1) || (justUpBtnId !=-1);
		}
		
		private function setPreclickedBtn2DownState():void 
		{
			if (preClickedBtnId !=-1){
				btns[preClickedBtnId].setDownState();
			}
		}
		
		private function setPreclickedBtn2UpState():void 
		{
			if (preClickedBtnId !=-1){
				btns[preClickedBtnId].setUpSate();
			}
		}
		
		//public function registerParamButtons(btns:ParamUpgradeButtons):void 
		//{
		//	registerButton(btns.getUpgradeButton());
		//	registerButton(btns.getNodeUpgradeButton());
		//}

		private function performPreclickedButtonEffect():void 
		{
			if (preClickedBtnId !=-1){
				var btn:BasicButton = btns[preClickedBtnId];
				if (btn.visible){
					if (btn.isEnabled){
						btn.performOnUpFunction();
					}
				}
				
			}
		}
		
		private function wasTouchedOnButtonId(tch:Touch, spr:Sprite, bid:int):Boolean
		{
			var res:Boolean = false;
			if (bid !=-1){
				var btn:BasicButton = btns[bid];
				if (btn.visible){
					if (btn.isEnabled){
						btn.getExtendedBounds(spr, tmpRct);
						
						tmpGlobPt.setTo(tch.globalX, tch.globalY);
						spr.globalToLocal(tmpGlobPt, tmpLocPt);
						res = tmpRct.containsPoint(tmpLocPt);						
					}
				}
			}
			return res;
		}
		
		private function findButtonIdUnderTouch(tch:Touch, spr:Sprite):int 
		{
			var res:int =-1;
			tmpGlobPt.setTo(tch.globalX, tch.globalY);
			spr.globalToLocal(tmpGlobPt, tmpLocPt);
			for (var i:int = 0; i < btns.length; i++ ){
				if (btns[i].visible){
					if (btns[i].isEnabled){
						btns[i].getBounds(spr, tmpRct);
						if (tmpRct.containsPoint(tmpLocPt)){
							res = i;
							break;
						}						
					}
				}

			}
			return res;
		}
	}

}