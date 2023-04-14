//
//  AvgConsumptionWidget.swift
//  WidgetFamilyExtension
//
//  Created by Asil Arslan on 5.06.2022.
//

import Foundation
import WidgetKit
import SwiftUI

struct AvgConsumptionWidget: Widget {
    private let kind: String = "AvgConsumption"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AvgConsumptionTimelineProvider()) { (entry) in
            AvgConsumptionEntryView(entry: entry)
                }
                .supportedFamilies([.systemSmall])
                .configurationDisplayName("Avg. Consumption")
                .description("This widget shows Avg. Consumption")
        
    }
}
