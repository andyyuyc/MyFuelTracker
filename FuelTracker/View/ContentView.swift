//
//  ContentView.swift
//  FuelTracker
//
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var pageViewModel: PageTypeViewModel
    
    var body: some View {
        switch(pageViewModel.pageType){
        case .welcome:
            WelcomeView()
        case PageType.splash:
            SplashView()
        case PageType.home:
            TabBarView()
        }
    }
}
