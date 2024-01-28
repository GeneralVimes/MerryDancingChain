package 
{

	/**
	 * ...
	 * @author General
	 */
	public class MainConfig 
	{

		public var saveIntVersion:int=2;

		public var gameVersion:String = '1.0.0';
		public var saveVersion:String = '1.0.1';

		public var platform:String = 'Itch';
		public var doesGameHaveSound:Boolean = true;
		public var platformGroup:String = 'PC'//,'Mobile'// 'Web'
		public var isConsoleShowing:Boolean = /*true;//*/ false;
		
		public var gameId:int = 999999;
		
		public var GACode:String = '';//код для ПК
		public var mustClearSave:Boolean=false;
		//вообще, стоит менять при инициализации, в зависимости от платформы
		public var specificSave2Test:Array = null;
		
		public var loggingLevel:int = 2;//0 - посылать в аналитику всё, 3 - посылать только входы в игру и ошибки
		public function MainConfig() 
		{
			
		}
	}
}