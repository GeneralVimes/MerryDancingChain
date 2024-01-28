package  
{
	import globals.StatsWrapper;
	/**
	 * ...
	 * @author General
	 */
	public class EnhanceWrapper 
	{
		public function EnhanceWrapper() 
		{
			
		}
		public static function init (paramsOb:Object=null) : void{
				
		}		
		public static function showInitialPopupIfNeeded():void{
				
		}
		public static function isInterstitialReady (placement:String = "DEFAULT") : Boolean{
				return false;
		}
		
		public static function isRewardedAdReady(placement:String="NEUTRAL") : Boolean{
			return false;
		}
		
		public static function logEvent (eventType:String, paramKey:String=null, paramValue:String=null) : void{
			
		}
		public static function showInterstitialAd (placement:String="DEFAULT") : void{
			StatsWrapper.stats.logText("InterstitialView");
		}
		public static function showRewardedAd (onGranted:Function, onDeclined:Function, onUnavailable:Function, placement:String="NEUTRAL") : void{
			StatsWrapper.stats.logText("RewardedView");
		}
		
		public static function serviceTermsOptIn(requestedSdks:Array = null):void{

		}
		public static function serviceTermsOptOut():void{

		}
		
		public static function enableLocalNotification(    
														title:String,
														message:String,
														delay:int):void{

		}
		
		public static function disableLocalNotification():void{

		}
				
		public static function requestLocalNotificationPermission(    
												onPermissionGrantedCallback:Function,
												onPermissionRefusedCallback:Function):void{
		}
		
		public static function requiresDataConsentOptIn(onRequired:Function,onNotRequired:Function):void{

		}
		
		
		public static function isPurchasesSupported():Boolean{
			return false;
		}
		
		public static function attemptPurchase(product_name:String, onPurchaseSuccess:Function, onPurchaseFailed:Function, onPurchasePending:Function):void{

		}
		public static function consumePurchase(product_name:String, onConsumeSuccess:Function, onConsumeFailed:Function):void{

		}
		public static function isItemOwned(product_name:String):Boolean{
			return false;
		}
		public static function getOwnedItemCount(product_name:String):int{
			return 0
		}
		public static function isProductStatusPending(product_name:String):Boolean{
			return false
		}		
		public static function getDisplayTitle(product_name:String, default_title:String):String{
			return default_title
		}
		public static function getDisplayDescription(product_name:String, default_description:String):String{
			return default_description
		}
		public static function getDisplayPrice(product_name:String, default_price:String):String{
			return default_price
		}
		public static function manuallyRestorePurchases(onRestoreSuccess:Function, onRestoreFailed:Function):void{
			
		}
	}

}