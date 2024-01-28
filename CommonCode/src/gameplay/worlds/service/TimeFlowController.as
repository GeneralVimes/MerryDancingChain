package gameplay.worlds.service 
{
	import com.junkbyte.console.Cc;
	import flash.utils.getTimer;
	import gameplay.worlds.World;
	import gameplay.worlds.service.SavedWorldParamsController;

	/**
	 * ...
	 * @author General
	 */
	public class TimeFlowController extends SavedWorldParamsController
	{
		public var timeSpeedMode:String = 'chase'//chase - догоняем время в игре до реального мира, other
												//immediate - сразу выставляем время мира и вычисляем бонус честно по машинам
												//other - сразу высталем время мира и мир какой-то своей ф-ей вычисляет бонус за оффлайн (как в Башне)
												//none - при перерывах просто игнорируем этот перерыв
		
		private var isSpeeding:Boolean = false;
		private var frameNum2Speed:int;
		private var frames2Speed:int;		

		private var momentOfStartInSec:Number = 0;

		private var outerWorldTime:Number;//это реальное время в мире
		private var modelledOuterWorldTime:Number; //это моделируемый момент реального времени. Он может совпадать с реальым временем, о может и отставать от него 
		//(когда междутиками прошло очень много времени и надо этот разрыв доонять постепенно для точности моделирования)
		//при timeSpeedMode = 'chase'
		//иначе - будет равен outerWorldTime
		private var correspondingIngameTime:Number;//какому игровому моменту соответвтвует текущий моделируемый момент
		//может бежать вперёд относительно времени мира, когда в игре есть бонус к ходу времени
		
		//чтобы бать бонус "прыжок врмени на час вперёд", сдвигаем назад modelledOuterWorldTime
		
		public var outerWorldDt:Number=0;//сколько времени прошло между проверками
		public var modelledOuterWorldDt:Number=0; //сколько в моделируемом мире
		public var correspondingIngameDt:Number=0;//и сколько в игре
		
		
		private var speedingTimeStart:Number = 0;
		
		//игровой момент будем отсчитывать с нуля. вводим дельту. При наличии бонуса, влияющего на ход времени, дельта будет меняться
		
		//стоит ещё сохранять время создания мира, часовой пояс с и т.п., так что добавим после в сохран
		//вот-вот, пора добавлять (31.07.2020)
		private var storyOfTimeChanges:Array = [];
		public function TimeFlowController(w:World) 
		{
			super(w);
		}
		
		public function actualizeTime():void{
			//trace('actualizeTime',isSpeeding, isSpeedingTime())
			//смотрим реальное время
			var oldOuterWorldTime:Number = outerWorldTime;
			outerWorldTime = momentOfStartInSec + getTimer() * 0.001;	
			var deltaOuterWorldTime:Number = outerWorldTime - oldOuterWorldTime; //сколько времени прошло в реальном мире между проверкам
			outerWorldDt = deltaOuterWorldTime;
			
			var deltaRealFromModelled:Number = outerWorldTime-modelledOuterWorldTime;//вот на столько реальное время опережает моделируемое
			//1. можно просто моделируемое выставить как реальное: modelledOuterWorldTime=modelledOuterWorldTime+deltaRealFromModelled
			//тогда мы будем моделировать любые скачки времени (после загрузок и пр. как есть)
			//2. можно приближвать на 1/10 интервала: modelledOuterWorldTime=modelledOuterWorldTime+deltaRealFromModelled*0.1
			//так моделируеме время будет отставать на 10 кадров, но при больших отклонениях они будут сглашиваться постепенно
			//3. самый лучший подход: вычисляем дельту, если она меньше какой-то велиины, то сразу двигаем
			//если больше, то перехом в режим isSpeeding (если ещё не там) и приближаем сильнее
			//при входе в режим isSpeeding замеряем деньги в мире, чтобы знать, с какими параметрами показывать сообщение о заработке в неактивности
			//но надо учитывать потери денег при покупках (т.е. их не учитывать)
			//возможен вариант, когда isSpeeding еобходим, а сообщение о заработках - нет (непр. при отсутствии меньше 2 минут)
			//4. и можно просто игнорировать паузы неактивности (если игра - не айдл)
			
			var oldModelledOuterWorldTime:Number = modelledOuterWorldTime;
			
			//trace(isSpeeding, frameNum2Speed, frames2Speed)
			if (isSpeeding){//сюда мы попадём только при timeSpeedMode = 'chase'
				if (frameNum2Speed < frames2Speed - 1){
					frameNum2Speed++;
					var delta2Add2ModelledTime:Number = deltaRealFromModelled / (frames2Speed-frameNum2Speed);
				}else{
					//собщение о заканчивании догоняния
					isSpeeding = false;
					//trace('isSpeeding = false')
					delta2Add2ModelledTime = deltaRealFromModelled;
					
					world.showSpeedingCompleteMessageIfNeeded(outerWorldTime-speedingTimeStart);
				}
			}else{
				if ((timeSpeedMode == 'chase')||(timeSpeedMode=='immediate')){
					if (deltaRealFromModelled < 1){//если до секунды, приводим сразу
						delta2Add2ModelledTime = deltaRealFromModelled;
					}else{
						//заметка начала догоняния
						//заисываем время
						if (timeSpeedMode == 'chase'){
							var time2Speed:Number = Math.sqrt(Math.log(deltaRealFromModelled) * Math.LOG10E); //сколько времени нужно догонять разрыв
						}else{
							time2Speed = 3 / 60; //при immediate догоняем 3 кадра
						}
						
						frames2Speed = Math.ceil(time2Speed * 60); //сколько кадров надо догонять время
						frameNum2Speed = 0;	
						isSpeeding = true;
						//trace('isSpeeding = true')
						delta2Add2ModelledTime = deltaRealFromModelled / (frames2Speed - frameNum2Speed);
						
						speedingTimeStart = getCurrentModelledWorldTime();//вот это - с какого времени мы начинаем ускоряться. И мы будем знать, сколько времени провели вне игры
						world.react2StartTimeSpeeding(speedingTimeStart);
					}					
				}else{
					if (deltaRealFromModelled < 1){
						delta2Add2ModelledTime = deltaRealFromModelled;//приводим мгновенно
					}else{//deltaRealFromModelled > 1
						if (timeSpeedMode == 'other'){
							delta2Add2ModelledTime = deltaRealFromModelled;//приводим мгновенно
							world.giveOtherOfflineReward(outerWorldTime-speedingTimeStart);
						}
						if (timeSpeedMode == "none"){//мы должны прекратить догон вообще и ничего не давать за оффлайн
							//trace("none",deltaRealFromModelled)
							delta2Add2ModelledTime = 1;
							deltaRealFromModelled = 1;
							modelledOuterWorldTime = outerWorldTime-1;
							oldModelledOuterWorldTime = modelledOuterWorldTime-1;
						}						
					}
				}
			}
			
			if (delta2Add2ModelledTime > deltaRealFromModelled){//чтобы не перегоняли
				delta2Add2ModelledTime = deltaRealFromModelled;
			}
			

			
			//применяем вариант 3
			modelledOuterWorldTime = modelledOuterWorldTime+delta2Add2ModelledTime;
			
			//
			var deltaModelledOuterWorldTime:Number = modelledOuterWorldTime-oldModelledOuterWorldTime; //сколько времени прошло в модеируемом реальном мире между проверками
			modelledOuterWorldDt = deltaModelledOuterWorldTime;
			
			var coef:Number = world.getMasterTimeCoef(deltaModelledOuterWorldTime);//да, здесь простор для читов: получить х10 к скорости времени и уйти в оффлайн
													//чтобы не было - передаётся длительность времени, на какое будет вычисляться коэф. Т.к. вдруг бонус иссякнет
			
			//1;//если время в игре будет идти в coef раз быстрее
			//здесь надо будет обратиться к бонусам и возможно иссякать их
			var oldInGameTime:Number = correspondingIngameTime;
			correspondingIngameTime += coef * deltaModelledOuterWorldTime; //и вот это идёт на выход для определения положения игровых обхектов и их заработка
			correspondingIngameDt = correspondingIngameTime-oldInGameTime;
			//trace('actualizeTime', isSpeeding, outerWorldTime, modelledOuterWorldTime, correspondingIngameTime);
		}
		
		public function getCurrentModelledWorldTime():Number{
			return modelledOuterWorldTime;
		}
		
		public function getRealWorldTime():Number{
			return outerWorldTime;
		}
		
		public function getCorrespondingIngameTime():Number{
			return correspondingIngameTime;
		}
		
	
		//при создании нового мира:
		//momentOfStartInSec берём из нового Date
		//outerWorldTime = momentOfStartInSec - моделируемое время идёт 1 в 1
		//correspondingIngameTime давайте начинать с нуля? или тоже с momentOfStartInSec?
		
		//при загрузке мира
		//momentOfStartInSec берём из нового Date - как и тот раз
		//outerWorldTime берём из сохрана
		//correspondingIngameTime тоже берём их сохрана (а можно сохранять только дельту?)
		
		public function initTime4NewWorld():void{
			var dt:Date = new Date();
			momentOfStartInSec = (dt.getTime()+dt.getTimezoneOffset()*60*1000) / 1000 - getTimer() / 1000;
			
			outerWorldTime = momentOfStartInSec + getTimer() / 1000;
			modelledOuterWorldTime = outerWorldTime;
			correspondingIngameTime = 0;
			//storyOfTimeChanges = [];//вот как раз историю перключений времени не надо сбрасывать
		}
		
		override public function save2Ar(ar:Array, nxtIndex:int):int{
			nxtIndex = super.save2Ar(ar, nxtIndex);
			ar[nxtIndex + 0] = getCurrentModelledWorldTime();
			ar[nxtIndex + 1] = getCorrespondingIngameTime();
			ar[nxtIndex + 2] = getRealWorldTime();
			ar[nxtIndex + 3] = 0;
			ar[nxtIndex + 4] = 0;
			nxtIndex = nxtIndex + 5;
			nxtIndex = Routines.saveArOfNumbers2Ar(storyOfTimeChanges, ar, nxtIndex);
			return nxtIndex;
		}
		
		//вот тут надо проверить на читы с перемоткой времени
		override public function loadFromAr(ar:Array, nxtIndex:int):int{
			//trace('load timeController', nxtIndex);
			nxtIndex = super.loadFromAr(ar, nxtIndex);
			modelledOuterWorldTime = ar[nxtIndex + 0];
			correspondingIngameTime = ar[nxtIndex + 1];
			
			var lastSavingTime:Number = ar[nxtIndex + 2];
			/*
			ar[nxtIndex + 2] 
			ar[nxtIndex + 3] 
			ar[nxtIndex + 4] 
			ar[nxtIndex + 5]
			 * */
			nxtIndex = nxtIndex + 5;
			nxtIndex = Routines.loadArOfNumbersFromAr(storyOfTimeChanges, ar, nxtIndex);			
			//а внешнее время будет новое
			var dt:Date = new Date();//dt.getTime()
			//getTimezoneOffset - Specifically, this value is the number of minutes you need to add to the computer's local time to equal UTC
			momentOfStartInSec = (dt.getTime()+dt.getTimezoneOffset()*60*1000) / 1000 - getTimer() / 1000;			
			outerWorldTime = momentOfStartInSec + getTimer() / 1000;	
			
			//ar[nxtIndex + 2] хранит, в какой момент внешнего времени игра была сохранена
			
			storyOfTimeChanges.push(outerWorldTime-lastSavingTime);
			//lastSavingTime>outerWorldTime => time travel cheat code (or simply time zones change)
			
			//trace('loadFromAr', outerWorldTime, modelledOuterWorldTime, correspondingIngameTime);
			return nxtIndex;
		}		
		
		public function cheatForwardTime(dt:Number):void 
		{
			modelledOuterWorldTime -= dt;
		}
		
		public function cancelSpeeding():void 
		{
			isSpeeding = false;
			//trace('cancelSpeeding isSpeeding = false')
		}
		
		public function isSpeedingTime():Boolean
		{
			return isSpeeding;
		}
	}
}