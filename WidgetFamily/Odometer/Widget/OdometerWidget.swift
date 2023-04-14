//
//  OdometerWidget.swift
//  WidgetFamilyExtension
//
//  Created by Asil Arslan on 5.06.2022.
//

import Foundation
import WidgetKit
import SwiftUI

struct OdometerWidget: Widget {
    private let kind: String = "Odometer"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OdometerTimelineProvider()) { (entry) in
            OdometerEntryView(entry: entry)
                }
                .supportedFamilies([.systemSmall])
                .configurationDisplayName("Odometer")
                .description("This widget shows Odometer")
        
    }
}
