package service 
{
	import flash.geom.Matrix;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author ...
	 */
	public class DobViewSnapshot 
	{
		public var momentLambda:Number = 0;
		//public var mtrx:Matrix = new Matrix();
		public var cx:Number = 0;
		public var cy:Number = 0;
		public var rot:Number = 0;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var skewX:Number = 0;
		public var skewY:Number = 0;
		public var alpha:Number = 1;
		public var visible:int = 1;
		public function DobViewSnapshot() 
		{
			
		}
		
		public function getPropertyId(id:int):Number{
			switch (id){
				case 0:{
					return cx;
					break;
				}
				case 1:{
					return cy;
					break;
				}
				case 2:{
					return rot;
					break;
				}
				case 3:{
					return scaleX;
					break;
				}
				case 4:{
					return scaleY;
					break;
				}
				case 5:{
					return skewX;
					break;
				}
				case 6:{
					return skewY;
					break;
				}
				case 7:{
					return alpha;
					break;
				}
				case 8:{
					return visible;
					break;
				}
			}
			return 0;
		}
		
		public function setPropertyId(id:int, val:Number):void{
			switch (id){
				case 0:{
					cx=val;
					break;
				}
				case 1:{
					cy=val;
					break;
				}
				case 2:{
					rot=val;
					break;
				}
				case 3:{
					scaleX=val;
					break;
				}
				case 4:{
					scaleY=val;
					break;
				}
				case 5:{
					skewX=val;
					break;
				}
				case 6:{
					skewY=val;
					break;
				}
				case 7:{
					alpha=val;
					break;
				}
				case 8:{
					visible=val;
					break;
				}
			}
		}		
		public function fromDob(tm:Number, dob:DisplayObject):void 
		{
			momentLambda = tm;
			cx = dob.x;
			cy = dob.y;
			rot = dob.rotation;
			scaleX = dob.scaleX;
			scaleY = dob.scaleY;
			skewX = dob.skewX;
			skewY = dob.skewY;
			alpha = dob.alpha;
			visible = dob.visible?1:0;
		}
		
		public function fromData(tm:Number, ax:Number=0, ay:Number=0, arot:Number=0, ascaleX:Number=1, ascaleY:Number=1, askewX:Number=0, askewY:Number=0, al:Number=1, vis:int=1):void 
		{
			momentLambda = tm;
			cx = ax;
			cy = ay;
			rot = arot;
			scaleX = ascaleX;
			scaleY = ascaleY;
			skewX = askewX;
			skewY = askewY;
			alpha = al;
			visible = vis;
		}
		
	}

}