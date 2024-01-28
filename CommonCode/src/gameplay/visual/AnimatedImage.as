package gameplay.visual 
{
	import service.ImageModifier;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class AnimatedImage extends BasicMachineVisual 
	{
		private var im:Image;
		private var ima:ImageModifier;
		private var mode:String;
		
		public function AnimatedImage(par:DisplayObjectContainer, tx:Texture, propsOb:Object=null) 
		{
			super(0, 0, par);
			
			touchGroup = true;
			
			var myTex:Texture = tx;
			mode = 'linear'
			if (propsOb){
				if (propsOb.hasOwnProperty("mode")){
					mode = propsOb.mode;
				}
			}

			im = Routines.buildImageFromTexture(myTex, this, 0,  0, null);
			im.visible = false;
			ima = new ImageModifier();
			ima.registerDob(im, 0.4);
			ima.addAnimNode(0.0, -1, -1, 0,1,1,0,0,1);
			if (mode=='withRotation'){
				ima.addAnimNode(0.1, -1, -1, -Math.PI,1,1,0,0,1);
			}
			ima.addAnimNode(0.9, 0,   0, 0,1,1,0,0,1);
			ima.addAnimNode(1.0, 0,   0, 0,1,1,0,0,0);
		}
		override public function doAnimStep(dt):void 
		{
			super.doAnimStep(dt);
			ima.doAnimStep(dt);
		}
		
		public function placeInCoords(cx:Number, cy:Number):void 
		{
			im.x = cx;
			im.y = cy;
			ima.modNodeProperty(ima.viewsSnapshotsLength-2, 'x', cx);
			ima.modNodeProperty(ima.viewsSnapshotsLength-2, 'y', cy);
			ima.modNodeProperty(ima.viewsSnapshotsLength-1, 'x', cx);
			ima.modNodeProperty(ima.viewsSnapshotsLength-1, 'y', cy);			
		}
		
		public function startFromPoint(cx:Number, cy:Number):void{
			im.x = cx;
			im.y = cy;
			im.visible=true;
			this.ima.modNodeProperty(0, 'x', cx);
			this.ima.modNodeProperty(0, 'y', cy);
			if (this.mode=='withRotation'){
				this.ima.modNodeProperty(1, 'x', cx);
				this.ima.modNodeProperty(1, 'y', cy);
			}		
			this.ima.startAnimation(1,0);			
		}
	}

}

