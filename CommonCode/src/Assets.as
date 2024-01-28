package 
{
	import com.junkbyte.console.Cc;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import managers.ModsManager;
	import starling.assets.AssetManager;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author General
	 */
	public class Assets 
	{
		static public var allTextures:Object;
		
		static public var data4VisObjects:Array = [
		];
		
		static public var dataFromOtherList:Array = [
			["TXS_FACES", "wadd_faces4new", true],
			["TXS_WORLDICONS", "wadd_WorldsIcons4new", true],
		
		
			["TEX_WORD_BLOCKEDCOVER", "wadd_shadowSquareButton4new0000", false],
			["TEX_WORDHL_FRAME", "w000_higlightFrame4new0000", false],
			["TEX_WORDLOCK", "wadd_LockOnWorld4new0000", false],
			["TEX_SPEACHBUBBLE", "wadd_speechBubble4new0000", false],
			["TEX_IDEABULB", "wadd_ideaBulb4new0000", false],
			
			["TEX_STEAMPUNK_LONGLOGO", "wadd_SteampunkLogo4StartSingleLine4new0000", false],
			["TEX_ENGINEER_LONGLOGO", "wadd_GameLogoEngineerSingleLine4new0000", false],
			["TEX_NEMO_LONGLOGO", "wadd_GameLogoNemoSingleLine4new0000", false],
			
			["TEX_GAMENAME", "wadd_babelCaption4new0000", false],
			["TEX_GAMESTARTPAGEBGD", "wadd_bgdStart4new0000", false]
		]
		
		static public var dataFromInterfaceList:Array = [
			["TXS_BITBTNICONS", "w000_bitBtnIcons4new", true],
			["TXS_FONT", "w000_FontEur4nemo", true],
			//["TXS_FONT_KO", "w000_ko-tower-farm-atlas4new", true],
			//["TXS_FONT_JAZH", "w000_jazh-symbols-frames4new", true],
			
			//["TXS_SMALLBTNBASES", "w000_smallBtnBase4new", true],//TEX_SMALLBTNBASE1,2,3 4,5
			["TXS_SMALLBTNICONS", "w000_smallScreenButtons4new", true],
			
			//["TEX_SMALLBTNCOVER0",	"w000_smallBtnCover04new0000",	false],
			// скаверами делаем аналогично бейзам - динамически создаём переменные
			
			["TEX_SMALLBTN_OUTLINE", "w000_btnOutline4new0000", false],
			["TEX_SMALLBTN_HINTBASE", "w000_ButtonHint4new0000", false],
			["TEX_SMALLBTN_SHADOW", "w000_buttonShadow4new0000", false],			
			
			["TXS_BTN_TOP", "w000_newBitBtnTop4new", true],
			["TXS_BTN_FRONT", "w000_newBitBtnFront4new", true],
			["TEX_BTN_HIGHLIGHTRAY", "w000_buttonHighlightRay4new0000", false],		
		
			["TXS_ICONS_ONTABS", "w000_newintBigTabIcons4nemo", true],
			
			["TEX_HEXBTN_PRESELECTMARKER", "w000_preSelectedButtonMarker4new0000", false],
			
			["TEX_ICON_INSTA", "w000_bonInsta4new0000", false],
			
			["TEX_SILENTFILM_SHORTMESSAGEBASE", "w000_TooltipBase4new0000", false],
			["TEX_SILENTFILM_BUTTON", "w000_SFButton4nemo0000", false],
			["TXS_SILENTFILM_DEBRIS", "w000_SFDebris4new", true],
			["TEX_SILENTFILM_ORNAMENT_TOP", "w000_SFElem14new0000", false],
			["TEX_SILENTFILM_ORNAMENT_TOPSIDE", "w000_SFElem24new0000", false],
			["TEX_SILENTFILM_ORNAMENT_SIDE", "w000_SFElem34new0000", false],
			["TEX_SILENTFILM_ORNAMENT_BOTTOM", "w000_SFElem44new0000", false],
			

			
			["TEX_SMALLEXCLMARK", "w000_infUpdate4new0000", false],
			["TEX_SMALLQUESTMARK", "w000_infQuestion4new0000", false],
			
			["TEX_SMALLTAB", "w000_tab4ShopIconAndPrice4nemo0000", false],
			["TEX_LONGTAB", "w000_newintLongTab4nemo0000", false],
			["TEX_SQUARETAB_GREEN", "w000_newIntShopBase4nemo0000", false],
			["TEX_SQUARETAB_BROWN", "w000_newintTabBase4nemo`0000", false],
			["TEX_SMALLSIDETAB", "w000_newintShopSideBtn4nemo0000", false],
			
			["TEX_LONGPANEL_TOP", "w000_machineDetailsBgd4new0000", false],
			["TEX_LONGPANEL_BOT", "w000_machineDetailsBgdDown4new0000", false],
			

			["TEX_NINEPARTALL",	"w000_NinePartAll4new0000",	false],
			
			["TEX_BTNHL_TOPLEFT", "w000_newintFreeItemsHighlight4nemo0000", false],
			["TEX_BTNHL_LEFT", "w000_newintLeftHghlight4nemo0000", false],
			["TEX_BTNHL_RIGHT", "w000_newintRightHighlight4nemo0000", false],
			["TEX_BTNHL_BOTTOM", "w000_newintShopButtonBottomHighlight4nemo0000", false],
			["TEX_BTNHL_TOP", "w000_newintShopButtonTopHighlight4nemo0000", false],
			
			["TEX_ARR_UP", "w000_newIntMinusRowButton4nemo0000", false],
			["TEX_ARR_DOWN", "w000_newintPlusRowButton4nemo0000", false],
			
			["TEX_TMP_WHITESQUARE", "w000_tmpSquare4new0000", false],
			["TEX_TUTHAND", "w000_tutHand4new0000", false],
			
			
			
			["TEX_IDEABULB", "wadd_ideaBulb4new0000", false],
			
			["TEX_STEAMPUNK_LONGLOGO", "wadd_SteampunkLogo4StartSingleLine4new0000", false],
			["TEX_ENGINEER_LONGLOGO", "wadd_GameLogoEngineerSingleLine4new0000", false],
			["TEX_NEMO_LONGLOGO", "wadd_GameLogoNemoSingleLine4new0000", false]
		]
		
		static public var dataFromChainWorld:Array = [
			["TEX_WORKERSIMPLE",	"w031_workerSimple4new0000",	false],
			["TXS_WORKERSIMPLE",	"w031_workerSimple4new",	true],
			["TEX_HUMANSHADOW",	"w031_humanShadow4new0000",	false],
			["TEX_RESTAURANTTABLE",	"w031_restaurantTable4new0000",	false],
			["TEX_PIZZATABLE",	"w031_pizzatable4new0000",	false],
			["TEX_LEMONADETABLE",	"w031_lemonadeTable4new0000",	false],
			["TEX_LEMONTREE",	"w031_lemonTree4new0000",	false],
			["TEX_TOPINFORMERTAB",	"w031_topInformerTab4new0000",	false]
		]
		static public var artDataByWorlds:Array = [];
		
		static public var artDataBySkins:Object = {};
		
		static public var manager:starling.assets.AssetManager;
		
		static private var workingWorldId:int = -1;
		static public var workingSkinCode:String = "";
		
		static private var numLoadedImages:int = -1;
		static private var workingSkinOb:Object = null;

		static public var modsManager:managers.ModsManager;
		public function Assets() 
		{
			
		}
		
		//будет вызываться только с wid==-1, на самом старте
		static public function init(wid:int):void 
		{			
			//скин содержит данные с разных массивов типа dataFromInterfaceList
			artDataBySkins["31_standard"]=[dataFromChainWorld]
			
			modsManager = new ModsManager();
			modsManager.listAllMods();
			
			//Cc.log('assets init');
			workingWorldId = wid;
			//загружаем картинки и звуки из папки приложения /data
			manager = new AssetManager();
			manager.verbose = false;
			
			var appDir:File = File.applicationDirectory;
			manager.enqueue(appDir.resolvePath("data/all"));
			
			//if (wid !=-1){
			manager.enqueue(appDir.resolvePath("data/" + wid.toString()));
			//}
			
			if (Main.self.config.doesGameHaveSound){
				manager.enqueue(appDir.resolvePath("data/sound"));
			}			
			
			manager.loadQueue(StarApp.app.onAssetsLoadComplete,StarApp.app.onAssetsLoadError, StarApp.app.onAssetsLoadProgress);//что должно произовйти, пока грузятся картинки
		}
		
		static public function switchMergedArt4World(wid:int, skinOb:Object):void 
		{
			trace('switchMergedArt4World', wid);
			//Cc.log('switchMergedArt4World', wid);
			
			if (workingSkinCode != skinOb.code){
				var imgs2Remove:int = numLoadedImages;
				workingSkinCode = skinOb.code;
				numLoadedImages = skinOb.numFiles;
				workingSkinOb = skinOb;
				
				workingWorldId = wid;
				//var vec:Vector.<String> = manager.getTextureAtlasNames();
				//trace(vec);
				manager.removeTextureAtlas('MergedArt');
				for (var i:int = 1; i < imgs2Remove; i++ ){
					manager.removeTextureAtlas('MergedArt'+i.toString());
				}
				
				var appDir:File = File.applicationDirectory;
				var defaultArtDir:File = appDir.resolvePath("data/" + skinOb.folder);
				if (modsManager.getSelectedModFolder()=="none"){
					manager.enqueue(defaultArtDir);	
				}else{
					var fld:File = appDir.resolvePath("mods/" + modsManager.getSelectedModFolder() +"/"+ skinOb.folder);
					if (fld.exists){
						manager.enqueue(fld);
					}else{
						manager.enqueue(defaultArtDir);	
					}
				}
					
				manager.loadQueue(StarApp.app.onAdditionalAssetsLoadComplete,StarApp.app.onAdditionalAssetsLoadError, StarApp.app.onAdditionalAssetsLoadProgress);//что должно произовйти, пока грузятся картинки
			}else{
				//if (workingWorldId != wid){
				//cюда мы должны заходить всегда. А то получится так - удалили всё из мира, а потом его не загрузили
					workingWorldId = wid;
					StarApp.app.onAdditionalAssetsLoadComplete();
				//}
			}
			
		}		
		
		static public function setVariables():void 
		{
			allTextures = new Object();
			data4VisObjects.length = 0;
			
			loadArray2Data(dataFromOtherList);
			loadArray2Data(dataFromInterfaceList);
			
			var artDataAr:Array = artDataBySkins[workingSkinCode]
			if (artDataAr){
				for (var i:int = 0; i < artDataAr.length; i++ ){
					loadArray2Data(artDataAr[i]);
				}
			}
			
			
			for (i = 0; i < data4VisObjects.length; i++ ){
				var ar:Array = data4VisObjects[i];
				if (!ar[2]){
					allTextures[ar[0]] = manager.getTexture(ar[1])//<- this is a Texture
				}else{
					allTextures[ar[0]] = manager.getTextures(ar[1])//<- this is a vector of Textures
				}
			}
			//а теперь - кнопки
			var id:int = 1;
			while (true){
				var tx:Texture = manager.getTexture("w000_smallBtnBase" + id.toString() + "4new0000");
				if (tx){
					allTextures["TEX_SMALLBTNBASE" + id.toString()] = tx;
					id++
				}else{
					break;
				}
				
			}
			//и каверы на баттоны
			id = 0
			while (true){
				tx = manager.getTexture("w000_smallBtnCover" + id.toString() + "4new0000");
				if (tx){
					allTextures["TEX_SMALLBTNCOVER" + id.toString()] = tx;
					id++
				}else{
					break;
				}
			}
			
			//trace(stx.frame);
			//trace(stx.region);
			//trace(stx.region.left);
			//trace(stx.region.right);
			
			//докидываем корейский фонт к евро
			var allFont:Vector.<Texture> = allTextures["TXS_FONT"]
			trace(allFont.length);
			/*
			var specFonts:Array = ["TXS_FONT_KO", "TXS_FONT_JAZH"]
			for (var j:int = 0; j < specFonts.length; j++){
				var koFont:Vector.<Texture> = allTextures[specFonts[j]];
				if (koFont){
					for (i = 0; i < koFont.length; i++){
						allFont.push(koFont[i]);
					}				
				}				
			}*/

			//trace(allFont.length);
			//for (var i:int = 370; i < 380; i++){
			//	trace(i, allFont[i].width);
			//}
		}
		
		static private function cutSubTextureSides(code:String, horz:Boolean, vert:Boolean):void 
		{
			var stx:SubTexture = allTextures[code];
			if (stx){
				allTextures[code] = new SubTexture(stx.parent, new Rectangle(stx.region.x + (horz?2:0), stx.region.y + (vert?2:0), stx.region.width - (horz?4:0), stx.region.height - (vert?4:0)));	
			}
		}
		
		static private function loadArray2Data(dataAr:Array):void 
		{
			for (var i:int = 0; i < dataAr.length; i++){
				data4VisObjects.push(dataAr[i]);
			}
		}

		static public function getTextureByFrameCode(str:String):Texture{
			return manager.getTexture(str);
		}
		
	}

}