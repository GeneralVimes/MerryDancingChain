package service 
{
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author ...
	 */
	public class WaveMover 
	{
		private var imgs:Vector.<DisplayObject>;
		private var currentImageId:Number;
		private var totalPhi:Number;
		public var animationSpeedCoef:Number;
		public var sectionSizeAddCoef:Number;
		public var isAnimationRunning:Boolean;
		
		public function WaveMover(imgsAr:Vector.<DisplayObject>) 
		{
			this.imgs=imgsAr;
			this.currentImageId = -1;
			this.totalPhi = 0;
			this.animationSpeedCoef = 20;
			this.sectionSizeAddCoef = 0.1;
			this.isAnimationRunning = true;			
		}
		
		//старт с меньшего -1 позволитзадержать анимацию
		public function startAnimation(imId:int=-1):void{
			this.currentImageId = imId;
			this.totalPhi = (imId+1) / animationSpeedCoef;
			this.isAnimationRunning = true;
		}

		public function doStep(dt):void{
			if (!this.isAnimationRunning){
				return;
			}

			var oldPhi:Number = this.totalPhi;
			this.totalPhi+=dt*this.animationSpeedCoef;

			var imId:int = Math.floor(this.totalPhi);
			var lambda2Next:Number = this.totalPhi-imId;

			//текущий сегмент уменьшается 
			//следующий сегмент увеличивается

			var s0:Number = 1-lambda2Next;
			var s1:Number = lambda2Next;

			if ((imId >= 0) && (imId < this.imgs.length)){
				if (imId >= 0){//чтобы начальный сегмент расширялся плавно, а не резко
					var sclSgn:int = this.imgs[imId].scale<0?-1:1;
					this.imgs[imId].scale = sclSgn*(1+this.sectionSizeAddCoef*s0);					
				}

				if (imId < this.imgs.length - 1){
					sclSgn = this.imgs[imId+1].scale<0?-1:1;					
					this.imgs[imId+1].scale = sclSgn*(1+this.sectionSizeAddCoef*s1);
				}
			}

			if (this.currentImageId!=imId){
				//устанавливаем в 1
				if ((this.currentImageId >= 0) && (this.currentImageId < this.imgs.length)){
					sclSgn = this.imgs[this.currentImageId].scale<0?-1:1;
					this.imgs[this.currentImageId].scale = sclSgn*(1);
				}

				this.currentImageId=imId;

				if (this.currentImageId>=this.imgs.length){
					this.isAnimationRunning=false;
				}
			}
		}
		
		
	}

}