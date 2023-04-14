//
//  PaymentId.swift
//  FuelTracker
//
//

import Foundation

class PaymentId{
    static let shared = PaymentId()
    
    static let monthly = AppConfig.MONTHLY_PRODUCT_ID
    static let yearly = AppConfig.YEARLY_PRODUCT_ID
    static let sixMonths = AppConfig.SIX_MONTH_PRODUCT_ID
    
    private init() {}
}
