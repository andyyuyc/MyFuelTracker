//
//  FuelTrackerApp.swift
//  FuelTracker
//
//

import SwiftUI

@main
struct FuelTrackerApp: App {
    
    let persistenceController = PersistenceController.shared
    @StateObject var fuelViewModel = FuelViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var paymentViewModel = PaymentViewModel()
    @StateObject var pageTypeViewModel = PageTypeViewModel()
    
    init(){
        
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleFont = UIFont(
            descriptor:
                titleFont.fontDescriptor
                .withDesign(.rounded)?
                .withSymbolicTraits(.traitBold)
            ??
            titleFont.fontDescriptor
            , size: titleFont.pointSize)
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
        
        
        UITableView.appearance().showsVerticalScrollIndicator = false
        
        
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(settingsViewModel.getTheme())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(fuelViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(paymentViewModel)
                .environmentObject(pageTypeViewModel)
        }
    }
}
