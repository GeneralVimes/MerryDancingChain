package gui 
{
	import gameplay.worlds.World;
	import service.ImageModifier;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class AutoTapMarker extends Sprite
	{
		private var myWorldX:Number;
		private var myWorldY:Number;
		private var myWorld:World;
		private var mods:Array;
		public function AutoTapMarker(wrl:World) 
		{
			myWorld = wrl;

			var botIm :Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_TRIANGLEMARKER"], this, 0, 50, "center","bottom")
			var topIm :Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_TRIANGLEMARKER"], this, 0, -50, "center","bottom")
			topIm.rotation = Math.PI;
			var rightIm :Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_TRIANGLEMARKER"], this, 50, 0, "center","bottom")
			rightIm.rotation = -Math.PI/2;
			var leftIm :Image = Routines.buildImageFromTexture(Assets.allTextures["TEX_TRIANGLEMARKER"], this, -50, 0, "center","bottom")
			leftIm.rotation = Math.PI/2;


			mods = [];

			var ima:ImageModifier = new ImageModifier()
			ima.registerDob(botIm,0.2);
			ima.addAnimNode(0.3,botIm.x, botIm.y-30, botIm.rotation);
			mods.push(ima);

			ima = new ImageModifier()
			ima.registerDob(topIm,0.2);
			ima.addAnimNode(0.3,topIm.x, topIm.y+30, topIm.rotation);
			mods.push(ima);

			ima = new ImageModifier()
			ima.registerDob(rightIm,0.2);
			ima.addAnimNode(0.3,rightIm.x-30, rightIm.y, rightIm.rotation);
			mods.push(ima);

			ima = new ImageModifier()
			ima.registerDob(leftIm,0.2);
			ima.addAnimNode(0.3,leftIm.x+30, leftIm.y, leftIm.rotation);
			mods.push(ima);
			
		}
		
		public function showTick2Center():void 
		{
			for (var i:int=0; i<this.mods.length; i++){
				this.mods[i].startAnimation(1,0);
			}
		}
		
		public function doAnimStep(dt:Number):void 
		{
			for (var i:int=0; i<this.mods.length; i++){
				this.mods[i].doAnimStep(dt);
			}			
		}
		
		public function showOverWorldPoint(wrlX:Number, wrlY:Number):void 
		{
			this.myWorldX = wrlX;
			this.myWorldY = wrlY;
			updateCoords();
		}
		public function updateCoords():void{
			this.x = this.myWorld.visualization.wrlX2Screen(this.myWorldX);
			this.y = this.myWorld.visualization.wrlY2Screen(this.myWorldY);
			
			
		}
	}

}