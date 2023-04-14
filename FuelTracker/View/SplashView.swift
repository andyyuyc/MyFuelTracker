//
//  SplashView.swift
//  FuelTracker
//
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var pageViewModel: PageTypeViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                
                Text("MyFuelTrack")
                    .font(.some(Font.system(.title2,design: .rounded)))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.primary)
                
                
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    pageViewModel.goTabScreen()
                }
            }
        }
        
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}


