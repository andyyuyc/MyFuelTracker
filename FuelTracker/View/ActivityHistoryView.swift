//
//  ActivityHistoryView.swift
//  FuelTracker
//
//  Created by Pavli Studio on 20.05.2022//

import Foundation
import SwiftUI

struct ActivityHistoryView: View {
    
    @FetchRequest(entity: Fuel.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Fuel.date, ascending: true)], predicate: nil, animation: .easeInOut) var fuels: FetchedResults<Fuel>
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State var selectedIndex: Int = 11
    @State var logs = [ActivityLog]()
    private let adMobAd = Interstitial()
    
    var body: some View {
        NavigationView{
            List{
                
                Section(footer: Text("Needs min. 2 fuel stops")){
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "drop.circle")
                                    .foregroundColor(.appTheme)
                                Text(String(format: "%.2f", calculateAverageConsumption()))
                                    .foregroundColor(.primary)
                                Text(settingsViewModel.fuelType == .electric ? "kWh/100 km" : "L/100 km")
                                    .foregroundColor(.secondary)
                            }
                            Text("Avg. Consumption")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical)
                    }
                
                Section(footer: Text("Needs min. 1 fuel stop")){
                    VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "arrow.triangle.swap")
                                    .foregroundColor(.appTheme)
                                Text(String(format: "%ld", locale: Locale.current, lastOdometer()))
                                    .foregroundColor(.primary)
                                Text("km")
                                    .foregroundColor(.secondary)
                            }
                            Text("Odometer")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical)
                    }
                
                Section{
                    VStack(spacing: 16) {
                        // Stats
                        ActivityHistoryText(logs: logs, selectedIndex: $selectedIndex)
                            .padding(.top)
                        
                        // Graph
                        ActivityGraph(logs: logs, selectedIndex: $selectedIndex)
                        Spacer()
                        
                    }
                }
                
                
            }
            .navigationTitle("Statistics")
        }
        
        .onAppear{
            logs.removeAll()
            for fuel in fuels {
                logs.append(ActivityLog(cost: fuel.cost, fuelAmount: fuel.fuelAmount,date: fuel.date!))
            }
            adMobAd.showInterstitialAds()
//            calculate()
        }
        
        // prevent iPad split view
        .navigationViewStyle(StackNavigationViewStyle())
    }

//    func calculate(){
//        let counts = fuels.count
//        if counts >= 2 {
//            let firstFuel = fuels [counts - 2]
//            let secondFuel = fuels [counts - 1]
//
//            let distance = secondFuel.odometer - firstFuel.odometer
//            print(secondFuel.odometer)
//            print(firstFuel.odometer)
//            print(distance)
//            print(secondFuel.fuelAmount)
//            let lpk = (secondFuel.fuelAmount / Float(distance)) * 100
//            print(String(format: "%.2f", lpk))
//        }
//    }
    
    func calculateAverageConsumption() -> Float{
        if fuels.count > 1 {
            var currentFuel = fuels.first!
            var distances = [Int32]()
            var amounts = [Float]()
            
            for (index, fuel) in fuels.enumerated() {
                
                let distance = fuel.odometer - currentFuel.odometer
                distances.append(distance)
                
                let amount = fuel.fuelAmount
                amounts.append(amount)

                currentFuel = fuel
                
//                print("distance:\(distance)")
//                print("amount:\(amount)")
//                print("index:\(index) odometer:\(fuel.odometer)")
            }
            
            let sumOfDistances: Int32 = distances.sum()
            let sumOfAmounts: Float = amounts.sum() - fuels.first!.fuelAmount
            
            let alpk = (sumOfAmounts / Float(sumOfDistances))
            
//            print("alpk:\(alpk)")
//            print("alpk100:\(alpk * 100)")
            
            return alpk * 100
            
        }
        return 0
    }
    
    func lastOdometer() -> Int32 {
        if fuels.count > 0 {
            return fuels.last!.odometer
        }
        return 0
    }
    
    
}

struct ActivityHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityHistoryView()
    }
}


extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
