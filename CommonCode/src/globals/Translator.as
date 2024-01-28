package globals 
{
	import com.junkbyte.console.Cc;
	import flash.globalization.LocaleID;
	import flash.globalization.StringTools;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import gui.text.MultilangTextField;
	import managers.ExternalTranslationsManager;
	import mx.resources.Locale;

	/**
	 * ...
	 * @author ...
	 */
	public class Translator 
	{
		public static var translator:Translator;
		
		public var westernSymbols:String = "0123456789.,;:!?/_+-=~#$^&*()[]{}<>%@|'¿¡AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZzÀàÉéËëÏïĲĳÁáÊêÈèÍíÎîÔôÓóÚúÛûÆæØøÅåÄäÖöŠšŽžÕõÜüßĂăÂâŞşŢţÇçĞğİıŐőŰűŒœÙùŸÿÃãÑñÌìÒòĄąŁłŃńŻżĆćĘęŚśŹźČčĐđĎďĚěŇňŘřŤťŮůÝýĽľĹĺŔŕĀāĒēĢģĪīĶķĻļŅņŌōŖŗŪūĖėĮįŲųАаБбВвГгДдЕеЖжЗзИиКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЙйЩщЬьЮюЯяҐґЄєІіЇїЪъЁёЭэЫыЎўЉљЊњЏџЈјЋћЂђЃѓЌќЅѕӁӂțșȚȘ\"«»„“”\u21e6\u21e8\u21e7\u21e9©¤¥Ұƒ₣£₤圓€₪₴₸₺₯₩﷼₨฿₲₫₭₡₦₵₮₽";

		public var easternSymbols:String = 
		//jazh
		"すまーをのし的たに生ンでてるッいスがりトは可以产ル水な您か、レ！クイと用きあさ。こプくれ存物，リドタ在アら保速木人度成産作出コ到ラ工牛提ムめ石送菜有将个ロ金更食场动多了加建テフ告場っ土储入だ力种う一け中发よ油ジ新？能粘植我得源草口格造农バも動せ（）和ベシガ矿并时ゲブ自量小行売材输使下品最数蜂开长奶ボチ明始取ワグキ制子重游戏售果科再花学塔想点击增启每收从蔬卖不法んビ料上运获ポィ管エデオ们ウ完市起ピ家受ナ高お大購時そ接面器机这升资购柠檬ソ販者ニ間前農广价奖是买铁パ広次べ所野香私輸同回ャマ地板店后你葵分後向羊続モ文要信業麦蜜进级选让头み世空選択発期供増代山蒸日ァュ解当鉱复请择为厂汽砖見ち価サ象粉糖声吗码比间现谢已钱萨织利界やョ効来％周望衣ミ容集施电看备或棉薰甘蔗房カ全名倍長ェ育炭陶気ザ理必設感商率置魔术对没件载玩图里费如设酪毛ご開方ツ働鉄本ズダ持ど字意今星过采货锁此劳查按轮养煤南瓜业元無変え限メ：復正収掘ギ好つ手何改留除確化年電ゴ部宝会励币赛硬别准交效给鱼冰袜气披纺恤籽树需ょ現他ざ押ヤ切認わ乳展待備常外功森労ネ消屋住跳恢快放插槽经拉于棚检田赚免包线书连杂车其员带達準々定合事セ構築月惑ぐ機雨深猫沿筋ひ戻表内残直益獲失稼採給充道貯蔵車種牧钻红继续关只户礼位够社区滚据些它试未另之闲炼创转银锻筑河被纱馆园拖传做波結関足十処進計書じ助床換捕燃厚活室配雇綿砂服民良示性影毎週ヒ案追強仕ユ謝翻読込火薬げ探特雲抽製海耕魚精熟结由许相观份喜模式什么等朋稍但问计款丁适针也强应泊楼立天克装齿蛋旋平各挖殖钢浇照顾块慢厨泵坑写屏幕达剪贴邮語昇引別実費修投票林黄ハ色ペぎ養促転流非穫氷糸畑百具原都連報酬推測友割公歩与統贈身言触音訳超善応敗む早械観客付枯渇ヘォ刻掛秒万銀川允打才而帐猜恭欢导整找谐确息隐政策折扣否程变步题统形令决母总去视然议篮鸡雷师着烘烤涨构站烹饪粮渡船绵缝纫风错扩情域居耗尽帮销编实验吃梯执纹白云箱伐单哪真截碎壤聚就败乘离刀龙通資負荷ケ階主飛ゆ索術爆易研究段太己錬布台焼村調編話炉吹岸靴冶冷庭堂播威緒貨響褒美致誤額招参び質問念楽初買跡規約齢護＆著勝列適予撮申賞賛考慮図干ば宇宙光窓落貴含ノ井戸軌遠繋乗算勧離値夫単蛇査ほ創歯卵億堆積散寝繊維風鍛栽培届師輪壌盒套耙鹳漩涡撤且扰响辞职聘跃邀排榜办处众评论核心因节省称愉悦第测仪清该尚状态任须较版挤睡觉仍犁迎亨喂难底瓶盖挑战富翁随跟踪首项条龄监护溢庄添肴延伸填话饲济钓冻艺勤孔控专神语误授朵伪缓类型饭那贵沉积铲霉菌满谷匠桥纳斩联系舍尔鲜铸库扶椅脸路轴泼德泰勒务团队权译乌兰国防样体额街走桌极篷胜绪某很符串剩抱歉无欣赏愿还黏沙番至崩溃尝报症巢值棵负皮释城検討鎖骨ホ冬登・傾斜個教際競争ぶ撃先端技舗岩補巨降壮旅貿砲噴衛陽鏡摂知叩験膨瞬欠係芝刈渦ず搾眠様織埋呼飼経済釣凍群典削縫御紡拡類移満穀橋庫館顔軸画穴宅捗粒ぼゃ"
		+//ko
		"다니을시이습하를수가에합있장고자기은오드로산십생서는보사한지스물할의도리성어게작더인매구저당나돌으레속것원계광트해유업신과판제일라소상임전모무면입용동우너되비간아재었그공벽금부위농음여주선양까화운바건채료발터워송내배석만정설요많타식얻치코명향클점력학중택출복디려격돈들증개탑달토행능두준대야탭실했관싶루연거름확필결된않완크파감황받백추테벨플변경철탕말세마티적량피높러와후든품잠분커진빨킵법호린집밀현미축슬롯충류셔른강벌프됩몬락문키및목잔최컨없람안데효져팔즈객꿀잘래번립굴엔릭체천랍포벤박때릴영겨활뮤록새방았환약히메탄조베창휴겠련불초롤같먹급펌릅통찾못책남회직암예팀옵승될또헬근얼츠봉씨단질버열쓰별졌낼날표닥떤갈험율핑론숲따덩빵누취귀처죄태난좋특샷넘텍살패년뛰뜁골르빌층늘잡술외톱곳퍼네브펑섬봅짜앗젖볼측콘힌틴권함역익닙투곡울반쟁냅듭훨씬끼탐폭콥엘올멀머란곱힘깊랙차휘짓국렇찮딧빈큰친짐랜잭션뷰므픽즐겁첫놓숫항쿠령언뉴딘본닌절엇촬움칠뭔됐월펠딩빠웁떨줍톤궤침온캐셀득흐앞청납텐률닭놀병캡챌케굽줄밭룻노닝풍슷카옷눌켓맥림킬킷흙손빛등칼엠께쏘땅듬뜨떻텔웅낙글숍혐윙털망밴옮냥알곧엄순갑족총킹편떼센교꽃둑뿌형퇴삽엌탠풀냉갱퀴틀샤셰웃캔웨넣꺼솔널빤샐종걷펴링쓸"
		
		public var allSymbols:String = "";
		
		public var westDict:Dictionary=new Dictionary();
		public var allDict:Dictionary=new Dictionary();
		
		public var whiteSpaces:String=" 	​\n\u200b​​"
		public var notFoundBahasaSymbols:String = "ĨĩŨũƠơƯưẠạẢảẤấẦầẨẩẪẫẬậẮắẰằẲẳẴẵẶặẺẻẼẽẾếỀềỂểỄễỆệỈỉỊịỌọỎỏỐốỒồỔổỖỗỘộỚớỜờỞởỠỡỢợỤụỦủỨứỪừỬửỮữỰựỲỳỸỹ"
		public var subststitutes4BahasaS:String = "ĪīŰűÓóŰűĄąĂăĂăÂâÂâÂâÂâĂăĂăĂăĂăĂăĚěĚěĚěĚěĚěĚěĚěİıIiOoŌōÔôÔôÔôÔôÔôÓóÓóÓóÕõÓóUuÚúÚúÚúÚúŪūUuÝýÝý"//Какими имеющимися диакритиками заменяем малайские
		
		public var alphabet4Gifts:String = "QWERTYUIOPASDFGHJKLZXCVBNM123456789";//0 ЗАМЕНЯЕМ НА O
		
		public var separatorSymbols:String = " .,;:!?/+-=#$^&*()[]{}<>%@|'¿¡	 "//то же, но без цифр, чтобы не дробить числа
		
		private var lettersInTextCode:String = 'QWERTYUIOPASDFGHJKLZXCVBNM_0123456789'
		
		//en,ru,uk,es,it,de,fr,pt, pl, cz, ch, nl, ro, da, sv, ko, ja, no, fi, tr//
		public var availableLangs:Array = ['en']//, 'uk', 'pl', 'cs', 'sk', 'ro', 'hu', 'nl', 'de', 'es', 'fr', 'tr', 'it', 'pt', 'ms', 'id', 'ru', 'vi', "ko", "ja", "zh" ];
		private var langNames:Object = {"en":"English","ru":"Русский","uk":"Українська","de":"Deutsch","es":"Español","fr":"Français","pl":"Polski","tr":"Türkçe","it":"Italiano","cs":"Český","sk":"Slovenský","pt":"Português","ms":"Bahasa Melayu","id":"Bahasa Indonesia","vi":"Tiếng Việt","ro":"Limba română", "hu":"Magyar", "nl":"Nederlands", "ptfun":"HyperTranslated Portuguese", "ko":"한국어", "ja":"日本語", "zh":"中文"}
		private var langTranslatorsNames:Object = {"de":"Fielen Dank an MoonlightShadowz aus ArmorGames!", "es":"Muchas gracias por la traducción a Roy Clark aka Blokus52 desde ArmorGames","pt":"Starkinho, Rizizum, André Caldeira", "hu":"Toronyi Zsombor (Kevinkutya)","pl":"Łukasz Gazda","id":"Irfan Najmi","ms":"Irfan Najmi","cs":"Kevo","sk":"Kevo", "nl":"R0binator", "it":"Gingerino333", "fr":"bixente alias etnexib"}
		private var langTranslatorsSites:Object = {"en":"", "cs":"https://kevo.link", "sk":"https://kevo.link"}
		private var langTranslationsComments:Object = {"en":"", 
											"de":"Might contain some auto translated phrases. If you'd like to improve the translation, please, email general@cardswars.com",
											"es":"Might contain some auto translated phrases. If you'd like to improve the translation, please, email general@cardswars.com",
											"pl":"Might contain some auto translated phrases. If you'd like to improve the translation, please, email general@cardswars.com",
											"cs":"Might contain some auto translated phrases. If you'd like to improve the translation, please, email general@cardswars.com",
											"sk":"Might contain some auto translated phrases. If you'd like to improve the translation, please, email general@cardswars.com",
											"ms":"Might contain some auto translated phrases. If you'd like to improve the translation, please, email general@cardswars.com",
											"id":"Might contain some auto translated phrases. If you'd like to improve the translation, please, email general@cardswars.com",
											"pt":"",
											"ro":"Auto translated. If you'd like to improve the translation, please, email general@cardswars.com",
											"fr":"Auto translated. If you'd like to improve the translation, please, email general@cardswars.com",
											"tr":"Auto translated. If you'd like to improve the translation, please, email general@cardswars.com",
											"vi":"Auto translated. If you'd like to improve the translation, please, email general@cardswars.com"
		}
		public var langsTranslatedByDev:Array = ["en"];
		
		private var langCode:String = 'en';
		private var allPhrases:Dictionary = new Dictionary();//тот общий интерфейс и пр., нужные много раз 
		private var specialPhrases:Dictionary = new Dictionary();//тут будут фразы из игры (не нужные в других) на старте будут добавляться в allPhrases
		
		private var updatedTexts:Vector.<MultilangTextField> = new Vector.<gui.text.MultilangTextField>();
		
		private var lastUsedLangCode:String="xxxx";
		private var manager:ExternalTranslationsManager;
		

		private var skipTranslating:Boolean = false;
		
		
		public function Translator() 
		{
			translator = this;
			//takes from properties
			this.allPhrases["TXID_LANGNAME"] = langNames;
			this.allPhrases["TXID_LANGTRANSLATORWEBSITE"] = langTranslatorsSites
			this.allPhrases["TXID_LANGTRANSTHANKS"] = langTranslatorsNames;
			this.allPhrases["TXID_LANGTRANSCOMMENT"] = langTranslationsComments;
			
			this.allPhrases["TXID_CAP_CONTINUE"] = {"en":"Continue"}
			this.allPhrases["TXID_CAP_ACCEPTCONT"] = {"en":"Accept & Continue"}
			this.allPhrases["TXID_GDPR_APPLE_ADD"] = {"en":"By pressing Continue you will accept the policy and terms and will proceed to select your tracking preferences on the next screen"}
			this.allPhrases["TXID_GDPR_APPLE_ADD_ALT"] = {"en":"As you continue you will be able to select your tracking preferences"}			
			
			//---------------------------------------------------------------------------//			
			
			this.allPhrases["TXID_ANS_GET"] = {"en":"GET!","ru":"ПОЛУЧИТЬ!","uk":"ОТРИМАТИ!","de":"BEKOMMEN!","es":"¡OBTENER!","fr":"AVOIR!"}
			this.allPhrases["TXID_CAP_ACCEPT"] = {"en":"Accept & Start!","ru":"Принять и продолжить","uk":"Прийняти та продовжити","de":"Akzeptieren & Start!","es":"Aceptar & Start!","fr":"Accepter & Start!"}
			this.allPhrases["TXID_CAP_AIRAPPORT"] = {"en":"by Airapport","ru":"by Airapport","uk":"by Airapport","de":"by Airapport","es":"by Airapport","fr":"par Airapport"}
			this.allPhrases["TXID_CAP_ARTIFACTS"] = {"en":"ARTIFACTS","ru":"АРТЕФАКТЫ","uk":"АРТЕФАКТИ","de":"ARTEFAKTE","es":"ARTEFACTOS","fr":"ARTEFACTS"}
			this.allPhrases["TXID_CAP_BOOSTS"] = {"en":"BOOSTS","ru":"БОНУСЫ","uk":"БОНУСИ","de":"VORTEILE","es":"BOOSTS","fr":"RENFORCE"}
			this.allPhrases["TXID_CAP_BREAKCODE"] = {"en":"Guess the code to get your weekly gift","ru":"Угадайте код, чтобы получить еженедельный подарок","uk":"Вгадайте код, щоб отримати щотижневий подарунок","de":"Raten Sie den Code Ihr wöchentliches Geschenk zu erhalten","es":"Adivinar el código para obtener su regalo semanal","fr":"Devinez le code pour obtenir votre cadeau hebdomadaire"}
			this.allPhrases["TXID_CAP_CARAWANSETTINGS"] = {"en":"Caravan autosell resources","ru":"Автоматическая продажа ресурсов","uk":"Автоматичний продаж ресурсів","de":"Caravan autosell Ressourcen","es":"recursos autoventa caravanas","fr":"ressources autosell Caravan"}
			this.allPhrases["TXID_CAP_CREDITS"] = {"en":"CREDITS","ru":"АВТОРЫ","uk":"АВТОРИ","de":"CREDITS","es":"CRÉDITOS","fr":"CRÉDITS"}
			this.allPhrases["TXID_CAP_DAILYBONUS"] = {"en":"DAILY BONUS","ru":"ЕЖЕДНЕВНЫЙ БОНУС","uk":"ЩОДЕННИЙ БОНУС","de":"TÄGLICHER BONUS","es":"BONUS DIARIO","fr":"BONUS QUOTIDIEN"}
			this.allPhrases["TXID_CAP_DOYOULIKEGAME"] = {"en":"Do you like the game?","ru":"Вам нравится игра?","uk":"Вам подобається гра?","de":"Mögen Sie das Spiel?","es":"¿Te gusta el juego?","fr":"Est-ce que vous aimez le jeu?"}
			this.allPhrases["TXID_CAP_ENTERCODE"] = {"en":"ENTER CODE","ru":"ВВЕДИТЕ КОД","uk":"ВВЕДІТЬ КОД","de":"CODE EINGEBEN","es":"INTRODUZCA EL CÓDIGO","fr":"ENTREZ LE CODE"}
			this.allPhrases["TXID_CAP_FINDHINTS"] = {"en":"Find the hints inside the game or...","ru":"Найдите подсказки внутри игры или ...","uk":"Знайти підказки всередині гри або ...","de":"Finden Sie die Hinweise im Spiel oder ...","es":"Encuentra las pistas dentro del juego o ...","fr":"Trouver les conseils à l'intérieur du jeu ou ..."}
			this.allPhrases["TXID_CAP_FREE"] = {"en":"FREE","ru":"БЕСПЛАТНО","uk":"БЕЗКОШТОВНО","de":"KOSTENLOS","es":"GRATIS","fr":"LIBRE"}
			this.allPhrases["TXID_CAP_GETBIGGERBONUS"] = {"en":"BIGGER BONUS","ru":"БОЛЬШЕ БОНУС","uk":"БІЛЬШИЙ БОНУС","de":"MEHR BONUS","es":"mayor prima","fr":"BONUS PLUS GRAND"}
			this.allPhrases["TXID_CAP_GETMORECODESINDISCORD"] = {"en":"Get more codes in our Discord","ru":"Получите больше кодов в нашем Дискорде","uk":"Отримати більше кодів в нашому Дискорді","de":"Erfahren Sie mehr Codes in unserem Discord","es":"Obtener más códigos en nuestra Discord","fr":"Plus de codes dans notre Discord"}
			this.allPhrases["TXID_CAP_INDISCORD"] = {"en":"in Discord","ru":"в Discord","uk":"у Discord","de":"in Discord","es":"en Discord","fr":"en Discord"}
			this.allPhrases["TXID_CAP_INF_LEVEL"] = {"en":"level","ru":"уровень","uk":"рівень","de":"Ebene","es":"nivel","fr":"niveau"}
			this.allPhrases["TXID_CAP_INF_MONEY"] = {"en":"Coins","ru":"Монеты","uk":"Монети","de":"Münzen","es":"Dinero","fr":"Monnaie"}
			this.allPhrases["TXID_CAP_INF_NOTENOGHMONEY"] = {"en":"Not enough money","ru":"Недостаточно денег","uk":"Недостатньо коштів","de":"Nicht genug Geld","es":"Dinero insuficiente","fr":"Pas assez d'argent"}
			this.allPhrases["TXID_CAP_INF_NOTENOUGHRES"] = {"en":"Not enough resources","ru":"недостаточно ресурсов","uk":"недостатньо ресурсів","de":"nicht genug Resourcen","es":"No hay suficientes recursos","fr":"Pas assez de ressources"}
			this.allPhrases["TXID_CAP_INF_PURCHPRICE"] = {"en":"PURCHASE PRICE","ru":"ЦЕНА ПОКУПКИ","uk":"ЦІНА ПОКУПКИ","de":"KAUFPREIS","es":"PRECIO DE COMPRA","fr":"PRIX D'ACHAT"}

			this.allPhrases["TXID_CAP_MARKET"] = {"en":"MARKET","ru":"РЫНОК","uk":"РИНОК","de":"MARKT","es":"MERCADO","fr":"MARCHÉ"}
			this.allPhrases["TXID_CAP_MOREGAMES"] = {"en":"MORE GAMES","ru":"НАШИ ИГРЫ","uk":"НАШІ ІГРИ","de":"MEHR SPIELE","es":"MÁS JUEGOS","fr":"PLUS DE JEUX"}
			this.allPhrases["TXID_CAP_NEWS"] = {"en":"NEWS","ru":"НОВОСТИ","uk":"НОВИНИ","de":"NACHRICHTEN","es":"NOTICIAS","fr":"NOUVELLES"}
			this.allPhrases["TXID_CAP_NEXTBONUSIN"] = {"en":"Time till the next bonus","ru":"Время до следующего бонуса","uk":"Час до наступного бонусу","de":"Zeit bis zum nächsten Bonus","es":"Tiempo hasta la próxima bonificación","fr":"Le temps jusqu'à ce que le prochain bonus"}
			this.allPhrases["TXID_CAP_POLICY"] = {"en":"Privacy policy","ru":"Политикаs конфиденциальности","uk":"Політика конфіденційності","de":"Datenschutz-Bestimmungen","es":"Política de privacidad","fr":"Politique de confidentialité"}
			this.allPhrases["TXID_CAP_PURCHASE"] = {"en":"PURCHASE","ru":"КУПИТЬ","uk":"КУПИТИ","de":"KAUF","es":"COMPRAR","fr":"ACHAT"}
			this.allPhrases["TXID_CAP_PURCHASE_DISCOUNT"] = {"en":"DISCOUNT","ru":"СКИДКА","uk":"ЗНИЖКА","de":"RABATT","es":"DESCUENTO","fr":"REMISE"}
			this.allPhrases["TXID_CAP_RATEGAME"] = {"en":"Could you, please, leave a public review to let more people find the game?","ru":"Вы могли бы написать отзыв об игре, чтобы больше игроков её увидели?","uk":"Ви могли б написати відгук про гру, щоб більше гравців її побачили?","de":"Könnten Sie, lassen Sie bitte eine öffentliche Kritik mehr Leute das Spiel finden zu lassen?","es":"¿Podría, por favor, dejar un comentario público para permitir que más personas encuentran el juego?","fr":"Pourriez-vous, s'il vous plaît, laissez un examen public de laisser plus de gens trouvent le jeu?"}
			this.allPhrases["TXID_CAP_RESTART"] = {"en":"RESTART","ru":"ПЕРЕЗАПУСК","uk":"ПЕРЕЗАПУСК","de":"NEUSTART","es":"REINICIAR","fr":"REDÉMARRER"}
			this.allPhrases["TXID_CAP_SCIENCEUPGRADES"] = {"en":"Science upgrades","ru":"Научные улучшения","uk":"наукові поліпшення","de":"Wissenschaft Upgrades","es":"mejoras de ciencia","fr":"mises à jour scientifiques"}
			this.allPhrases["TXID_CAP_SMALLQUESTION"] = {"en":"I want to ask you one small question...","ru":"Хочу задать один вопрос...","uk":"Хочу задати одне питання ...","de":"Ich möchte Ihnen eine kleine Frage stellen ...","es":"Quiero pedirte un pequeño pregunta ...","fr":"Je veux vous poser une petite question ..."}
			this.allPhrases["TXID_CAP_SORRY"] = {"en":"Sorry for that...","ru":"Мне очень жаль...","uk":"Мені дуже шкода...","de":"Das tut mir leid...","es":"Lo siento por eso...","fr":"Désolé..."}
			this.allPhrases["TXID_CAP_START"] = {"en":"START","ru":"СТАРТ","uk":"СТАРТ","de":"START","es":"COMIENZAR","fr":"DÉBUT"}
			this.allPhrases["TXID_CAP_TELLWHY"] = {"en":"Would you, please, suggest some ways how to make it enjoyable?","ru":"Пожалуйста, может быть, посоветуете, как её улучшить?","uk":"Будь ласка, може бути, порадите, як її поліпшити?","de":"Würden Sie empfehlen bitte, einige Möglichkeiten, wie es angenehm wie möglich zu machen?","es":"¿Podría usted, por favor, sugerir algunas maneras de cómo para que sea agradable?","fr":"Voulez-vous, s'il vous plaît, suggérer des façons comment le rendre agréable?"}
			this.allPhrases["TXID_CAP_THANKYOU"] = {"en":"Thank you so much!","ru":"Спасибо огромное!","uk":"Дуже дякую!","de":"Ich danke dir sehr!","es":"Muchas gracias!","fr":"Merci beaucoup!"}
			this.allPhrases["TXID_CAP_UPGRADE"] = {"en":"UPGRADE","ru":"АПГРЕЙД","uk":"АПГРЕЙД","de":"UPGRADE","es":"MEJORAR","fr":"AMÉLIORER"}
			this.allPhrases["TXID_CAP_WEEKLYBONUS"] = {"en":"WEEKLY GIFTS","ru":"Еженедельные ПОДАРКИ","uk":"щотижневі ПОДАРУНКИ","de":"WOCHEN GESCHENKE","es":"REGALOS SEMANALES","fr":"CADEAUX PAR SEMAINE"}

			this.allPhrases["TXID_CODE_CODE"] = {"en":"CODE","ru":"КОД","uk":"КОД","de":"CODE","es":"CÓDIGO","fr":"CODE"}
			this.allPhrases["TXID_CODE_FOREVERYONE"] = {"en":"for everyone","ru":"для каждого","uk":"для всіх","de":"für jeden","es":"para todo el mundo","fr":"pour tout le monde"}
			this.allPhrases["TXID_CODE_FORPLAYER"] = {"en":"for the player","ru":"для игрока","uk":"для гравця","de":"für den Spieler","es":"para el jugador","fr":"pour le joueur"}
			this.allPhrases["TXID_CODE_TILL"] = {"en":"till","ru":"до","uk":"до","de":"bis","es":"hasta que","fr":"jusqu'à ce que"}
			this.allPhrases["TXID_CODE_VALIDFROM"] = {"en":"valid from","ru":"Действует с","uk":"діє з","de":"gültig ab","es":"válida desde","fr":"Valide à partir de"}
			this.allPhrases["TXID_CODE_VALIDINF"] = {"en":"valid always","ru":"действителен всегда","uk":"діє завжди","de":"gültig immer","es":"válida siempre","fr":"toujours valide"}
			this.allPhrases["TXID_CODE_WORLD"] = {"en":"for the world","ru":"для мира","uk":"для світу","de":"Für die Welt","es":"por el mundo","fr":"pour le monde"}

			this.allPhrases["TXID_CODEERR_ALREADYUSED"] = {"en":"You have already used this code","ru":"Вы уже использовали этот код","uk":"Ви вже використовували цей код","de":"Sie haben bereits diesen Code verwendet","es":"Ya ha utilizado este código","fr":"Vous avez déjà utilisé ce code"}
			this.allPhrases["TXID_CODEERR_EXPIRED"] = {"en":"This code has expired or not yet active","ru":"Этот код уже истек или еще не существует","uk":"Цей код вже закінчився або ще не існує","de":"Dieser Code ist abgelaufen oder noch nicht aktiv","es":"Este código ha caducado o aún no está activo","fr":"Ce code a expiré ou non encore actif"}
			this.allPhrases["TXID_CODEERR_NOEFFECT"] = {"en":"At the current game state the code will not have any effect. Please, try again later","ru":"В текущем состоянии игры коды не будут иметь никакого эффекта. Пожалуйста, попробуйте позже","uk":"У поточному стані гри коди не матимуть ніякого ефекту. Будь-ласка спробуйте пізніше","de":"Auf dem aktuellen Spielzustand wird der Code keine Auswirkungen haben. Bitte versuchen Sie es später noch einmal","es":"En el estado actual del juego el código no tendrá ningún efecto. Por favor, inténtelo de nuevo más tarde","fr":"Dans l'état actuel du jeu le code n'aura aucun effet. Veuillez réessayer plus tard"}
			this.allPhrases["TXID_CODEERR_ONLYNUMBERS"] = {"en":"Code must have only numbers and latin letters","ru":"Код должен иметь только цифры и латинские буквы","uk":"Код повинен мати тільки цифри і латинські букви","de":"Code muss nur Zahlen und lateinische Buchstaben haben","es":"Código debe tener sólo números y letras latinas","fr":"Le code doit avoir uniquement des chiffres et des lettres latines"}
			this.allPhrases["TXID_CODEERR_WRONGPLAYER"] = {"en":"This gift is for another player","ru":"Этот подарок для другого игрока","uk":"Цей подарунок для іншого гравця","de":"Dieses Geschenk ist für einen anderen Spieler","es":"Este regalo es para otro jugador","fr":"Ce don est pour un autre joueur"}
			this.allPhrases["TXID_CODEERR_WRONGVERSION"] = {"en":"This code is for newer game version. Please, update the game","ru":"Этот код для новой версии игры. Пожалуйста, обновите игру","uk":"Цей код для нової версії гри. Будь ласка, поновіть гру","de":"Dieser Code ist für neuere Spielversion. Bitte aktualisieren Sie das Spiel","es":"Este código es para la versión más reciente del juego. Por favor, actualice el juego","fr":"Ce code est pour une version plus récente du jeu. S'il vous plaît, mettez à jour le jeu"}
			this.allPhrases["TXID_CODEERR_WRONGWORLD"] = {"en":"This code is for another game world (maybe)","ru":"Этот код для другого игрового мира (возможно)","uk":"Цей код для іншого ігрового світу (можливо)","de":"Dieser Code ist für eine andere Spielwelt (vielleicht)","es":"Este código es para otro mundo del juego (tal vez)","fr":"Ce code est pour un autre monde du jeu (peut-être)"}

			this.allPhrases["TXID_GAMEDESC_20KCOGS"] = {"en":"Underwater exploration"}
			this.allPhrases["TXID_GAMEDESC_BOTTLE"] = {"en":"Most popular flash-mob of 2019"}
			this.allPhrases["TXID_GAMEDESC_CHICKENFARM"] = {"en":"Chicken farm tycoon"}
			this.allPhrases["TXID_GAMEDESC_ENGINEER"] = {"en":"Money making factory"}
			this.allPhrases["TXID_GAMEDESC_IDLEEATERS"] = {"en":"Feed'em all!"}
			this.allPhrases["TXID_GAMEDESC_IDLETOWERBUILDER"] = {"en":"Build the tower to the sky and beyond!","ru":"Постройте башню до неба и выше!","uk":"Побудуйте веду до неба вище!","de":"Bauen Sie den Turm in den Himmel und darüber hinaus!","es":"Construir la torre hacia el cielo y más allá!","fr":"Construire la tour vers le ciel et au-delà!"}
			this.allPhrases["TXID_GAMEDESC_STEAMPUNK"] = {"en":"Incredible machines and steampunk contraptions"}
			this.allPhrases["TXID_GAMEDESC_TRANSMUTATION"] = {"en":"Idle alchemy and world creation"}
			this.allPhrases["TXID_GAMEDESC_TVADS"] = {"en":"Make people watch ads"}
			this.allPhrases["TXID_GAMENAME_20KCOGS"] = {"en":"20 000 Cogs under the sea"}
			this.allPhrases["TXID_GAMENAME_BOTTLE"] = {"en":"Bottle Cap Challenge"}
			this.allPhrases["TXID_GAMENAME_CHICKENFARM"] = {"en":"Eggs factory"}
			this.allPhrases["TXID_GAMENAME_ENGINEER"] = {"en":"Engineer Millionaire"}
			this.allPhrases["TXID_GAMENAME_IDLEEATERS"] = {"en":"Idle Eaters"}
			this.allPhrases["TXID_GAMENAME_IDLETOWERBUILDER"] = {"en":"Idle Tower Builder"}
			this.allPhrases["TXID_GAMENAME_STEAMPUNK"] = {"en":"Steampunk Idle Spinner"}
			this.allPhrases["TXID_GAMENAME_TRANSMUTATION"] = {"en":"Transmutation"}
			this.allPhrases["TXID_GAMENAME_TVADS"] = {"en":"TV Ads factory"}
			this.allPhrases["TXID_GDPR_CAP"] = {"en":"Ready to start!","ru":"Готовы начинать","uk":"Нотові починати","de":"Bereit zum Start!","es":"¡Listo para empezar!","fr":"Prêt à commencer!"}
			this.allPhrases["TXID_GDPR_EXPLANATION"] = {"en":"The game uses the players data (ads cookies and usage statistics) to enhance the gameplay and serve relevant ads to stay free. Please, accept our terms of use and privacy policy (or let your legal guardian agree if you are below the age of consent)","ru":"Игра использует данные игроков (рекламные файлы cookie и статистику использования), чтобы улучшить игровой процесс и показывать релевантную рекламу, чтобы оставаться бесплатной. Пожалуйста, примите наши условия использования и политику конфиденциальности (или пусть ваш законный взрослый представитель примет, если вы моложе возраста согласия)","uk":"У грі використовуються дані гравців (рекламні файли cookie та статистика використання) для покращення ігрового процесу та подання відповідних оголошень, щоб залишатися вільними. Будь ласка, прийміть наші умови використання та політику конфіденційності (або незай ваш аконний дорослий представник прийме, якщо ви не досягли віку згоди)","de":"Das Spiel nutzt die Spieler Daten (Anzeigen Cookies und Nutzungsstatistiken), um das Gameplay zu verbessern und relevante Anzeigen schalten frei zu bleiben. Bitte akzeptieren Sie unsere Nutzungsbedingungen und Datenschutzbestimmungen (oder lassen Sie Ihre Erziehungsberechtigten zustimmen, wenn Sie unter dem Mündigkeitsalter sind)","es":"El juego utiliza los datos de los jugadores (anuncios de galletas y estadísticas de uso) para mejorar la jugabilidad y publicar anuncios relevantes para mantenerse libre. Por favor, acepte nuestras condiciones de uso y política de privacidad (o deje que su tutor legal de acuerdo si está por debajo de la edad de consentimiento)","fr":"Le jeu utilise pour améliorer le gameplay et diffuser des annonces pertinentes pour rester libre les données des joueurs (cookies annonces et statistiques d'utilisation). S'il vous plaît, acceptez nos conditions d'utilisation et politique de confidentialité (ou laissez votre tuteur légal si vous êtes d'accord ci-dessous l'âge du consentement)"}

			this.allPhrases["TXID_LANGSEL"] = {"en":"LANGUAGE SELECTION","ru":"ВЫБОР ЯЗЫКА","uk":"ВИБІР МОВИ","de":"SPRACHAUSWAHL","es":"SELECCIÓN DE IDIOMA","fr":"SÉLECTION DE LA LANGUE"}
			this.allPhrases["TXID_LASTLOADATTEMPT"] = {"en":"Last time there was an error","ru":"В прошлі раз произошла ошибка","uk":"Минулого разу була помилка","de":"Zuletzt ein Fehler aufgetreten","es":"La última vez hubo un error","fr":"La dernière fois qu'il y avait une erreur"}

			this.allPhrases["TXID_MSG_CAP_REWARD_READY"] = {"en":"Gift ready!","ru":"Готов подарок","uk":"Готовий подарунок","de":"Geschenk bereit!","es":"Regalo listo!","fr":"Cadeau prêt!"}
			this.allPhrases["TXID_MSG_EMAILBODY"] = {"en":"(Please, write this email to general@cardswars.com)","ru":"(Пожалуйста, напишите емейл на general@cardswars.com)","uk":"(Будь ласка, напишіть емейл на general@cardswars.com)","de":"(Bitte schreiben Sie diese E-Mail an general@cardswars.com)","es":"(Por favor, escribir este correo electrónico a general@cardswars.com)","fr":"(S'il vous plaît, écrivez ce courriel à general@cardswars.com)"}

			this.allPhrases["TXID_MSG_HOWTOIMPROVE"] = {"en":"Suggestions how to improve the game","ru":"Предложения как улучшить игру","uk":"Пропозиції як покращити гру","de":"Vorschläge, wie das Spiel zu verbessern","es":"Sugerencias de cómo mejorar el juego","fr":"Suggestions comment améliorer le jeu"}

			this.allPhrases["TXID_MSG_REWARD_READY"] = {"en":"You have received an unexpected gift! Check, what it is","ru":"Вы получили неожиданный подарок! Посмотрите, каков он","uk":"Ви отримали несподіваний подарунок! Подивіться, який він","de":"Sie haben ein unerwartetes Geschenk erhalten! Überprüfen Sie, was es ist,","es":"Ha recibido un regalo inesperado! Cheque, lo que es","fr":"Vous avez reçu un cadeau inattendu! Vérifiez, ce qu'il est"}
			this.allPhrases["TXID_MSG_REWRECEIVED"] = {"en":"Reward received","ru":"Награда получена","uk":"Нагороду отримано","de":"Belohnung erhalten","es":"recompensa recibida","fr":"récompense reçue"}

			this.allPhrases["TXID_MSGANS_CONTACT"] = {"en":"CONTACT","ru":"НАПИСАТЬ","uk":"НАПИСАТИ","de":"KONTAKT","es":"CONTACTO","fr":"CONTACT"}
			this.allPhrases["TXID_MSGANS_GETMORE"] = {"en":"GET MORE!","ru":"ПОЛУЧИТЬ БОЛЬШЕ!","uk":"ОТРИМАТИ БІЛЬШ!","de":"MEHR BEKOMMEN!","es":"¡OBTENER MÁS!","fr":"AVOIR PLUS!"}
			this.allPhrases["TXID_MSGANS_LATER"] = {"en":"Later","ru":"Позже","uk":"пізніше","de":"Später","es":"Luego","fr":"Plus tard"}
			this.allPhrases["TXID_MSGANS_NO"] = {"en":"NO","ru":"НЕТ","uk":"НІ","de":"NEIN","es":"NO","fr":"NON"}
			this.allPhrases["TXID_MSGANS_OK"] = {"en":"OK","ru":"ОК","uk":"ОК","de":"OK","es":"OK","fr":"OK"}
			this.allPhrases["TXID_MSGANS_SEND"] = {"en":"Send","ru":"Отправить","uk":"Надіслати","de":"Senden","es":"Enviar","fr":"Envoyer"}
			this.allPhrases["TXID_MSGANS_SUBMIT"] = {"en":"SUBMIT","ru":"ОТПРАВИТЬ","uk":"НАДІСЛАТИ","de":"EINREICHEN","es":"ENVIAR","fr":"SOUMETTRE"}
			this.allPhrases["TXID_MSGANS_WRITE"] = {"en":"Write","ru":"Написать","uk":"написати","de":"Schreiben","es":"Escribir","fr":"Écrire"}
			this.allPhrases["TXID_MSGANS_YES"] = {"en":"YES","ru":"ДА","uk":"ТАК","de":"JA","es":"SI","fr":"OUI"}

			this.allPhrases["TXID_MSGCAP_CREDITSAUTHORS"] = {"en":"Game by Airapport team Oleksii Izvalov & Nadiia Serbina © 2024 All rights reserved","ru":"Игра команды Airapport Алексей Извалов и Надежда Сербина  © 2020 Все права защищены","uk":"Гра команди Airapport Олексій Ізвалов і Надія Сербіна © 2020 Всі права захищені","de":"Ein Spiel von Airapport Team Alexey Izvalov & Nadiia Serbina © 2020 Alle Rechte vorbehalten","es":"Juego por el equipo Airapport Alexey Izvalov y Nadiia Serbina © 2020 Todos los derechos reservados","fr":"Jeu par équipe Airapport Alexey Izvalov & Nadiia Serbina © 2020 Tous droits réservés"}
			this.allPhrases["TXID_MSGCAP_CREDITSMORE"] = {"en":"Musci by Kevin McLeod, incompetech.com","ru":"Звук от пользователей freesound.org: qubodup, samplediaries, deleted-user-7146007, pcwvdmark, lucae, cj-ascoli, inspectorj, robinhood76, spacejoe, hazure","uk":"Звук від користувачів freesound.org: qubodup, samplediaries, deleted-user-7146007, pcwvdmark, lucae, cj-ascoli, inspectorj, robinhood76, spacejoe, hazure","de":"Sound von Freesound.org Benutzern qubodup, samplediaries, gelöscht-user-7146007, pcwvdmark, Lucae, cj-ascoli, inspectorj, robinhood76, spacejoe, zu","es":"Sonido por los usuarios freesound.org qubodup, samplediaries, suprimido-user-7146007, pcwvdmark, Lucae, cj-Ascoli, inspectorj, robinhood76, spacejoe, hazure","fr":"Son par les utilisateurs Freesound.org qubodup, samplediaries, supprimé par l'utilisateur-7146007, pcwvdmark, Lucae, cj-ascoli, inspectorj, robinhood76, spacejoe, hazure"}
			this.allPhrases["TXID_MSGCAP_CREDITSTHANKS"] = {"en":"Created for Global Game Jam 2024 at the Ukrainian location","ru":"Огромная благодарность Andrew Chupryna, Vlad Kovalenko, Dmitrijus Babicius, Dima Kucherenko, Yaroslav Rybachenko за видеообзоры! Большое спасибо Ульяне Андреевой и Дмитрию Новикову за тестирование и предложения!","uk":"Величезна подяка Andrew Chupryna, Vlad Kovalenko, Dmitrijus Babicius, Dima Kucherenko, Yaroslav Rybachenko за відеоогляди! Дуже дякуємо Дмитру Новікову та Ульяні Андреєвій за тестування та пропозиції","de":"Vielen Dank an Andrew Chupryna, Vlad Kovalenko, Dmitrijus Babicius, Dima Kucherenko, Yaroslav Rybachenko für Video-Feedback! Vielen Dank an Ulyana Andreyeva und Dmitry Novikov für Tests und Vorschläge!s","es":"Muchas gracias a Andrew Chupryna, Vlad Kovalenko, Dmitrijus Babicius, Dima Kucherenko, Yaroslav Rybachenko para la retroalimentación de vídeo! ¡Muchas gracias a Ulyana Andreyeva y Dmitry Novikov por las pruebas y sugerencias!","fr":"Un grand merci à Andrew Chupryna, Vlad Kovalenko, Dmitrijus Babicius, Dima Kucherenko, Iaroslav Rybachenko, Dmitry Novikov pour de précieux conseils! Un grand merci à Ulyana Andreyeva et Dmitry Novikov pour tester et suggestions!"}
			this.allPhrases["TXID_MSGCAP_CREDITSTHANKS_MORE"] = {"en":"","ru":"Большое спасибо MoonlightShadowz из ArmorGames за немецкий перевод! Большое спасибо Blokus52 за испанский перевод! Большое спасибо сообществам ArmorGames, r/incremental_games, r/Webgames за ценные предложения!","uk":"Велике спасибі MoonlightShadowz з ArmorGames за німецький переклад! Велике спасибі Blokus52 з ArmorGames за іспанський переклад! Велике спасибі співтовариствам ArmorGames, r / incremental_games, r / Webgames за цінні пропозиції!","de":"Vielen Dank an MoonlightShadowz aus Armorgames für die deutsche Übersetzung! Vielen Dank an Blokus52 aus Armorgames für die spanisch Übersetzung! Vielen Dank an Armorgames, r / incremental_games, r / Webgames Gemeinden für wertvolle Anregungen!","es":"Muchas gracias MoonlightShadowz de ArmorGames para la traducción alemana! Muchas gracias Bokus2 de ArmorGames para la traducción español! Muchas gracias a ArmorGames, r / r /, incremental_games comunidades Webgames por sus valiosas sugerencias!","fr":"De nombreux MoonlightShadowz merci de ArmorGames pour la traduction allemande! Un grand merci Blokus52 de ArmorGames pour la traduction espagnole! Un grand merci aux communautés de Armorgames, r / incremental_games, r / suggestions précieuses pour jeux sur le web!"}
			this.allPhrases["TXID_MSGCAP_ERRORLOADING"] = {"en":"Error while loading file","ru":"Ошибка при загрузке файла","uk":"Помилка при завантаженні файлу","de":"Fehler beim Laden der Datei","es":"Error al cargar archivo","fr":"Erreur lors du chargement du fichier"}
			this.allPhrases["TXID_MSGCAP_MENU"] = {"en":"MENU","ru":"МЕНЮ","uk":"МЕНЮ","de":"MENÜ","es":"MENÚ","fr":"MENU"}

			this.allPhrases["TXID_MSGCAP_YOURECEIVED"] = {"en":"You received","ru":"Вы получили","uk":"Ви отримали","de":"Du erhielst","es":"has recibido","fr":"Tu as reçu"}
			this.allPhrases["TXID_OR"] = {"en":"Or","ru":"Или","uk":"Або","de":"Oder","es":"O","fr":"Ou"}
			this.allPhrases["TXID_PHRASE_ARTIFACTS_BEG"] = {"en":"You have","ru":"У вас есть","uk":"У вас є","de":"Du hast","es":"Tienes","fr":"Tu as"}
			this.allPhrases["TXID_PHRASE_ARTIFACTS_END"] = {"en":"artifacts. Check if you can buy more","ru":"Артефактов. Проверьте, можете ли вы купить ещё","uk":"Артефактів Перевірте, чи можете ви купити ще","de":"Artefakte. Überprüfe, ob du mehr kaufen kannst","es":"artefactos comprueba si puedes comprar más","fr":"artefacts. Vérifiez si vous pouvez acheter plus"}
			this.allPhrases["TXID_PHRASE_OWNED"] = {"en":"Owned","ru":"Имеется","uk":"Маємо","de":"Im Besitz","es":"comprado","fr":"appartenant"}
			this.allPhrases["TXID_PHRASE_RESTARTINFO_NEXT_END"] = {"en":"if you restart after you complete one more floor","ru":"если перезапустите, построив ещё один этаж","uk":"якщо перезапустите, побудувавши ще один поверх","de":"wenn du nach der nächsten Ebene neu startest","es":"si reinicias después de completar un piso más","fr":"si vous redémarrez après avoir terminé un étage de plus"}
			this.allPhrases["TXID_PURCHASEFAILED"] = {"en":"Purchase failed","ru":"При покупке произошла ошибка","uk":"При покупці відбулась помилка","de":"Kauf gescheitert","es":"La compra falló","fr":"Achat raté"}
			this.allPhrases["TXID_PURCHASESRESTORED"] = {"en":"Purchases restored!","ru":"Покупки восстановлены","uk":"Покупки відновлено","de":"Käufe wieder hergestellt!","es":"Las compras restaurados!","fr":"Achats restaurés!"}
			this.allPhrases["TXID_RESTOREFAILED"] = {"en":"Restore failed","ru":"При восстановлении произошла ошибка","uk":"При відномленні відбулась помилка","de":"wiederherstellen fehlgeschlagen","es":"restaurar fallado","fr":"échec de la restauration"}
			this.allPhrases["TXID_RESTOREPURCHASES"] = {"en":"Restore purchases","ru":"Восстановить покупки","uk":"Відновити покупки","de":"wiederherstellen Einkäufe","es":"Restaurar las compras","fr":"restaurer les achats"}
			this.allPhrases["TXID_REW_FREEMON"] = {"en":"Free Coins","ru":"Бесплатные монеты","uk":"Безкоштовні монети","de":"Münzen Gratis","es":"Monedas gratis","fr":"Pièces gratuites"}
			this.allPhrases["TXID_REW_MULTMON"] = {"en":"Money multiplied","ru":"Умножение денег","uk":"Множення грошей","de":"Geld multipliziert","es":"El dinero se multiplica","fr":"L'argent multiplié"}
			this.allPhrases["TXID_REW_TIMEFORWARD"] = {"en":"Time forward","ru":"Время вперед","uk":"час вперед","de":"Zeit vorwärts","es":"tiempo hacia adelante","fr":"avant le temps"}
			this.allPhrases["TXID_SAVEDATA"] = {"en":"Appreciate your help! This is your save data. Please, select it all (long press -> select all), copy (long press -> copy) and send in email to the developer: general@cardswar.com","ru":"Ценю вашу помощь! Это ваши данные сохранения. Пожалуйста, выберите все это (долгое нажатие -> выбрать все), скопируйте (долгое нажатие -> скопировать) и отправьте электронное письмо разработчику: general@cardswar.com","uk":"Ціную вашу допомогу! Це ваші дані збереження. Будь ласка, виберіть все це (довгий гніздо -> вибрати все), скопіюйте (довгий гніздо -> скопіювати) і надішліть листа електронною поштою розробнику: general@cardswar.com","de":"Schätze deine Hilfe! Das ist Ihre Daten speichern. Bitte wählen Sie alles (lang drücken -> alles auswählen), kopiert (lang drücken -> kopieren) und in E-Mail an den Entwickler senden: general@cardswar.com","es":"¡Aprecio tu ayuda! Esta es su guardar datos. Por favor, seleccione todo (pulsación larga -> seleccionar todo), copiar (pulsación larga -> copiar) y enviar correo electrónico al desarrollador: general@cardswar.com","fr":"Apprécier ton aide! Ceci est votre sauvegarde des données. S'il vous plaît, sélectionnez tout (appui long -> Sélectionner tout), copier (appui long -> copier) et envoyer par courrier électronique au développeur: general@cardswar.com"}
			this.allPhrases["TXID_SEND"] = {"en":"Looks like the game crashed last time. You can try loading this save again or send the data to the developer. We will look at it and fix as soon as possible. You can also completely restart the game if you don't want to wait","ru":"Похоже, в прошлый раз игра вылетела. Вы можете попробовать загрузить это сохранение еще раз или отправить данные разработчику. Мы рассмотрим это и исправим как можно скорее. Вы также можете полностью перезапустить игру, если не хотите ждать","uk":"Схоже, останнього разу був збій. Ви можете спробувати завантажити це збереження ще раз або надіслати дані розробнику. Ми розглянемо це і якнайшвидше виправимо. Ви також можете повністю перезапустити гру, якщо не хочете чекати","de":"Sieht aus wie das Spiel abgestürzt beim letzten Mal. Sie können versuchen, diese wieder speichern Laden oder die Daten an den Entwickler senden. Wir werden so schnell wie möglich an ihn und fix aussehen. Sie können auch das Spiel komplett neu starten, wenn Sie wollen nicht warten","es":"Parece que el juego se colgaba la última vez. Usted puede intentar cargar este ahorro de nuevo o enviar los datos al desarrollador. Vamos a mirar y fijar tan pronto como sea posible. También puede reiniciar por completo el juego si no quiere esperar","fr":"On dirait que le jeu se sont écrasés dernière fois. Vous pouvez le charger à nouveau cette sauvegarde ou envoyer les données au développeur. Nous allons examiner et fixer le plus tôt possible. Vous pouvez également redémarrer complètement le jeu si vous ne voulez pas attendre"}
			this.allPhrases["TXID_SENDREPORT"] = {"en":"Send report","ru":"Отправить отчёт","uk":"Відправити звіт","de":"Bericht senden","es":"Enviar reportaje","fr":"Envoyer un rapport"}
			this.allPhrases["TXID_SOMETHINGWRONG"] = {"en":"Something went wrong...","ru":"Что-то пошло не так...","uk":"Щось пішло не так...","de":"Etwas ist schief gelaufen...","es":"Algo salió mal...","fr":"Quelque chose a mal tourné ..."}
			this.allPhrases["TXID_STARTNEW"] = {"en":"Complete reset","ru":"Полный сброс","uk":"Повний зброс гри","de":"Komplett-Reset","es":"reseteo completo","fr":"complète remise à zéro"}
			this.allPhrases["TXID_SUCCESS"] = {"en":"Success!","ru":"Готово!","uk":"Готово!","de":"Erfolg!","es":"¡Éxito!","fr":"Succès!"}
			this.allPhrases["TXID_TIMEUNIT_DAY"] = {"en":"days","ru":"дней","uk":"днів","de":"Tage","es":"dias","fr":"journées"}
			this.allPhrases["TXID_TIMEUNIT_HOUR"] = {"en":"hour","ru":"час","uk":"годину","de":"Stunde","es":"hora","fr":"heure"}
			this.allPhrases["TXID_TIMEUNIT_MIN"] = {"en":"m","ru":"мин","uk":"хв","de":"m","es":"metro","fr":"m"}
			this.allPhrases["TXID_TIMEUNIT_MONTH"] = {"en":"month","ru":"месяц","uk":"місяць","de":"Monat","es":"mes","fr":"mois"}
			this.allPhrases["TXID_TIMEUNIT_MS"] = {"en":"ms","ru":"мс","uk":"мс","de":"Frau","es":"em","fr":"SP"}
			this.allPhrases["TXID_TIMEUNIT_SEC"] = {"en":"s","ru":"сек","uk":"сек","de":"s","es":"s","fr":"s"}
			this.allPhrases["TXID_TIMEUNIT_WEEK"] = {"en":"week","ru":"неделю","uk":"тиждень","de":"Woche","es":"semana","fr":"la semaine"}
			this.allPhrases["TXID_TIMEUNIT_YEAR"] = {"en":"year","ru":"год","uk":"рік","de":"Jahr","es":"año","fr":"an"}
			this.allPhrases["TXID_TRANSLATORTHANKS"] = {"de":"Fielen Dank an MoonlightShadowz aus ArmorGames!","es":"Muchas gracias por la traducción a Roy Clark aka Blokus52 desde ArmorGames","fr":"Auto translated. If you'd like to help and improve it, please, email to general@cardswars.com We appreciate your help!"}
			this.allPhrases["TXID_TRYAGAIN"] = {"en":"Please, try again later","ru":"Попробуйте, пожалуйста, попозже","uk":"Спробуйте, будь ласка, пізніше","de":"Bitte versuchen Sie es später noch einmal","es":"Por favor, inténtelo de nuevo más tarde","fr":"Veuillez réessayer plus tard"}
			this.allPhrases["TXID_TRYLOADAGAIN"] = {"en":"Load save","ru":"Загрузить сейв","uk":"Завантажити сейв","de":"Laden speichern","es":"Cargar guarda","fr":"Chargement de la sauvegarde"}

			this.allPhrases["TXID_CAP_EMPTYSLOT"] = {"en":"EMPTY SLOT","ru":"ПУСТОЙ СЛОТ","uk":"EMPTY SLOT","de":"LEERER SCHLITZ","es":"RANURA VACÍA","fr":"EMPLACEMENT VIDE","pl":"PUSTE MIEJSCE","tr":"BOŞ YUVA","it":"SLOT VUOTO","cs":"PRÁZDNÉ MÍSTO","pt":"slot vazio","ms":"RUANG KOSONG"}
			this.allPhrases["TXID_MSG_SLOTTAKEN"] = {"en":"Slot not empty","ru":"Слот не пустой","uk":"Слот не порожній","de":"Schlitz nicht leer","es":"Ranura no vaciar","fr":"Sous vide ne","pl":"Slot nie opróżnić","tr":"boş değil Yuvası","it":"SLOT non svuotare","cs":"Slot ne vyprázdnit","pt":"Ranhura não esvaziar","ms":"Slot tidak mengosongkan"}
			this.allPhrases["TXID_MSG_WRONGSAVEOPTIONS"] = {"en":"Here is what you can do before restarting the game:","ru":"Вот, что вы можете сделать до перезапуска игры:","uk":"Ось те, що ви можете зробити перед запуском гри:","de":"Hier ist, was Sie vor dem Neustart des Spiels tun können:","es":"Esto es lo que puede hacer antes de reiniciar el juego:","fr":"Voici ce que vous pouvez faire avant de redémarrer le jeu:","pl":"Oto co można zrobić przed ponownym uruchomieniem gry:","tr":"Burada oyun yeniden başlatmadan önce yapabilecekleriniz:","it":"Ecco cosa si può fare prima di riavviare il gioco:","cs":"Zde je to, co můžete udělat před opětovným spuštěním hry:","pt":"Aqui está o que você pode fazer antes de reiniciar o jogo:","ms":"Berikut adalah apa yang anda boleh lakukan sebelum memulakan semula permainan:"}
			this.allPhrases["TXID_CAP_SAVE"] = {"en":"SAVE","ru":"SAVE","uk":"SAVE","de":"SAVE","es":"SAVE","fr":"SAVE","pl":"SAVE","tr":"SAVE","it":"SAVE","cs":"SAVE","pt":"SAVE","ms":"SAVE"}
			this.allPhrases["TXID_MSG_SLOTTAKENCONFIRM"] = {"en":"This slot is already taken. Do you really want to rewrite it?","ru":"Этот слот уже занят. Вы действительно хотите переписать его?","uk":"Цей слот вже зайнятий. Ви дійсно хочете переписати його?","de":"Dieser Slot ist bereits vergeben. Wollen Sie wirklich es neu zu schreiben?","es":"Esta ranura se toma ya. Es lo que realmente quiere volver a escribir?","fr":"Cet emplacement est déjà pris. Voulez-vous vraiment réécrire?","pl":"To gniazdo jest już zajęta. Czy naprawdę chcesz ją przerobić?","tr":"Bu yuva zaten alınmış. Eğer gerçekten yeniden yazmak istiyor musunuz?","it":"Questo slot è già utilizzato. Vuoi davvero a riscriverlo?","cs":"Tento slot je již obsazen. Opravdu chcete, aby ji přepsat?","pt":"Este slot já está tomada. Você realmente quer reescrevê-lo?","ms":"slot ini telah diambil. Adakah anda benar-benar mahu menulis semula?"}
			this.allPhrases["TXID_CAP_SELECTSLOT"] = {"en":"Select slot to save","ru":"Выберите слот для сохранения","uk":"Виберіть слот для збереження","de":"Wählen Sie Slot zu speichern","es":"Seleccionar ranura para guardar","fr":"Sélectionnez emplacement pour sauver","pl":"Wybierz gniazdo, aby zapisać","tr":"kaydetmek için yuva seçin","it":"Selezionare fessura per salvare","cs":"Vyberte slot pro uložení","pt":"Selecione ranhura para salvar","ms":"Pilih slot untuk menyelamatkan"}
			this.allPhrases["TXID_ANS_TRYBACKUP"] = {"en":"Undo","ru":"Отменить","uk":"Скасувати","de":"Rückgängig machen","es":"Deshacer","fr":"annuler","pl":"Cofnij","tr":"Geri alma","it":"Disfare","cs":"vrátit","pt":"Desfazer","ms":"batal"}
			this.allPhrases["TXID_CAP_LOAD"] = {"en":"LOAD","ru":"LOAD","uk":"LOAD","de":"LOAD","es":"LOAD","fr":"LOAD","pl":"LOAD","tr":"LOAD","it":"LOAD","cs":"LOAD","pt":"LOAD","ms":"LOAD"}
			this.allPhrases["TXID_MSG_SORRYSAVE"] = {"en":"Sorry, we were unable to load the save file","ru":"К сожалению, мы не смогли загрузить файл сохранения","uk":"На жаль, ми не змогли завантажити файл сейву","de":"Leider konnte nicht geladen speichern","es":"Lo sentimos, no hemos podido cargar el ahorro","fr":"Désolé, nous ne pouvons pas charger la sauvegarde","pl":"Niestety, nie udało się załadować save","tr":"Maalesef kurtarmak yüklenemedi","it":"Siamo spiacenti, non siamo riusciti a caricare il salvataggio","cs":"Je nám líto, ale nepodařilo se nám načíst save","pt":"Desculpe, não fomos capazes de carregar o save","ms":"Maaf, kami tidak dapat memuatkan jimat"}
			
			this.allPhrases["TXID_CAP_INVITEFRIENDS"] = {"en":"Invite friends","ru":"Пригласите друзей","uk":"Запросіть друзів"}
			this.allPhrases["TXID_CAP_JOINGROUP"] = {"en":"Join the community","ru":"Присоединяйтесь к сообществу","uk":"Приєднайтеся до спільноти"}
			this.allPhrases["TXID_IMPLAYINGGAME"] = {"en":"I'm playing the game","ru":"Я играю в игру","uk":"Я граю у гру"}
			this.allPhrases["TXID_AREYOUWITHME"] = {"en":"Are you with me?","ru":"Ты со мной?","uk":"Ти зі мною?"}
			this.allPhrases["TXID_CAP_MODS"] = {"en":"SELECT MOD","ru":"ВЫБРАТЬ МОД","uk":"ОБРАТИ МОД"}
			this.allPhrases["TXID_CAP_SELECT"] = {"en":"COMMUNITY","ru":"СООБЩЕСТВО","uk":"СПІЛЬНОТА"}
			this.allPhrases["TXID_CAP_NOMOD"] = {"en":"No mods","ru":"Без модов","uk":"Без модів"}
			this.allPhrases["TXID_MSGCAP_MODAUTHOR"] = {"en":"Author of the mod", "ru":"Автор мода", "uk":"Автор моду"}
			
			
			
			this.allPhrases["TXID_MSGCAP_SCREENSHOTOK"] = {"en":"Screenshot submitted!", "ru":"Скриншот отправлен!", "uk":"Скриншот відправлено!"}
			this.allPhrases["TXID_MSG_TEXTAFTERSCREENSHOTOK"] = {"en":"Now the players' community can admire your achievement","ru":"Теперь сообщество игроков может восхищаться вашими достижениями","uk":"Тепер спільнота гравців може захоплюватися вашими досягненями"}
			this.allPhrases["TXID_MSG_SCREENSHOTSUBMITTEDFROM"] = {"en":"Screenshot submitted from", "ru":"Скриншот отправлен от", "uk":"Скриншот відправлено від"}
			this.allPhrases["TXID_MSGANS_COMMUNITY"] = {"en":"Open community", "ru":"Открыть сообщество", "uk":"Відкрити спільноту"}
			this.allPhrases["TXID_MSGANS_CHANGEUSERNAME"] = {"en":"Change username","ru":"Сменить имя пользователя","uk":"Змінити ім'я користувача"}	
			this.allPhrases["TXID_MSGCAP_PLAYERNAMECHANGED"] = {"en":"Username changed", "ru":"Имя пользователя изменено", "uk":"Ім'я користувача змінено"}
			this.allPhrases["TXID_MSG_PLAYERNAME"] = {"en":"Username","ru":"Имя пользователя","uk":"Ім'я користувача"}
			
			

			this.allPhrases["TXID_CAP_SELECTPLAYERNAME"] = {"en":"Select player name","ru":"Выберите имя игрока","uk":"Виберіть ім'я гравця","de":"Wählen Sie Spielernamen","es":"Elija un nombre de jugador","fr":"Sélectionnez le nom du joueur","pl":"Wybierz nazwę gracz","tr":"Seç oyuncu ismi","it":"Selezionare nome del giocatore","cs":"Vyber meno hráča","sk":"Vyber jméno hráče","pt":"Escolha um nome de jogador","ms":"Pilih nama pemain","id":"Pilih nama pemain","vi":"Chọn tên người chơi","ro":"Selectați numele jucătorului"}

			this.allPhrases["TXID_CAP_PENDINGCAP"] = {"en":"Purchase pending","ru":"Покупка обрабатывается","uk":"Покупка обрабатывается"}
			this.allPhrases["TXID_CAP_PENDINGMSG"] = {"en":"Thank you for making purchase! When the transaction completes processing, the purchase will become available","ru":"Благодарим за покупку! Когда завершится обработка транзакции, покупка активируется","uk":"Дякуємо за покупку! Коли завершиться обробка транзакції, покупка активується"}
			this.allPhrases["TXID_CAP_PENDING"] = {"en":"Pending...","ru":"Ожидается...","uk":"Очікується..."}
			
			
			this.allPhrases["TXID_MSGCAP_MADEINUKRAINE"] = {"en":"Made in Ukraine", "ru":"Сделано в Украине", "uk":"Зроблено в Україні", "de":"Made in der Ukraine", "es":"Hecho en Ucrania", "fr":"Fabriqué en Ukraine", "pl":"Wykonane na Ukrainie", "tr":"Ukrayna'da yapılmış", "it":"Realizzato in Ucraina", "cs":"Vyrobeno na Ukrajině", "sk":"Vyrobené na Ukrajine", "pt":"Feito na Ucrânia", "ms":"Dibuat di Ukraine", "id":"Dibuat di Ukraina", "vi":"Được thực hiện ở Ukraine", "ro":"Fabricat în Ucraina", "ca":"Fet a Ucraïna", "hr":"Napravljen u Ukrajini", "da":"Lavet i Ukraine", "nl":"Gemaakt in Oekraïne", "fi":"Valmistettu Ukrainassa", "hu":"Ukrajnában készült", "no":"Laget i Ukraina", "sv":"Gjord i Ukraina"}	
			this.allPhrases["TXID_CAP_EXIT"] = {"en":"QUIT", "ru":"ВЫХОД", "uk":"ВИХІД"}	
			this.allPhrases["TXID_CAP_ASKALLOWPERSADS"] = {"en":"Would you allow showing personalized ads to you?","ru":"Вы позволите показывать вам персонализированную рекламу?","uk":"Ви дозволите показувати вам персоналізовану рекламу?","de":"Würden Sie Ihnen zulassen, personalisierte Anzeigen zu zeigen?","es":"¿Permitirías mostrarte anuncios personalizados?","fr":"Autoriserais-tu des annonces personnalisées?","pl":"Czy pozwoliłbyś na pokazanie spersonalizowanych reklam?","tr":"Kişiselleştirilmiş reklamların size gösterilmesine izin verir misiniz?","it":"Ti permetteresti di mostrarti annunci personalizzati?","cs":"Umožnili byste vám ukázat personalizované reklamy?","sk":"Umožnili by ste vám ukázať personalizované reklamy?","pt":"Você permitiria mostrar anúncios personalizados para você?","ms":"Adakah anda akan membenarkan menunjukkan iklan yang diperibadikan kepada anda?","id":"Apakah Anda mengizinkan menampilkan iklan yang dipersonalisasi kepada Anda?","vi":"Bạn có cho phép hiển thị quảng cáo được cá nhân hóa cho bạn không?","ro":"Ați permite să vă prezentați reclame personalizate?"}
			this.allPhrases["TXID_CAP_ASKALLOWPERSADSEXPL"] = {"en":"This will make ads more relevant and it won't bother you (you can watch it only when you want to receive a reward in the game)","ru":"Это сделает рекламу более релевантной, и она не будет беспокоить вас (вы можете посмотреть ее только тогда, когда захотите получить игровую награду)","uk":"Це зробить рекламу більш релевантною, і вона вас не буде турбувати (ви зможете дивитись її лише тоді, коли захочете отримати винагороду в грі)","de":"Dadurch wird die Anzeigen relevanter und sie werden Sie nicht stören (Sie können sie nur ansehen, wenn Sie eine Belohnung im Spiel erhalten möchten).","es":"Esto hará que los anuncios sean más relevantes y no te molestarán (puedes verlo solo cuando quieras recibir una recompensa en el juego)","fr":"Cela rendra les publicités plus pertinentes et elles ne vous dérangeront pas (vous ne pouvez le regarder que lorsque vous voulez recevoir une récompense dans le jeu)","pl":"To sprawi, że reklamy będą bardziej istotne i nie będą ci przeszkadzać (możesz je oglądać tylko wtedy, gdy chcesz otrzymać nagrodę w grze)","tr":"Bu, reklamları daha alakalı hale getirecek ve sizi rahatsız etmeyecekler (sadece oyunda bir ödül almak istediğinizde izleyebilirsiniz)","it":"Questo renderà gli annunci più rilevanti e non ti darà fastidio (puoi guardarli solo quando vuoi ricevere una ricompensa nel gioco)","cs":"Díky tomu budou reklamy relevantnější a nebudou vás obtěžovat (můžete je sledovat pouze tehdy, když ve hře chcete získat odměnu)","sk":"Vďaka tomu sa reklamy zvýšia a nebudú vás obťažovať (môžete ich sledovať iba vtedy, keď chcete dostať odmenu v hre)","pt":"Isso tornará os anúncios mais relevantes e eles não o incomodarão (você pode assistir apenas quando quiser receber uma recompensa no jogo)","ms":"Ini akan menjadikan iklan lebih relevan dan mereka tidak akan mengganggu anda (anda boleh menontonnya hanya apabila anda ingin menerima ganjaran dalam permainan)","id":"Ini akan membuat iklan lebih relevan dan tidak akan mengganggu Anda (Anda dapat menontonnya hanya jika Anda ingin menerima hadiah dalam permainan)","vi":"Điều này sẽ làm cho quảng cáo phù hợp hơn và họ sẽ không làm phiền bạn (bạn chỉ có thể xem nó khi bạn muốn nhận phần thưởng trong trò chơi)","ro":"Acest lucru va face anunțurile mai relevante și nu vă vor deranja (îl puteți urmări doar atunci când doriți să primiți o recompensă în joc)"}
			

			//закидывем из specialPhrases тоже в allPhrases чтобы потом использовать в игре
			for (var key:String in specialPhrases){
				var ob:Object = specialPhrases[key];
				this.allPhrases[key] = ob;
			}

			allSymbols = westernSymbols + easternSymbols;
			for (var i:int = 0; i < westernSymbols.length; i++){
				westDict[westernSymbols.charAt(i)] = i;
			}
			for (i = 0; i < allSymbols.length; i++){
				allDict[allSymbols.charAt(i)] = i;
			}
			
			//checking what symbols in font are still needed:
			/*
			var additionalLetters2Use:Object={};
			for (var strKey:String in this.allPhrases){
				var rec:Object = this.allPhrases[strKey];
				for (var langKey:String in rec){
					var str:String = rec[langKey];
					
					for (var i:int=0; i<str.length; i++){
						var ch:String = str.charAt(i);
						if (ch!=' '){
							if ((this.westernSymbols.indexOf(ch)==-1)&&(this.notFoundBahasaSymbols.indexOf(ch)==-1)){
								if (langKey in additionalLetters2Use){
									if (additionalLetters2Use[langKey].indexOf(ch)==-1){
										additionalLetters2Use[langKey]+=ch;
									}
								}else{
									additionalLetters2Use[langKey]=ch
								}
							}						
						}
					}
				}
			}
			trace('additonal symbols:')
			for each (str in additionalLetters2Use){
				trace(str)
			}
			*/
			//собираем текущие переводы в таблицу
			/*
			var str:String = ''
			for (var strKey:String in this.allPhrases){
				//trace('strKey=', strKey);
				var rec:Object = this.allPhrases[strKey];
				str+=strKey+"	";
				for (var i:int = 0; i < this.availableLangs.length; i++ ){
					var langKey:String = this.availableLangs[i];
					if (rec.hasOwnProperty(langKey)){
						str+=rec[langKey]
					}
					str+='	'
				}
				str+='\n'
			}
			trace(str)
			*/
			
			//могли брать язык не из заэмбеженных языков, а из дополнительных
			this.lastUsedLangCode = PlayersAccount.account.getParamOfName("lang", "xxxx");
			
			this.initLangCode();
			if (this.lastUsedLangCode == "xxxx"){
				this.lastUsedLangCode = this.langCode;
			}
			manager = new ExternalTranslationsManager();
			manager.loadTranslationsFromDirectory("data/translations/");
		}
		
		private function initLangCode():void 
		{
			this.langCode = PlayersAccount.account.getParamOfName("lang", "xxxx");
			if (this.langCode=="xxxx"){
				var longLangStr:String = Capabilities.language;
				//if (!Main.self.isWebVersion){
				
				if (Capabilities.languages){
					if (Capabilities.languages.length > 0){
						longLangStr = Capabilities.languages[0];
					}
				}					
				
				this.langCode = this.extractLangCodeFromLongLangStr(longLangStr);	
				
				if (this.availableLangs.indexOf(this.langCode)==-1){
					this.langCode = this.availableLangs[0]
				}
			}
			if (this.langCode == "xxxx"){
				this.langCode = this.availableLangs[0];
			}
			
			PlayersAccount.account.setParamOfName("lang", this.langCode);
		}
		
		private function extractLangCodeFromLongLangStr(longLangStr:String):String 
		{
			return longLangStr.substr(0, 2);
		}
		
		
		public function registerText(txt:gui.text.MultilangTextField):void{
			this.updatedTexts.push(txt);
		}
		
		
		public function changeLanguage(lng:String, mustAlwaysUpdate:Boolean = false):void{
			if ((lng!=this.langCode)||mustAlwaysUpdate){
				this.langCode = lng;
				
				for (var i:int=0; i<this.updatedTexts.length; i++){
					this.updatedTexts[i].updateTextTranslation();
				}
				
				PlayersAccount.account.setParamOfName("lang", this.langCode);
			}
		}
		
		public function changeLang2Next():void{
			var id:int = this.availableLangs.indexOf(this.langCode);
			var nextCd:String = this.availableLangs[(id+1)%this.availableLangs.length];
			
			this.changeLanguage(nextCd);
		}
		
		public function getCurrentLanguage():String{
			return langCode;
		}
		
		public function selectPhraseOfLanguage(transOb:Object):String{
			if (transOb.hasOwnProperty(this.langCode)){
				return transOb[this.langCode];
			}else{
				if (transOb.hasOwnProperty('en')){
					return transOb['en'];
				}else{
					return '';
				}
			}
		}
		
		public function getLocalizedVersionOfText(txt:String, specifiedLangCode:String=null):String{
			if (!txt){
				return "";
			}
			if (skipTranslating){
				return txt;
			}
			
			if (!specifiedLangCode){
				specifiedLangCode = this.langCode;
			}
			// console.log('translateText:', txt);
			var id0:int = txt.indexOf('TXID_');
			if (id0 == -1){
				return txt;
			}else{
				//чтобы в одной строке могло быть несколько переводимых констант
				var id1:int = id0+1;//txt.length-1;
				for (id1 = id0 + 5; id1 < txt.length; id1++){
					if (this.lettersInTextCode.indexOf(txt.charAt(id1))==-1){
						break;
					}
				}
				
				//значит, фразу от id0 до id1 включительно, нам надо перевести, а префиксы и постфиксы - оставить
				var prefixStr:String = txt.substring(0, id0);
				var textStr:String = txt.substring(id0, id1);
				var postfixStr:String = txt.substring(id1);
				
				// console.log('prefix:',prefixStr, 'text:',textStr, 'postfix:',postfixStr)
				
				var transOb:Object = this.allPhrases[textStr];
				// console.log(transOb)
				if (transOb){
					if (transOb.hasOwnProperty(specifiedLangCode)){
						textStr = transOb[specifiedLangCode];
					}else{
						if (transOb.hasOwnProperty('en')){
							textStr = transOb['en'];
						}
					}
				}
				return prefixStr+textStr+this.getLocalizedVersionOfText(postfixStr, specifiedLangCode);//рекурсивно переводим остаток строки 
			}
			
		}		
		
		public function getLocalizedVersionOfPhraseWithParams(phraseWithPlaceholders:String, values2Replace:Array, isAlreadyLocalizedParams:Boolean, isPhraseAlreadyTranslated:Boolean=false, specifiedLangCode:String=null):String{
			if (!isPhraseAlreadyTranslated){
				var  res:String = getLocalizedVersionOfText(phraseWithPlaceholders, specifiedLangCode);
			}else{
				res = phraseWithPlaceholders;
			}
			if (!specifiedLangCode){
				specifiedLangCode = this.langCode;
			}
			
			//trace('res:', res);
			for (var i:int = 0; i < values2Replace.length; i++ ){
				if (isAlreadyLocalizedParams){
					var transStr:String = values2Replace[i];
				}else{
					transStr = getLocalizedVersionOfText(values2Replace[i],specifiedLangCode);
				}
				//trace('transStr:', transStr);
				//trace('replacing ', '_' + (i).toString() + '_', ' with ', transStr);
				res = res.replace('_' + (i).toString() + '_', transStr);
				//trace('res:', res);
			}
			return res;
		}
		
		public function unregisterText(tf:gui.text.MultilangTextField):void 
		{
			var id:int = this.updatedTexts.indexOf(tf);
			if (id !=-1){
				this.updatedTexts.splice(id, 1);
			}			
		}
		
		public function unregisterAllTexts():void 
		{
			this.updatedTexts.length = 0;
		}
		
		public function getLocalizedVersionOfTextFromObjectWithTranslations(transOb:Object, defaultVar:String):String 
		{
			var res:String = defaultVar;
			if (transOb.hasOwnProperty(this.langCode)){
				res = transOb[this.langCode];
			}else{
				if (transOb.hasOwnProperty('en')){
					res = transOb['en'];
				}
			}
			return res;
		}
		
		public function addExternatTranslationFromJSON(scnOb:Object):void 
		{
			if (scnOb.hasOwnProperty("lang_code")&&scnOb.hasOwnProperty("lang_selfname")&&scnOb.hasOwnProperty("phrases")){
				var lang_code:String = scnOb["lang_code"];
				if (availableLangs.indexOf(lang_code) ==-1){
					availableLangs.push(lang_code);
				}
				langNames[lang_code] = scnOb["lang_selfname"];
				
				if (scnOb.hasOwnProperty("lang_translator")){
					langTranslatorsNames[lang_code] = scnOb["lang_translator"]
				}else{
					langTranslatorsNames[lang_code] = "";
				}
				if (scnOb.hasOwnProperty("lang_translator_website")){
					langTranslatorsSites[lang_code] = scnOb["lang_translator_website"]
				}else{
					langTranslatorsSites[lang_code] = "";
				}
				if (scnOb.hasOwnProperty("lang_translation_comment")){
					langTranslationsComments[lang_code] = scnOb["lang_translation_comment"]
				}else{
					langTranslationsComments[lang_code] = "";
				}

				
				var phrases:Object = scnOb["phrases"];
				recursivelyInitPhrasesFromOb(phrases, lang_code)
				
				if (lang_code == lastUsedLangCode){
					this.changeLanguage(lang_code, true);
				}
			}
			/*
			{
				"lang_code":"en",
				"lang_selfname":"English",
				"lang_translator":"Alex",
				"lang_translator_website":"www.airapport.com",
				"phrases":{
					"TXID_CAP_START":"BEGIN!",
					"TXID_CAP_CREDITS":"BEGIN!",
				
				}
			
			
			
			
			}
			*/
		}
		
		private function recursivelyInitPhrasesFromOb(phrases:Object, lang_code:String):void 
		{
			for (var key:String in phrases){
				var str:* = phrases[key];
				if (str is String){
					if (key in this.allPhrases){
						
					}else{
						this.allPhrases[key] = {};
					}
					this.allPhrases[key][lang_code] = phrases[key];	
				}else{
					recursivelyInitPhrasesFromOb(str, lang_code);
				}
			}			
		}
		
		public function doOnAllTranslationsLoaded():void 
		{
				
		}
		
		
		public function reloadOuterTranslations():void{
			this.lastUsedLangCode = PlayersAccount.account.getParamOfName("lang", "xxxx");
			if (this.lastUsedLangCode == "xxxx"){
				this.lastUsedLangCode = this.langCode;
			}
			manager.loadTranslationsFromDirectory("data/translations/");
		}
		
		public function toggleTranslationSkip():void{
			skipTranslating = !skipTranslating;
			this.changeLanguage(langCode, true);
		}
		
	}
}