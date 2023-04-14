//
//  WelcomeView.swift
//  FuelTracker
//
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var pageViewModel: PageTypeViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
            Text("Track fuel costs")
            Text("MyFuelTracker provides an easy way to log your car's fuel expenses. Track fuel costs.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
                .padding(.top)
            Spacer()
            
            VStack(spacing: 24) {
                FeatureCell(image: "circle.lefthalf.filled", title: "Dark/Light", subtitle: "Dark/Light Mode", color: Color.appTheme)
                
                FeatureCell(image: "chart.xyaxis.line", title: "Stats", subtitle: "Last 12 weeks statics", color: Color.appTheme)
                
                FeatureCell(image: "cloud", title: "Sync", subtitle: "Save your expenses with iCloud", color: Color.appTheme)
            }
            .padding(.leading)
            
            Spacer()
            Spacer()
            
            Button(action: {
                pageViewModel.onClickContinue()
            }) {
                HStack {
                    Spacer()
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(15)
        }
        .padding()
    }
}

struct FeatureCell: View {
    var image: String
    var title: String
    var subtitle: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .foregroundColor(color)
                    
            VStack(alignment: .leading, spacing: 2) {
                Text(LocalizedStringKey(title))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(LocalizedStringKey(subtitle))
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
}


struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(PageTypeViewModel())
            .environmentObject(SettingsViewModel())
    }
}


