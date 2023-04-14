//
//  OdometerEntryView.swift
//  WidgetFamilyExtension
//
//  Created by Asil Arslan on 5.06.2022.
//

import SwiftUI

struct OdometerEntryView: View {
    let entry: OdometerEntry
    var body: some View {
        ZStack{
            if !entry.fuelStops.isEmpty {
                VStack(alignment: .center,spacing: 8){
                    VStack(alignment: .center,spacing: 8){
                        Image(systemName: "arrow.triangle.swap")
                            .font(.largeTitle)
                            .foregroundColor(.appTheme)
                        HStack {
                            Text(String(format: "%ld", locale: Locale.current, lastOdometer()))
                                .foregroundColor(.primary)
                            Text("km")
                                .foregroundColor(.secondary)
                        }
                    }
                    Text("Odometer")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
            }else{
                EmptyWidgetView()
            }
        }.edgesIgnoringSafeArea(.all)
    }

    
    func lastOdometer() -> Int32 {
        let fuels = entry.fuelStops
        if fuels.count > 0 {
            return fuels.last!.odometer
        }
        return 0
    }
}
