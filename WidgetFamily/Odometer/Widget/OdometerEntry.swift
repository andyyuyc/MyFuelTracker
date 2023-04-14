//
//  OdometerEntry.swift
//  WidgetFamilyExtension
//
//  Created by Asil Arslan on 5.06.2022.
//

import Foundation
import WidgetKit

struct OdometerEntry: TimelineEntry {
    public let date: Date
    public let fuelStops: [Fuel]
}

