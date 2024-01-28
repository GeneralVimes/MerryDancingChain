package gameplay.visual 
{
	import gameplay.worlds.ChainWorld;
	import gameplay.worlds.World;
	import gui.text.ShadowedTextField;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChainHUD extends StandardHUD 
	{
		protected var informersContainer:Sprite;
		private var moneyInformer:ShadowedTextField;
		private var moneyValInformer:ShadowedTextField;
		
		private var myChainWorld:ChainWorld;
		public function ChainHUD(par:DisplayObjectContainer, wrl:World) 
		{
			super(par, wrl);
			myChainWorld=wrl as ChainWorld
		}
		
		override protected function createHudElements():void 
		{
			super.createHudElements();
			
			informersContainer = new Sprite();
			parSpr.addChild(informersContainer)
			moneyInformer = new ShadowedTextField("", -270, 0, 250, 1, 1, 0xffffff, 0x754607, "center", "scale");
			moneyValInformer = new ShadowedTextField("", moneyInformer.x, moneyInformer.y+40, 140, 1, 1, 0xffffff, 0x754607, "center", "scale");
			var im:Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_TOPINFORMERTAB"], informersContainer, 0, -35, null);
			im.color = 0xD2E015
			moneyInformer.addBGD(im);

			informersContainer.addChild(moneyInformer)
			informersContainer.addChild(moneyValInformer)
		}
		override protected function alignElements():void 
		{
			super.alignElements();
			//trace(Main.self.sizeManager.gameWidth)
			
			informersContainer.y = Main.self.sizeManager.topMenuDelta+40;
			informersContainer.x = Main.self.sizeManager.gameWidth / 2;
		}	
		override public function hideAll():void 
		{
			super.hideAll();
			informersContainer.visible = false;
		}
		override public function showAll():void 
		{
			super.showAll();
			informersContainer.visible = true;
		}	
		
		override protected function seldomUpdateInterface():void 
		{
			super.seldomUpdateInterface();
			moneyInformer.showText('Chain length:')
			moneyValInformer.showText(Routines.showNumberInAAFormat(myChainWorld.getNumPeopleInChain()))
		}		
	}

}