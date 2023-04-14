//
//  SettingsViewModel.swift
//  FuelTracker
//
//

import Foundation
import SwiftUI

 enum FuelType {
    case combustion
    case electric
 }

class SettingsViewModel: ObservableObject{
    
    @Published var theme: ColorScheme? = nil
    @Published var appThemeColor: Color = Color.appTheme
    @Published var fuelType: FuelType = .combustion
    
    @Published var shouldShowLocalNotification: Bool = AppUserDefaults.shouldshowLocalNotification
    
    @Published var isPremium = AppUserDefaults.isPremiumUser
    
    @Published var title = ""
    @Published var message = ""
    @Published var defaultButtonTitle = "OK"
    @Published var showAlert = false
    
    init(){
        theme = getTheme()
    }
    
    func getTheme() -> ColorScheme? {
        let theme = AppUserDefaults.preferredTheme
        var _theme: ColorScheme? = nil
        if theme == 0 {
            _theme = nil
        }else if theme == 1 {
            _theme = ColorScheme.light
        }else {
            _theme = ColorScheme.dark
        }
        return _theme
    }
    
    func changeAppTheme(theme: Int){
        AppUserDefaults.preferredTheme = theme
        self.theme = getTheme()
    }
    
    func changeAppColor(color: Color){
        let hex = color.uiColor().toHexString()
        if hex.count == 7 {
            AppUserDefaults.appThemeColor = hex
        }
        appThemeColor = Color.appTheme
        
    }
    
    func changeFuelType(fuelType: Int){
        AppUserDefaults.preferredFuelType = fuelType
        if fuelType == 0 {
            self.fuelType = .combustion
        }else if fuelType == 1 {
            self.fuelType = .electric
        }else{
            self.fuelType = .combustion
        }
    }
    
    func setPremiumUser(paymentId: String){
        isPremium = true
        AppUserDefaults.paymentId = paymentId
        AppUserDefaults.isPremiumUser = true
    }
    
    func showAlert(title: String = "", message: String = ""){
        self.title = title
        self.message = message
        self.showAlert = true
    }
    

}

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
