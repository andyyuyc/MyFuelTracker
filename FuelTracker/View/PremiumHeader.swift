//
//  PremiumHeader.swift
//  FuelTracker
//
//

import SwiftUI

struct PremiumHeader: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("Upgrade to Premium")
                Text("Fuel Expense Tracker Pro").bold()
            }
            Spacer()
            
            Image(systemName: "crown.fill")
                .font(.title)
            
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.appTheme)
//        .background(LinearGradient(colors: [Color.purple, Color.orange], startPoint: .leading, endPoint: .trailing))
    }
}

struct PremiumHeader_Previews: PreviewProvider {
    static var previews: some View {
        PremiumHeader()
    }
}


