//
//  PaymentContent.swift
//  FuelTracker
//
//

import Foundation
import SwiftUI



enum PaymentInfo{
    case monthly
    case yearly
    case lifetime
}

struct PaymentContent: View {
    var closePayment: () -> ()
    @EnvironmentObject var paymentViewModel: PaymentViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    
    var title: String = AppConfig.TITLE
    var subtitle: String = AppConfig.SUBTITLE
    var features: [String] = AppConfig.FEATURES
    var sixMonthsProductId: String = AppConfig.SIX_MONTH_PRODUCT_ID
    var oneYearProductId: String = AppConfig.YEARLY_PRODUCT_ID
    var threeMonthsProductId: String = AppConfig.MONTHLY_PRODUCT_ID
    private let privacyPolicyURL: URL = URL(string: AppConfig.PRIVACY_POLICIY_URL)!
    private let termsAndConditionsURL: URL = URL(string: AppConfig.TERMS_AND_CONDITIONS_URL)!
    
    @State private var isDisabled = false
    @State private var selectedProductId: String = ""
    @State private var selectedPayment: Payment?
    
    private func vibrate(){
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    var body: some View{
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                HeaderSectionView
                ProductsListView
                RestorePurchases
                PrivacyPolicyTermsSection
                DisclaimerTextView
            }.edgesIgnoringSafeArea(.bottom)
            
            CloseButtonView
        }
        .onAppear{
            paymentViewModel.retrieveProducts()
        }
    }
    
    
    private var HeaderSectionView: some View {
        VStack {
            
            Image(systemName: "crown.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.appTheme)
                .padding(.top, 50)
            
            VStack {
                Text(title)
                    .font(.some(Font.system(.largeTitle,design: .rounded))).bold().multilineTextAlignment(.center)
                Text(subtitle).font(.some(Font.system(.headline,design: .rounded))).fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
            }.padding(.leading, 20).padding(.trailing, 20).padding(.bottom, 20)
            ForEach(0..<features.count) { index in
                HStack {
                    Image(systemName: "checkmark.circle.fill").resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.appTheme)
                    Text(self.features[index])
                        .font(.system(size: 22, design: .rounded))
                    Spacer()
                }
            }.padding(.leading, 30).padding(.trailing, 30)
        }
    }
    
    private var ProductsListView: some View {
        VStack {
            VStack(spacing: 10) {
//                Divider()
                Text("CHOOSE YOUR PLAN")
                    .font(.some(Font.system(size: 22, design: .rounded)))
                    .bold()
                HStack(alignment: .bottom, spacing: 10) {
                    productButton(id: self.sixMonthsProductId)
                    productButton(id: self.oneYearProductId)
                    productButton(id: self.threeMonthsProductId)
                }
                (Text("Trial period: ") + Text(self.selectedPayment?.trialPrice ?? "Not Available").bold()).padding(.top, 20)
                Button(action: {
                    if !paymentViewModel.isLoadingPayment{
                        self.vibrate()
                        
                        if let payment = self.paymentViewModel.payments.filter( {$0.paymentId == self.selectedProductId}).first {
                            self.paymentViewModel.startPayment(with: payment.paymentId){ result in
                                if result.success{
                                    settingsViewModel.setPremiumUser(paymentId: payment.paymentId)
                                    closePayment()
                                }
                                
                                
                            }
                        }
                        
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28.5)
                            .frame(height: 57).foregroundColor(self.selectedProductId.isEmpty || self.isDisabled ? . secondary : Color.appTheme)
                        VStack {
                            Text("Continue").font(.system(size: 21, design: .rounded)).foregroundColor(.white).bold()
                        }
                    }
                }).padding(.top, 20).disabled(self.selectedProductId.isEmpty || self.isDisabled)
            }.padding(.leading, 20).padding(.trailing, 20)
            
        }.padding(.top, 20).padding(.bottom, 20)
    }
    

    
    private var CloseButtonView: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    closePayment()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable().accentColor(Color.appTheme).frame(width: 32, height: 32)
                }).disabled(paymentViewModel.isLoadingPayment)
            }
            Spacer()
        }.padding(20).edgesIgnoringSafeArea(.top)
    }
    
    private var RestorePurchases: some View {
        Button(action: {
            paymentViewModel.restorePurchases{ result in
                if result.success{
                    settingsViewModel.setPremiumUser(paymentId: "Restore purchase")
                    closePayment()
                }
            }

        }, label: {
            Text("Restore Purchases").foregroundColor(.primary)
        })
    }
    
    private var PrivacyPolicyTermsSection: some View {
        HStack(spacing: 20) {
            Button(action: {
                UIApplication.shared.open(privacyPolicyURL, options: [:], completionHandler: nil)
            }, label: {
                Text("Privacy Policy")
            })
            Button(action: {
                UIApplication.shared.open(termsAndConditionsURL, options: [:], completionHandler: nil)
            }, label: {
                Text("Terms of Use")
            })
        }.font(.system(size: 10)).foregroundColor(.gray).padding()
    }
    
    private var DisclaimerTextView: some View {
        VStack {
            Text(AppConfig.DISCLIMER_TEXT).font(.system(size: 12))
                .multilineTextAlignment(.center)
                .padding(.leading, 30).padding(.trailing, 30)
            Spacer(minLength: 50)
        }
    }
    
    private func productButton(id: String) -> some View {
        Button(action: {
            self.selectedProductId = id
            if let product = paymentViewModel.payments.filter( {$0.paymentId == id}).first {
                self.selectedPayment = product
            }
                self.vibrate()
        }, label: {
            VStack {
                /// Show the best value text for 1 year product
                if id == self.oneYearProductId {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).foregroundColor(Color.appTheme).frame(height: 30)
                        Text("Popular").foregroundColor(.white).layoutPriority(1).padding(10)
                    }
                }
                /// Show the product period, duration, price
                ZStack {
                    RoundedRectangle(cornerRadius: 20).frame(height: 130)
                        .foregroundColor(self.selectedProductId == id ? .white : .secondary).opacity(0.3)
                    if self.selectedProductId == id {
                        RoundedRectangle(cornerRadius: 20).stroke(Color.appTheme, lineWidth: 4).frame(height: 130)
                    }
                    VStack {
                        if let product = paymentViewModel.payments.filter( {$0.paymentId == id}).first {
                            Text(product.unit).font(.system(.largeTitle, design: .rounded)).foregroundColor(.primary).bold()
                            Text(product.duration).font(.system(size: 20, design: .rounded)).foregroundColor(.primary).bold()
                            Text(product.price).font(.system(size: 15, design: .rounded)).foregroundColor(.primary)
                        }
                        
                    }.opacity(self.selectedProductId == id ? 1.0 : 0.3)
                }
            }
        })
    }
}
