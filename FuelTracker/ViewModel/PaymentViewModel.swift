//
//  PaymentViewModel.swift
//  FuelTracker
//
//

import Foundation
import StoreKit
import SwiftyStoreKit

class PaymentViewModel: ObservableObject{
    @Published var isLoadingRetrieveProducts = false
    
    @Published var isLoadingPayment = false
    
    @Published var showAlert = false
    @Published var title: String = ""
    @Published var payments = [Payment]()
    
    init(){
        initConfiguration()
        payments.append(Payment(paymentId: PaymentId.monthly, title: "", index: 0, price: "", discount: "", extraInfo: "", unit: "3", duration: "month"))
        payments.append(Payment(paymentId: PaymentId.yearly, title: "", index: 1, price: "", discount: "", extraInfo: "", unit: "1", duration: "year"))
        payments.append(Payment(paymentId: PaymentId.sixMonths, title: "", index: 2, price: "", discount: "", extraInfo: "", unit: "6", duration: "month"))
    }
    
    func initConfiguration(){
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default: break
                    
                }
            }
        }
    }
    
    func retrieveProducts(){
        isLoadingRetrieveProducts = true
        SwiftyStoreKit.retrieveProductsInfo([PaymentId.monthly,PaymentId.yearly,PaymentId.sixMonths]) { result in
            self.isLoadingRetrieveProducts = false
            result.retrievedProducts.forEach { skProduct in
                
                switch(skProduct.productIdentifier){
                case PaymentId.monthly:
                    self.payments[0].price = skProduct.localizedPrice ?? "\(skProduct.price)"
                    self.payments[0].isTrialAvailable = skProduct.introductoryPrice != nil
                    self.payments[0].trialPrice =  skProduct.introductoryPrice() ?? "Not Available"
                    break;
                case PaymentId.yearly:
                    self.payments[1].price = skProduct.localizedPrice ?? "\(skProduct.price)"
                    let monthlyPrice = String(format: "%.1f",Float(skProduct.price) / 12)
                    let currency = skProduct.priceLocale.currencySymbol ?? ""
                    self.payments[1].discount = "\(currency)\(monthlyPrice) / \("_mo".localized) "
                    self.payments[1].isTrialAvailable = skProduct.introductoryPrice != nil
                    self.payments[1].trialPrice =  skProduct.introductoryPrice() ?? "Not Available"
                    break;
                case PaymentId.sixMonths:
                    self.payments[2].price = skProduct.localizedPrice ?? "\(skProduct.price)"
                    self.payments[2].isTrialAvailable = skProduct.introductoryPrice != nil
                    self.payments[2].trialPrice =  skProduct.introductoryPrice() ?? "Not Available"
                    break;
                default:
                    debugPrint("PaymentViewModel default")
                    break;
                }
            }
        }
        
    }
    
    func startPayment(with paymentId: String, completion: @escaping (PaymentResult) -> Void){
        isLoadingPayment = true
        SwiftyStoreKit.purchaseProduct(paymentId, quantity: 1, atomically: true) { result in
            debugPrint("PaymentManager startPayment => \(paymentId)")
            switch result {
            case .success(let purchase):
                debugPrint("PaymentManager success => \(purchase.productId)")
                completion(PaymentResult(success: true,error: nil))
            case .error(let error):
                if let _error = PaymentErrorHandler.map(from: error){
                    debugPrint("PaymentManager error => \(_error)")
                    completion(PaymentResult(success: false,error: _error))
                }else {
                    completion(PaymentResult(success: false,error: nil))
                }
            case .deferred(purchase: let purchase):
                debugPrint("PaymentManager deferred => \(purchase.productId)")
                completion(PaymentResult(success: false,error: nil))
            }
            self.isLoadingPayment = false
            
        }
    }
    
    private func showAlert(title: String){
        self.title = title
        self.showAlert = true
    }
    
    func restorePurchases(completion: @escaping (PaymentResult) -> Void){
        debugPrint("PaymentManager restorePurchases")
        isLoadingPayment = true
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            debugPrint("PaymentManager restorePurchases results => \(results)")
            if results.restoreFailedPurchases.count > 0 {
                self.showAlert(title: "No restored purchase")
                completion(PaymentResult(success: false,error: nil))
            }
            else if results.restoredPurchases.count > 0 {
                if let purchase =  results.restoredPurchases.first{
                    self.startPayment(with: purchase.productId, completion: completion)
                }
            }
            else {
                self.showAlert(title: "No restored purchase")
                completion(PaymentResult(success: false,error: nil))
            }
            self.isLoadingPayment = false
        }
    }
    
}

struct PaymentResult{
    var success: Bool
    var error:String?
}



struct PaymentErrorHandler{
    static func map(from error: SKError) -> String? {
        var errorDescription : String? = nil
        switch error.code {
        case .unknown:
            errorDescription = "Unknown error. Please contact support"
        case .clientInvalid:
            errorDescription = "Not allowed to make the payment"
        case .paymentCancelled:
            errorDescription = "Payment cancelled"
        case .paymentInvalid:
            errorDescription = "The purchase identifier was invalid"
        case .paymentNotAllowed:
            errorDescription = "The device is not allowed to make the payment"
        case .storeProductNotAvailable:
            errorDescription = "The product is not available in the current storefront"
        case .cloudServicePermissionDenied:
            errorDescription = "Access to cloud service information is not allowed"
        case .cloudServiceNetworkConnectionFailed:
            errorDescription = "Could not connect to the network"
        case .cloudServiceRevoked:
            errorDescription = "User has revoked permission to use this cloud service"
        default:
            errorDescription = (error as NSError).localizedDescription
        }
        return errorDescription
    }
}


extension String{
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
}

