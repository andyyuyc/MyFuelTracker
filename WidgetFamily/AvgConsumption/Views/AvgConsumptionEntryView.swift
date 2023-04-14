//
//  AvgConsumptionEntryView.swift
//  WidgetFamilyExtension
//
//  Created by Asil Arslan on 5.06.2022.
//

import SwiftUI

struct AvgConsumptionEntryView: View {
    let entry: AvgConsumptionEntry
    var body: some View {
        ZStack{
            if !entry.fuelStops.isEmpty {
                VStack(alignment: .center,spacing: 8){
                    VStack(alignment: .center,spacing: 8){
                        Image(systemName: "drop.circle")
                            .font(.largeTitle)
                            .foregroundColor(.appTheme)
                        HStack {
                            Text(String(format: "%.2f", calculateAverageConsumption()))
                                .foregroundColor(.primary)
                            Text(AppUserDefaults.preferredFuelType == 0 ? "L/100 km" : "kWh/100 km")
                                .foregroundColor(.secondary)
                        }
                    }
                    Text("Avgerage\nConsumption")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
            }else{
                EmptyWidgetView()
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    func calculateAverageConsumption() -> Float{
        let fuels = entry.fuelStops
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
}



extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
