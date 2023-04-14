//
//  OdometerTimelineProvider.swift
//  WidgetFamilyExtension
//
//  Created by Asil Arslan on 5.06.2022.
//

import Foundation
import WidgetKit

struct OdometerTimelineProvider: TimelineProvider {
    typealias Entry = OdometerEntry
    
    func placeholder(in context: Context) -> OdometerEntry {
        let entry = OdometerEntry(date: Date(), fuelStops: FuelStopsProvider.defaultFuelStops())
        return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (OdometerEntry) -> Void) {
        let entry = OdometerEntry(date: Date(), fuelStops: FuelStopsProvider.defaultFuelStops())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<OdometerEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        
        let entry = OdometerEntry(date: currentDate, fuelStops: FuelStopsProvider.all())
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)

    }
}
