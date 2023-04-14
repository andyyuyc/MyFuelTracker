//
//  TabBarView.swift
//  FuelTracker
//
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(settingsViewModel.fuelType == .electric ? "Charge Stops" : "Fuel Stops", systemImage: "fuelpump")
                }

            ActivityHistoryView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.xyaxis.line")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(Color.appTheme)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
