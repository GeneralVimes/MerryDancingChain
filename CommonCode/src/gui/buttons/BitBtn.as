package gui.buttons 
{
	import gui.buttons.BasicButton;
	import gui.text.ShadowedTextField;
	import service.UltimateTweener;
	import starling.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import service.ImageModifier;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.DropShadowFilter;
	/**
	 * ...
	 * @author General
	 */
	public class BitBtn extends BasicButton
	{
		private var sprTop:Sprite;
		private var bgdTop:MovieClip;
		private var bgdFront:MovieClip;
		private var icon:MovieClip;
		private var cap:ShadowedTextField;
		
		private var twn:UltimateTweener;
		
		private var sprHolderAll:Sprite;
		private var sprShaker:ImageModifier;
		private var shakeTimer:Timer;
		
		public var lastMode:String = 'none';//blocked, standard, unavailable, highlighted
		
		private var iconTextMode:String = 'icontext'//'icontext', 'icon', 'text';
		
		private var bgdRays:HighlightOfButton;
		
		private var baseW:Number;
		private var baseH:Number;
		public function BitBtn()
		{
			touchable = true;
			touchGroup = true;
			
			sprHolderAll = new Sprite();
			bgdRays = new HighlightOfButton();
			sprHolderAll.addChild(bgdRays);
			bgdRays.visible = false;
			
			addChild(sprHolderAll);
			
			sprTop = new Sprite();
		
			bgdTop = Routines.buildMCFromTextures(Assets.allTextures["TXS_BTN_TOP"], sprTop, 0, -3, "center", "center");
			
			baseW = bgdTop.width;
			baseH = bgdTop.height;
			
			bgdFront = Routines.buildMCFromTextures(Assets.allTextures["TXS_BTN_FRONT"], sprHolderAll, 0, -3 + baseH/2 +3, "center", "bottom");
			sprHolderAll.addChild(sprTop);	
			
			//bgd = Routines.buildImageFromTexture(Assets.NEW_BITBTNBASE, this, 0, 0, "left", "top");
			//bgd.readjustSize();
			icon = Routines.buildMCFromTextures(Assets.allTextures["TXS_BITBTNICONS"], sprTop);
			icon.x = -baseW/2+22
			icon.y = -3
			
			//27 - всегда, если есть icon
			cap = new ShadowedTextField('test', 27, 8, baseW - 70, 2, 1, 0xffffff,0x000000, 'center', 'scale', true, true);
			//cap.filter = new DropShadowFilter(4, 0.785, 0, 1, 1, 0.5);//new GlowFilter(0xffff00, 30, 1, 1);//// (4, 0.785, 0x005b77);
			sprTop.addChild(cap);
			
			twn = new UltimateTweener();
			
			//addEventListener(TouchEvent.TOUCH, onTouch);
			
			sprShaker = new ImageModifier();
			shakeTimer = new Timer(30, 0);
			shakeTimer.addEventListener(TimerEvent.TIMER, onShakeTimer);
			
			
		}

		public function removeCaptionsFromTranslatableList():void 
		{
			cap.getRemovedFromTranslatableList()
		}
		
		public function setIconTextMode(md:String):void{
			iconTextMode = md;
			switch (iconTextMode){
				case 'icontext':{
					icon.x = -baseW / 2 + 22;
					icon.visible = true;
					cap.x = 27;
					cap.visible = true;
					setCaptionTextWidth(baseW - 70)
					
					break;
				}
				case 'icon':{
					icon.x = 0;
					icon.visible = true;
					cap.visible = false;					
					break;
				}
				case 'text':{
					icon.visible = false;
					cap.x = 0;
					cap.visible = true;	
					setCaptionTextWidth(baseW - 20);
					break;
				}
			}
		}
		
		private function setCaptionTextWidth(aw:Number):void 
		{
			cap.setMaxTextWidth(aw);
			//и поправляем кепшен по вертикали снова
			var capH:Number = cap.getTextHeight();
			cap.y = 8 - (capH - cap.getSingleLineHeight())/2;			
		}
		
		public function setBaseHeight(h:Number):void 
		{
			bgdTop.height = h;
			baseH = bgdTop.height;
			
			bgdFront.y = -3 + baseH / 2 +3;
		}
		
		public function setBaseWidth(w:Number):void{
			//bgd.width = w;
			
			bgdTop.width = w;
			bgdFront.width = w;
			baseW = bgdTop.width;
			
			icon.x = -baseW / 2 + 22;
			
			setCaptionTextWidth(baseW - 50);
			
		}
		
		public function getBaseWidth():Number 
		{
			return baseW;
		}		

		public function setCaption(txt:String):void{
			cap.showText(txt);
			var capH:Number = cap.getTextHeight();
			cap.y = 8 - (capH - cap.getSingleLineHeight())/2;
		}
		public function setIcon(icId:int):void{
			if (icId !=-1){
				icon.currentFrame = (icId + icon.numFrames) % icon.numFrames;
			}
		}
		
		public function getCaptionText():String 
		{
			return cap.getCurrentText();
		}
		
		public function setMaxCaptionLines(n:int):void 
		{
			cap.setMaxTextLines(n);
			var capH:Number = cap.getTextHeight();
			cap.y = 8 - (capH - cap.getSingleLineHeight())/2;			
		}
		
		public function setParams(n:int, s:String):void{
			numVal = n;
			strVal = s;
		}
		
		override public function getBounds(targetSpace:DisplayObject, out:Rectangle = null):Rectangle 
		{
			return bgdTop.getBounds(targetSpace, out);
		}
		

			
		public function animTouch():void{
			twn.cancelTweening();
			if (lastMode != 'blocked'){
				if (scale != 1){
					if (scale < 1.2){
						twn.setTwnMode(UltimateTweener.MODE_SLIGHTBACK);
					}else{
						twn.setTwnMode(UltimateTweener.MODE_LINEAR);
					}
					twn.tweenItem2State(this, 10, -100000, -100000, -100000, -100000, -100000, -100000, 1);
				}else{
					twn.setTwnMode(UltimateTweener.MODE_THEREANDBACK);
					twn.tweenItem2State(this, 10, -100000, -100000, -100000, -100000, -100000, -100000, 1.1);
				}				
			}

		}
		
		public function setViewMode(md:String):void 
		{
			isEnabled = true;
			var wasModeChanged:Boolean = (md != lastMode)
			if (wasModeChanged){
				if (sprShaker.isAnimationRunning){
					
					sprShaker.setPhiGatheredDirectly(0);
					sprShaker.clear();
					shakeTimer.stop();
					
				}
				if (lastMode == 'blocked'){
					sprTop.y = 0;
				}				
			}
			
			bgdFront.visible = true;
			switch (md){
				case 'standard':{//обычная
					//trace(md);
					bgdTop.currentFrame = 0;
					bgdFront.currentFrame = 0;
					
					bgdRays.visible = false;
					break;
				}
				case 'unavailable':{//нажимается, но показывает, что за ней ничего нет
					//trace(md);
					bgdTop.currentFrame = 2;
					bgdFront.currentFrame = 2;		
					
					bgdRays.visible = false;
					break;
				}
				case 'highlighted':{//побуждает нажать
					//trace(md);
					bgdTop.currentFrame = 1;
					bgdFront.currentFrame = 1;
					if (wasModeChanged){						
						sprShaker.clear();
						sprShaker.registerDob(sprHolderAll,10+Math.random());
						sprShaker.addAnimNode(0.49, sprHolderAll.x, sprHolderAll.y, sprHolderAll.rotation);
						sprShaker.addAnimNode(0.5, sprHolderAll.x, sprHolderAll.y-10, sprHolderAll.rotation);
						sprShaker.addAnimNode(0.51, sprHolderAll.x, sprHolderAll.y, sprHolderAll.rotation);
						//sprShaker.addAnimNode(0.025, sprHolderAll.x, sprHolderAll.y-10, sprHolderAll.rotation + Math.PI / 6);
						//sprShaker.addAnimNode(0.05, sprHolderAll.x, sprHolderAll.y-10, sprHolderAll.rotation - Math.PI / 6);
						//sprShaker.addAnimNode(0.075, sprHolderAll.x, sprHolderAll.y-10, sprHolderAll.rotation + Math.PI / 6);
						//sprShaker.addAnimNode(0.01, sprHolderAll.x, sprHolderAll.y-10, sprHolderAll.rotation - Math.PI / 6);
						//sprShaker.addAnimNode(0.0125, sprHolderAll.x, sprHolderAll.y, sprHolderAll.rotation);
						//sprShaker.addAnimNode(1.0, sprHolderAll.x, sprHolderAll.y, sprHolderAll.rotation);
						
						sprShaker.startAnimation( -1, 0);
						shakeTimer.reset();
						shakeTimer.start();	
					}
					
					bgdRays.visible = true;
					break;
				}
				case 'blocked':{//даже не нажимается
					//trace(md);
					bgdTop.currentFrame = 3;
					bgdFront.currentFrame = 3;		
					bgdRays.visible = false;
					
					bgdFront.visible = false;
					isEnabled = false;
					
					sprTop.y = 7;
					break;
				}
			}
			//visible = false;
			lastMode = md;
		}

		private function onShakeTimer(e:TimerEvent):void 
		{
			sprShaker.doAnimStep(0.03);
			bgdRays.doAnimStep(0.03);
		}

				
		//public function setEnabled(b:Boolean):void{
		//	isEnabled = b;
		//	if (isEnabled){
		//		bgdFront.color = bgdTop.color /*= bgd.color*/ = 0xffffff;
		//	}else{
		//		bgdFront.color = bgdTop.color /*= bgd.color*/ = 0x888888;
		//	}
		//}
		
		public function setBgdColor(cl:uint):void{
			bgdTop.color = cl;
			bgdFront.color = cl;
		}
		
		override public function setUpSate():void 
		{
			sprTop.y = 0;
		}
		
		override public function setDownState():void 
		{
			if (lastMode != 'blocked'){
				sprTop.y = 7;
			}
			
		}



	}
}