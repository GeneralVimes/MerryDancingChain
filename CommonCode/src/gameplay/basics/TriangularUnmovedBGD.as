package gameplay.basics 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameplay.worlds.World;
	
	/**
	 * ...
	 * @author General
	 */
	public class TriangularUnmovedBGD extends UnMovedBGD 
	{
		protected var topPoint:Point;
		protected var rightPoint:Point;
		protected var leftPoint:Point;		
		protected var topPointOnScreen:Point;
		protected var rightPointOnScreen:Point;
		protected var leftPointOnScreen:Point;
		//показываем на экране треугольник с горизонтальным, и высотой, падающей на это основание
		protected var mustShow:Boolean;
		protected var topPoint2Show:Point;
		protected var height2Show:Number = 1;
		protected var willShowRect:Boolean;
		protected var rect2Show:Rectangle;
		
		protected var mustShowRightSlope:Boolean;
		protected var mustShowLeftSlope:Boolean;
		
		public function TriangularUnmovedBGD(wrl:World, xt:Number, yt:Number, xr:Number, yr:Number, xl:Number, yl:Number) 
		{
			super(wrl);
			topPoint = new Point(xt, yt);
			rightPoint = new Point(xr, yr);
			leftPoint = new Point(xl, yl);
			topPointOnScreen = new Point(xt, yt);
			rightPointOnScreen = new Point(xr, yr);
			leftPointOnScreen = new Point(xl, yl);
			
			topPoint2Show = new Point();
			rect2Show = new Rectangle();
			
			updateMaxBoundsTriangleOnScreen();
		}
		
		private function updateMaxBoundsTriangleOnScreen():void 
		{
			topPointOnScreen.x = myWorld.visualization.wrlX2Screen(topPoint.x);
			rightPointOnScreen.x = myWorld.visualization.wrlX2Screen(rightPoint.x);
			leftPointOnScreen.x = myWorld.visualization.wrlX2Screen(leftPoint.x);
			
			topPointOnScreen.y = myWorld.visualization.wrlY2Screen(topPoint.y);
			rightPointOnScreen.y = myWorld.visualization.wrlY2Screen(rightPoint.y);
			leftPointOnScreen.y = myWorld.visualization.wrlY2Screen(leftPoint.y);
			
			var screenDims:Rectangle = myWorld.visualization.screenRectOnScreen //- это именно экран
			var topSectorId:int = Routines.findSectorIdOfPointRelated2Rect(topPointOnScreen, screenDims);
			var rightSectorId:int = Routines.findSectorIdOfPointRelated2Rect(rightPointOnScreen, screenDims);
			var leftSectorId:int = Routines.findSectorIdOfPointRelated2Rect(leftPointOnScreen, screenDims);
			
			willShowRect = false;
			//сначала - условия, когда вообще ничего не надо показывать
			if ((topPointOnScreen.y >= screenDims.bottom) || (leftPointOnScreen.y <= screenDims.top) || (leftPointOnScreen.x >= screenDims.right) || (rightPointOnScreen.x <= screenDims.left)){
				mustShow = false;
			}else{
				mustShow = true;
				
				//лежил ли вершина левее левого края экрана, правее правого или между краями?
				switch (topSectorId){
					case 7:
					case 4:	{
						mustShowRightSlope = true;
						mustShowLeftSlope = false;
						if ((rightSectorId == 5)||(rightSectorId == 6)){
							var ty1:Number = Routines.findYOfLineIntersectionWithVertical(topPointOnScreen.x, topPointOnScreen.y, rightPointOnScreen.x, rightPointOnScreen.y, screenDims.left);
							topPoint2Show.x = screenDims.left;
							topPoint2Show.y = ty1;
							height2Show = rightPointOnScreen.y - ty1;
						}
						if ((rightSectorId == 2)||(rightSectorId == 3)){
							var rx1:Number = Routines.findXOfLineIntersectionWithHorizontal(topPointOnScreen.x, topPointOnScreen.y, rightPointOnScreen.x, rightPointOnScreen.y, screenDims.bottom);
							if (rx1 < screenDims.left){
								mustShow = false;
							}else{
								ty1 = Routines.findYOfLineIntersectionWithVertical(topPointOnScreen.x, topPointOnScreen.y, rightPointOnScreen.x, rightPointOnScreen.y, screenDims.left);
								topPoint2Show.x = screenDims.left;
								topPoint2Show.y = ty1;
								height2Show = screenDims.bottom - ty1;
							}
						}
						break;
					}
					case 8://TODO:8 можно потом вынести в отдельный кейс,и доавблять рект
					case 5:{
						mustShowRightSlope = true;
						mustShowLeftSlope = true;						
						topPoint2Show.x = topPointOnScreen.x;
						topPoint2Show.y = topPointOnScreen.y;
						if ((leftSectorId == 1) || (leftSectorId == 2) || (leftSectorId == 3)){
							height2Show = screenDims.bottom - topPoint2Show.y;
						}else{
							height2Show = leftPointOnScreen.y - topPoint2Show.y;
						}
						break;
					}
					case 9:
					case 6:{
						mustShowRightSlope = false;
						mustShowLeftSlope = true;
						if ((leftSectorId == 5)||(leftSectorId == 4)){
							ty1 = Routines.findYOfLineIntersectionWithVertical(topPointOnScreen.x, topPointOnScreen.y, leftPointOnScreen.x, leftPointOnScreen.y, screenDims.right);
							topPoint2Show.x = screenDims.right;
							topPoint2Show.y = ty1;
							height2Show = leftPointOnScreen.y - ty1;
						}
						if ((leftSectorId == 2)||(leftSectorId == 1)){
							var lx1:Number = Routines.findXOfLineIntersectionWithHorizontal(topPointOnScreen.x, topPointOnScreen.y, leftPointOnScreen.x, leftPointOnScreen.y, screenDims.bottom);
							if (lx1 > screenDims.right){
								mustShow = false;
							}else{
								ty1 = Routines.findYOfLineIntersectionWithVertical(topPointOnScreen.x, topPointOnScreen.y, leftPointOnScreen.x, leftPointOnScreen.y, screenDims.right);
								topPoint2Show.x = screenDims.right;
								topPoint2Show.y = ty1;
								height2Show = screenDims.bottom - ty1;
							}
						}						
						break;
					}
				}
			}
		}
		
		override public function react2ParallaxAndScale(xFrac:Number, yFrac:Number, sFrac:Number):void 
		{
			super.react2ParallaxAndScale(xFrac, yFrac, sFrac);
			updateMaxBoundsTriangleOnScreen();
			
			showTriangleOnScreen();
		}
		override public function react2NewVisPos(vx:Number, vy:Number, vs:Number):void 
		{
			super.react2NewVisPos(vx, vy, vs);
			updateMaxBoundsTriangleOnScreen();
			
			showTriangleOnScreen();
		}
		
		protected function showTriangleOnScreen():void 
		{
			//вот тут - сам показ треугольного рисунка, центр в topPoint2Show
			//высота скейлится в height2Show
		}
	}

}