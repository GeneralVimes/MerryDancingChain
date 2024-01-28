package  globals
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author General
	 */
	public class SoundPlayer 
	{
		
		private var soundsList:Array=[
			{code:"music", num:1, config:{volume:1	}},
			{code:"buttonDown", num:2, config:{volume:1	}},
			{code:"idea", num:7, config:{volume:1	}},
			{code:"buttonUp", num:2  , config:{volume:1	}}

		]
		private var soundCodes:Array = [];
		
		public static var player:SoundPlayer;
		private var soundFiles:Array;
		
		private var musics:Array;
		private var steampunkMusics:Vector.<Sound>;
		private var steampunkAfterDelays:Vector.<int>;
		private var steampunkSamplesWeights:Array;
		private var screenMusicId:int =-1;
		private var musicLoopTimer:Timer;
		
		private var musChannel:SoundChannel;
		private var musTransform:SoundTransform;
		public var isSound:Boolean;
		public var isMusic:Boolean;
		
		public function SoundPlayer() 
		{
			player = this;
			
			//for (var i:int = 0; i < delayPoolSize; i++) {
			//	var tm:Timer = new Timer(100, 1);
			//	delayTimers.push(tm);
			//	tm.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer0Complete);
			//	delaySounds.push(0)
			//	delayParams.push(0)
			//}
			//delayTimerIndex = 0;
			soundFiles = [];
			
			if (Main.self.config.doesGameHaveSound){
				for (var i:int = 0; i < soundsList.length; i++ ){
					soundFiles.push([]);
					var numVars:int = soundsList[i].num;
					for (var j:int = 0; j < numVars; j++ ){
						var snd:Sound = Assets.manager.getSound('snd_' + soundsList[i].code + '_' + (j).toString());
						if (snd){
							soundFiles[i].push(snd);
						}
						
					}
					soundCodes.push(soundsList[i].code)
				}				
			}

	
			//music = Assets.manager.getSound('bumblebee_looped');
			//mainMenuMusic = Assets.manager.getSound('menu_looped');
			
			//musics = [music, mainMenuMusic];
			
			steampunkMusics = new Vector.<Sound>();
			steampunkMusics.push(
				Assets.manager.getSound('music_0'),
				Assets.manager.getSound('music_1'),
				Assets.manager.getSound('music_2'), 
				Assets.manager.getSound('music_3'),
				Assets.manager.getSound('music_4')
			)
			
			steampunkAfterDelays = new Vector.<int>();
			steampunkAfterDelays.push(
				25,
				25,
				50,
				150,
				125
			)
			
			steampunkSamplesWeights = [10, 0, 0, 0, 0]
			
			musicLoopTimer = new Timer(1, 1);
			musicLoopTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onMusicLoopTimerComplete);
			
			musTransform = new SoundTransform(0.1);
		}

		//1.0595
		//1.1225		
		
		public function setSound(isSwitched:Boolean):void 
		{
			isSound = isSwitched;
			PlayersAccount.account.setParamOfName("isSound", isSound?"on":"off");
			if (isSound){
				playSteampunkMusic()
			}else{
				musChannel.stop()
			}
		}		
		
		public function setMusic(isSwitched:Boolean):void 
		{
			isMusic = isSwitched;
			//playMusic(isMusic, screenMusicId);
			if (isMusic){
				playSteampunkMusic();
			}else{
				stopSteampunkMusic();
			}
			
			PlayersAccount.account.setParamOfName("isMusic", isMusic?"on":"off");
		}
		
		private function stopSteampunkMusic():void 
		{
			if (musChannel){
				musChannel.stop();
			}			
			return;
			
			if (musChannel){
				musChannel.stop();
			}
			musicLoopTimer.stop();
		}
	

		public function init():void {	
			isMusic = PlayersAccount.account.getParamOfName("isMusic", "on") == "on";
			isSound = PlayersAccount.account.getParamOfName("isSound", "on") == "on";
			
			if (!Main.self.config.doesGameHaveSound){
				isSound = false;
			}
		}		
		
		public function playSteampunkMusic():void{
			if (!isSound){
				return
			}
			var id:int = soundCodes.indexOf("music");
			if (id !=-1){
				var ar:Array = soundFiles[id] as Array;
				if (!ar) {return;}
				if (ar.length == 0){return; } 
				
				var rid:int = Math.floor(Math.random() * ar.length);
			}else{
				return
			}

			var snd:Sound = (soundFiles[id][rid] as Sound);
			
			var ch:SoundChannel = snd.play(0, 999999, new SoundTransform(0.2,0));
			musChannel = ch;
			
			return;
			
			stopSteampunkMusic();
			if (!isMusic){
				return;
			}
			musTransform.volume = 0.1;
			
			id = Routines.getRandomIndexFromWeightedAr(steampunkSamplesWeights);
			
			//var id:int = steampunkMusics.length * Math.random();
			//if (musChannel) {
			//	musChannel.stop();
			//}
			if (steampunkMusics[id]){
				musChannel = steampunkMusics[id].play(25, 0,musTransform);
				//musicLoopTimer.stop();
				musicLoopTimer.delay = steampunkMusics[id].length - steampunkAfterDelays[id];
				musicLoopTimer.reset();
				musicLoopTimer.start();				
			}

			
			//musChannel.addEventListener(Event.SOUND_COMPLETE, onMusicComplete)
		}
		
		private function onMusicLoopTimerComplete(e:TimerEvent):void 
		{
			playSteampunkMusic();
		}	
		
		public function playNewSound(cd:String, vol:Number = 1, pan:Number = 0, dopplerVar:int=-1, loops:int=0):void {
			if (!isSound) {
				return;
			}
			var id:int = soundCodes.indexOf(cd);
			if (id !=-1){
				var ar:Array = soundFiles[id] as Array;
				if (!ar) {return;}
				if (ar.length == 0){return; } 
				if (dopplerVar ==-1){
					var rid:int = Math.floor(Math.random() * ar.length);
				}else{
					rid = dopplerVar;
					if (rid >= ar.length){
						rid = Math.floor(Math.random() * ar.length);
					}
				}
				
				
				var snd:Sound = (soundFiles[id][rid] as Sound);
				if (snd) {
					//добавляем Master Volume для отдельных звуков
					var sndOb:Object = soundsList[id];
					if (sndOb.config){
						if (sndOb.config.volume){
							vol *= sndOb.config.volume;
						}
					}
					
					if ((vol != 1) || (pan != 0)){
						var trans:SoundTransform = new SoundTransform(vol, pan);
					}else{
						trans = null;
					}
					
					var ch:SoundChannel = snd.play(0, 0, trans);
					//if (ch){
					//	trace('Channel created')
					//}else{
					//	trace('No channel')
					//}
				}
			}
		}
		
		
		
		public function handleActivate():void 
		{
			////TODO: resume music
			////if (isMusic){
			//	playSteampunkMusic();
			////}
		}
		
		public function handleDeactivate():void 
		{
			////TODO: pause music
			//stopSteampunkMusic();
		}
		
		public function setAllMusicWeights(b:Boolean):void 
		{
			if (b){
				steampunkSamplesWeights = [10, 5, 1, 8, 5]
			}else{
				steampunkSamplesWeights = [1, 0, 0, 0, 0];
			}
		}
	}
}

//1.0594630943592952645618252949463
//0.94387431268169349664191315666753