//
//  AppConfig.swift
//  FuelTracker
//
//

import Foundation
import GoogleMobileAds
class AppConfig{
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    /// Test Interstitial ID: ca-app-pub-3940256099942544/1033173712
    static let adMobAdID: String = "ca-app-pub-3599533629737647/4756657521"
    
    /// Turn this `true` to hide the ads if necessary during testing
    static let shouldHideAds: Bool = false
    
    static var MONTHLY_PRODUCT_ID = "fuel.tracker.monthly.productId"
    static var SIX_MONTH_PRODUCT_ID = "fuel.tracker.six.months.productId"
    static var YEARLY_PRODUCT_ID = "fuel.tracker.yearly.productId"

    static var TITLE = "Upgrade to Pro"
    static var SUBTITLE = "Get access to all our features"
    static var FEATURES: [String]  = ["Unlimited Fuel Stops", "Remove Ads"]


    static var PRIVACY_POLICIY_URL = "https://www.apple.com"
    static var TERMS_AND_CONDITIONS_URL = "https://www.apple.com/"

    static var DISCLIMER_TEXT = "Upon clicking on \"Continue\", payment will be charged to your iTunes account at confirmation of purchase and will automatically renew (at the duration/price selected) unless auto-renew is turned off at least 24 hrs before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period. Current subscription may not be cancelled during the active subscription period; however, you can manage your subscription and/or turn off auto-renewal by visiting your iTunes Account Settings after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable."


}

class Interstitial: NSObject, GADFullScreenContentDelegate {
        private var interstitial: GADInterstitialAd?
        private var retryCount: Int = 0
        private let shouldRetryNumberOfTimes: Int = 3
    
        /// Default initializer of interstitial class
        override init() {
            super.init()
//            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
            loadInterstitial()
        }
    
        /// Request AdMob Interstitial ads
        func loadInterstitial() {
            GADInterstitialAd.load(withAdUnitID: AppConfig.adMobAdID, request: GADRequest()) { (ad, _) in
                self.interstitial = ad
                self.interstitial?.fullScreenContentDelegate = self
//                self.showInterstitialAds()
            }
        }
    
        func showInterstitialAds() {
//            AppUserDefaults.counter += 1
//            print(AppUserDefaults.counter)
//            if AppUserDefaults.counter % 3 != 0 {
//                return
//            }
            if !AppUserDefaults.isPremiumUser {
                if let root = UIApplication.shared.windows.first?.rootViewController, !AppConfig.shouldHideAds {
                    interstitial?.present(fromRootViewController: root)
                    loadInterstitial()
                }
            }
        }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will dismiss full screen content.")
    }
}
