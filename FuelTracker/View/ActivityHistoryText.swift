//
//  ActivityHistoryText.swift
//  FuelTracker
//
//

import SwiftUI

struct ActivityHistoryText: View {
    
    @EnvironmentObject var fuelViewModel: FuelViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    var logs: [ActivityLog]
    var max: Float
    
    @Binding var selectedIndex: Int
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }
    
    init(logs: [ActivityLog], selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        
        let curr = Date() // Today's Date
        let sortedLogs = logs.sorted { (log1, log2) -> Bool in
            log1.date > log2.date
        } // Sort the logs in chronological order
        
        var mergedLogs: [ActivityLog] = []
        
        for i in 0..<12 {
            
            var weekLog: ActivityLog = ActivityLog(cost: 0, fuelAmount: 0, date: Date())
            
            for log in sortedLogs {
                if log.date.distance(to: curr.addingTimeInterval(TimeInterval(-604800 * i))) < 604800 && log.date < curr.addingTimeInterval(TimeInterval(-604800 * i)) {
                    weekLog.cost += log.cost
                    weekLog.fuelAmount += log.fuelAmount
                    weekLog.fuelStop += 1
                }
            }
            
            mergedLogs.insert(weekLog, at: 0)
        }
        
        self.logs = mergedLogs
        self.max = mergedLogs.max(by: { $0.cost < $1.cost })?.cost ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(dateFormatter.string(from: logs[getSelectedIndex()].date.addingTimeInterval(-604800))) - \(dateFormatter.string(from: logs[getSelectedIndex()].date))".uppercased())
                .font(Font.body.weight(.heavy))
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cost")
                        .font(.caption)
                        .foregroundColor(Color.primary.opacity(0.5))
                    
                    Text(String(format: "%.2f \(fuelViewModel.costSymbol)", logs[getSelectedIndex()].cost))
                        .font(Font.system(size: 20, weight: .medium, design: .default))
                }
                
                Color.gray
                    .opacity(0.5)
                    .frame(width: 1, height: 30, alignment: .center)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(settingsViewModel.fuelType == .electric ? "Charge" : "Fuel Amount")
                        .font(.caption)
                        .foregroundColor(Color.primary.opacity(0.5))
                    Text(String(format: "%.2f \(settingsViewModel.fuelType == .electric ? "kWh" : "L")", logs[getSelectedIndex()].fuelAmount))
                        .font(Font.system(size: 20, weight: .medium, design: .default))
                }
                
                Color.gray
                    .opacity(0.5)
                    .frame(width: 1, height: 30, alignment: .center)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Fuel Stops")
                        .font(.caption)
                        .foregroundColor(Color.primary.opacity(0.5))
                    
                    Text(String(logs[getSelectedIndex()].fuelStop))
                        .font(Font.system(size: 20, weight: .medium, design: .default))
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("LAST 12 WEEKS")
                    .font(Font.caption.weight(.heavy))
                    .foregroundColor(Color.primary.opacity(0.7))
                Text(String(format: "%.2f \(fuelViewModel.costSymbol)", max))
                    .font(Font.caption)
                    .foregroundColor(Color.primary.opacity(0.5))
            }.padding(.top, 10)
            
            
        }
    }
    
    func getSelectedIndex() -> Int {
        if selectedIndex >= 0 && selectedIndex < 12 {
            return selectedIndex
        }else{
            return 11
        }
    }
}

struct ActivityHistoryText_Previews: PreviewProvider {
    static var previews: some View {
        ActivityHistoryText(logs: [], selectedIndex: .constant(0))
    }
}

