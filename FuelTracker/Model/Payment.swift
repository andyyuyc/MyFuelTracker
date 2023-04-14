//
//  Payment.swift
//  FuelTracker
//
//

import Foundation
import SwiftUI


struct Payment: Identifiable{
    let id = UUID()
    let paymentId: String
    var title: String
    var index: Int
    var price: String
    var discount: String
    var extraInfo: String
    var unit: String
    var duration: String
    var isTrialAvailable = false
    var trialPrice = ""
    
    init(paymentId: String, title: String, index: Int, price: String, discount: String, extraInfo: String, unit: String, duration: String){
        self.paymentId = paymentId
        self.title = title
        self.index = index
        self.price = price
        self.discount = discount
        self.extraInfo = extraInfo
        self.unit = unit
        self.duration = duration
    }
}
