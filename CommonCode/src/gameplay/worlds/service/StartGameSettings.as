package gameplay.worlds.service 
{
	/**
	 * ...
	 * @author ...
	 */
	public class StartGameSettings 
	{		
		public var mapWidth:StartGameSettingsProperty;
		public var wrapMode:StartGameSettingsProperty;
		public var numPlayers:StartGameSettingsProperty;
		
		public var props:Vector.<StartGameSettingsProperty>
		public function StartGameSettings() 
		{
			props = new Vector.<gameplay.worlds.service.StartGameSettingsProperty>();
			
			mapWidth = new StartGameSettingsProperty("TXID_PROP_MAPSIZE", 30, 10, 50);
			
			wrapMode = new StartGameSettingsProperty("TXID_PROP_MAPWRAPMODE", 0, 0, 2);
			wrapMode.correspondingTextVals = ['TXID_PROPNAME_RECT', 'TXID_PROPNAME_CYLINDER', 'TXID_PROPNAME_THORUS']
			wrapMode.willWrapViaMinMax = true;
			numPlayers = new StartGameSettingsProperty("TXID_PROP_NUMPLAYERS", 5, 2, 20);
			
			props.push(mapWidth, wrapMode, numPlayers);
		}
		
		//public function get wrapMode():String 
		//{
		//	return wrapModes[wrapModeId];
		//}
		
		
	}

}