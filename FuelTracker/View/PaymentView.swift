//
//  PaymentView.swift
//  FuelTracker
//
//

import SwiftUI

struct PaymentView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack{
            Color.appTheme.opacity(0.2).edgesIgnoringSafeArea(.all)
            if #available(iOS 15.0, *){
                PaymentContent.init {
                    close()
                }.interactiveDismissDisabled()
            }else{
                PaymentContent.init{
                    close()
                }
            }
        }
    }
    
    func close(){
        presentationMode.wrappedValue.dismiss()
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView().environmentObject(PaymentViewModel())
            .environmentObject(SettingsViewModel())
    }
}

