package gui.buttons 
{
	import flash.utils.Dictionary;
	import gui.buttons.BasicButton;
	import gui.text.ShadowedTextField;
	import starling.display.MovieClip;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.DropShadowFilter;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class SmallButton extends BasicButton
	{
		//кадры:
		//апгрейд 40
		//покупка 67
		//закрыть 74
		//режимы апгрейда: +1, +10, Max, Next 43.44.45.46
 		//вкл/выкл  8 9
		//настройки 10
		//продажа 67
		//пустое 7
		//языки-флажки 
		//звук вкл/выкл//3,4
		//музыка вкл/выкл5,6
		//меню 11
		//бонус 21
		
		private var baseMC:Image;
		private var iconMC:MovieClip;
		private var coverMC:Image;
		private var cap:ShadowedTextField;
		
		private var sprTop:Sprite;
		
		private var lastUsedFrameStrCode:String = "";
		public function SmallButton(iconFr:int, baseFr:int=1, topFr:int=0)
		{
			var tx:Texture = Assets.allTextures["TEX_SMALLBTNBASE"+baseFr.toString()];
			baseMC = Routines.buildImageFromTexture(tx, this,0,0,null);
			//baseMC = Routines.buildImageFromTexture(Assets.allTextures["TXS_SMALLBTNBASES"][0], this);
			
			//baseMC.touchable = false;
			
			//baseMC.readjustSize(tx.width, tx.height)
			
			sprTop = new Sprite();
			addChild(sprTop);
			iconMC = Routines.buildMCFromTextures(Assets.allTextures["TXS_SMALLBTNICONS"], sprTop, 0, 0, null);
			iconMC.currentFrame = iconFr % iconMC.numFrames;
			iconMC.touchable = false;
			
			cap = new ShadowedTextField('', 0, 8, 70, 1, 1, 0xffffff,0x000000, 'center', 'scale', false, false);
			sprTop.addChild(cap);
			cap.touchable = false;
			
			var txCov:Texture = Assets.allTextures["TEX_SMALLBTNCOVER"+topFr.toString()];
			coverMC = Routines.buildImageFromTexture(txCov, this, 0, 0, null);
			coverMC.touchable = false;
			
			touchable = true;
			touchGroup = true;
		}
		
		public function setBaseFrame(fr:int):void{
			var newTx:Texture = Assets.allTextures["TEX_SMALLBTNBASE" + fr.toString()]
			if (baseMC.texture!=newTx){
				baseMC.texture = newTx;
				baseMC.readjustSize();				
			}

			//надо ли вызывать baseMC.readjustSize(); ?
			
		}
		
		public function setTopFrame(fr:int):void{
			var newTx:Texture = Assets.allTextures["TEX_SMALLBTNCOVER" + fr.toString()]
			if (coverMC.texture!=newTx){
				coverMC.texture = newTx;
				coverMC.readjustSize();				
			}

			//надо ли вызывать coverMC.readjustSize(); ?
		}
		
		public function setCaption(txt:String):void{
			cap.showText(txt);
		}
		
		override public function setUpSate():void 
		{
			sprTop.scale = 1.0;
		}
		
		override public function setDownState():void 
		{
			sprTop.scale = 0.8;
			
		}		
		
		public function setIconByCode(code:String):void {
			var flashFramesOb:Object = {
				download:80,
				upload:81,
				unselected_radio:12,
				selected_radio:13,
				twitter:75,
				facebook:76,
				discord:98,
				reddit:54,
				fandom:53,
				upgrade:40,
				buy:67,
				ruby:68,
				close:74,
				upg_p1:43,
				upg_p10:44,
				upg_max:45,
				upg_next:46,
				selected:8,
				unselected:9,
				settings:10,
				sell:67,
				empty:7,
				sound_on:3,
				sound_off:4,
				music_on:5,
				music_off:6,
				menu:11,
				bonus:21,
				langselect:56,
				info:91,
				recycle:87,
				gdpr:88,
				exclamation:1,
				question:77,
				photo:79,
				edit:78,
				lang_en:100,
				lang_ru:101,
				lang_uk:102,
				lang_es:103,
				lang_it:104,
				lang_de:105,
				lang_fr:106,
				lang_pt:107,
				lang_pl:108,
				lang_cs:109,
				lang_zh:110,
				lang_nl:111,
				lang_ro:112,
				lang_dk:113,
				lang_se:114,
				lang_ko:115,
				lang_jp:116,
				lang_no:117,
				lang_fi:118,
				lang_tr:119
			}
			
			if (flashFramesOb.hasOwnProperty(code)){
				setIconFrame(flashFramesOb[code] - 1);
				lastUsedFrameStrCode = code;
			}else{
				trace("WARNINGcode does not exist:", code)
				lastUsedFrameStrCode = "";
			}
			
			
		}
		
		public function setIconFrame(frid:int):void 
		{
			iconMC.currentFrame = frid % iconMC.numFrames;
		}
		
		public function getIconFrameCode():String{
			return lastUsedFrameStrCode;
		}
	}

}