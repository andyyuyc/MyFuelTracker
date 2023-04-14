//
//  AppUserDefaults.swift
//  FuelTracker
//
//

import Foundation
struct AppUserDefaults{
    
    @UserDefault("appThemeColor", defaultValue: "")
    static var appThemeColor: String
    
    @UserDefault("preferredTheme", defaultValue: 0)
    static var preferredTheme: Int
    
    @UserDefault("shouldshowLocalNotification", defaultValue: false)
    static var shouldshowLocalNotification: Bool
    
    @UserDefault("isOnboarding", defaultValue: true)
    static var isOnboarding: Bool
    
    @UserDefault("reminderDate", defaultValue: 0.0)
    static var reminderDate: Double
    
    @UserDefault("shouldShowInitScreen", defaultValue: true)
    static var shouldShowInitScreen: Bool
    
    @UserDefault("shouldShowWelcomeScreen", defaultValue: true)
    static var shouldShowWelcomeScreen: Bool
    
    @UserDefault("paymentId", defaultValue: "")
    static var paymentId: String
    
    @UserDefault("isPremiumUser", defaultValue: false)
    static var isPremiumUser: Bool
    
    @UserDefault("shouldShowPaymentScreen", defaultValue: true)
    static var shouldShowPaymentScreen: Bool
    
    @UserDefault("counter", defaultValue: 0)
    static var counter: Int
    
    @UserDefault("preferredFuelType", defaultValue: 0)
    static var preferredFuelType: Int
}



