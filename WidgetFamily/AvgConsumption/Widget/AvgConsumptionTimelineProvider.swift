//
//  AvgConsumptionTimelineProvider.swift
//  WidgetFamilyExtension
//
//  Created by Asil Arslan on 5.06.2022.
//

import Foundation
import WidgetKit

struct AvgConsumptionTimelineProvider: TimelineProvider {
    typealias Entry = AvgConsumptionEntry
    
    func placeholder(in context: Context) -> AvgConsumptionEntry {
        let entry = AvgConsumptionEntry(date: Date(), fuelStops: FuelStopsProvider.defaultFuelStops())
        return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AvgConsumptionEntry) -> Void) {
        let entry = AvgConsumptionEntry(date: Date(), fuelStops: FuelStopsProvider.defaultFuelStops())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<AvgConsumptionEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        
        let entry = AvgConsumptionEntry(date: currentDate, fuelStops: FuelStopsProvider.all())
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)

    }
}
