package  globals
{
	import flash.utils.Dictionary;
	import gameplay.visual.PooledObject;
	import starling.display.DisplayObjectContainer;

	//import flash.geom.Point;
	//import ingame.newcore.visuals.InstantTimesMarker;
    //
	//import ingame.newcore.basics.Machine;
	//import ingame.newcore.gui.PinVisualization;
	////import ingame.newcore.gui.PossiblePositionVisualization;
	//import ingame.newcore.gui.RpmInformer;
	//import ingame.newcore.gui.SomethingNewInformer;
	//import ingame.newcore.service.ConnectorPin;
	//import ingame.newcore.service.PossiblePosition;
	//import ingame.newcore.visuals.EnergeticTouchVisual;
	//import ingame.newcore.visuals.MachineHintMessage;
	//import ingame.newcore.visuals.PuffEffect;
	//import ingame.newcore.visuals.SteamPuffEffect;
	//import ingame.newcore.visuals.SmokeParticle;
	//
	//import starling.display.DisplayObjectContainer;
	//import starling.display.Sprite;


	/**
	 * ...
	 * @author General
	 */
	public class MyPool 
	{
		static public var pool:MyPool;
		

		private var vecsByClasses:Dictionary;

		public function MyPool() 
		{
			pool = this;
			vecsByClasses = new Dictionary();
			
		}
		
		public function getAPooledObject(cls:Class, ax:Number, ay:Number, par:DisplayObjectContainer = null, props:Object = null):PooledObject{
			var vec:Vector.<PooledObject> = vecsByClasses[cls];
			if (!vec){
				vec = new Vector.<PooledObject>;
				vecsByClasses[cls] = vec;
			}
			var res:PooledObject = null;
			var dot:PooledObject;
			for each (dot in vec) {
				if (dot.isInPool) {
					res = dot;
					break;
				}
			}
			if (!res){
				res = new cls();
				vec.push(res);
			}
			
			res.setProperties(ax, ay, par, props);
			
			return res;
		}
		
		
	}
}