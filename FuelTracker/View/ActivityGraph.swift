//
//  ActivityGraph.swift
//  FuelTracker
//
//

import SwiftUI

struct ActivityGraph: View {
    
    var logs: [ActivityLog]
    @Binding var selectedIndex: Int
    
    @State var lineOffset: CGFloat = 8
    @State var selectedXPos: CGFloat = 8
    @State var selectedYPos: CGFloat = 0
    @State var isSelected: Bool = false
    var graphColor = Color.appTheme//Color(red: 251/255, green: 82/255, blue: 0)
    
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
                }
            }

            mergedLogs.insert(weekLog, at: 0)
        }

        self.logs = mergedLogs
    }
    
    var body: some View {
        drawGrid()
        .opacity(0.2)
        .overlay(drawActivityGradient(logs: logs))
        .overlay(drawActivityLine(logs: logs))
        .overlay(drawLogPoints(logs: logs))
        .overlay(addUserInteraction(logs: logs))
    }
    
    func drawActivityLine(logs: [ActivityLog]) -> some View {
        GeometryReader { geo in
            Path { p in
                let maxNum = logs.reduce(0) { (res, log) -> Float in
                    return max(res, log.cost)
                }
                
                var scale = maxNum == 0 ? 1 : geo.size.height / CGFloat(maxNum)
                
                var index: CGFloat = 0
                
                p.move(to: CGPoint(x: 8, y: geo.size.height - (CGFloat(logs[0].cost) * scale)))
                
                for _ in logs {
                    if index != 0 {
                        p.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * index, y: geo.size.height - (CGFloat(logs[Int(index)].cost) * scale)))
                    }
                    index += 1
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
            .foregroundColor(graphColor)
        }
    }
    
    func drawActivityGradient(logs: [ActivityLog]) -> some View {
        LinearGradient(gradient: Gradient(colors: [graphColor, .white]), startPoint: .top, endPoint: .bottom)
            .padding(.horizontal, 8)
            .padding(.bottom, 1)
            .opacity(0.8)
            .mask(
                GeometryReader { geo in
                    Path { p in
                        // Used for scaling graph data
                        let maxNum = logs.reduce(0) { (res, log) -> Float in
                            return max(res, log.cost)
                        }
                        
                        let scale = geo.size.height / CGFloat(maxNum)
                        
                        var index: CGFloat = 0
                        
                        // Move to the starting y-point on graph
                        p.move(to: CGPoint(x: 8, y: geo.size.height - (CGFloat(logs[Int(index)].cost) * scale)))
                        
                        // For each week draw line from previous week
                        for _ in logs {
                            if index != 0 {
                                p.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * index, y: geo.size.height - (CGFloat(logs[Int(index)].cost) * scale)))
                            }
                            index += 1
                        }

                        // Finally close the subpath off by looping around to the beginning point.
                        p.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * (index - 1), y: geo.size.height))
                        p.addLine(to: CGPoint(x: 8, y: geo.size.height))
                        p.closeSubpath()
                    }
                }
            )
    }
    
    func drawLogPoints(logs: [ActivityLog]) -> some View {
        GeometryReader { geo in
            
            let maxNum = logs.reduce(0) { (res, log) -> Float in
                return max(res, log.cost)
            }
            
            var scale = maxNum == 0 ? 1 : geo.size.height / CGFloat(maxNum)
            

            ForEach(logs.indices) { i in
                
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
                    
                    .frame(width: 10, height: 10, alignment: .center)
                    .foregroundColor(graphColor)
                    .background(Color.white)
                    .cornerRadius(5)
                    .offset(x: 8 + ((geo.size.width - 16) / 11) * CGFloat(i) - 5, y: (geo.size.height - (CGFloat(logs[i].cost) * scale)) - 5)
            }
        }
    }
    
    func drawGrid() -> some View {
        VStack(spacing: 0) {
            Color.black.frame(height: 1, alignment: .center)
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: 8, height: 100)
                ForEach(0..<11) { i in
                    Color.black.frame(width: 1, height: 100, alignment: .center)
                    Spacer()
                        
                }
                Color.black.frame(width: 1, height: 100, alignment: .center)
                Color.clear
                    .frame(width: 8, height: 100)
            }
            Color.black.frame(height: 1, alignment: .center)
        }
    }
    
    func addUserInteraction(logs: [ActivityLog]) -> some View {
        GeometryReader { geo in
            
            let maxNum = logs.reduce(0) { (res, log) -> Float in
                return max(res, log.cost)
            }
            
            var scale = maxNum == 0 ? 1 : geo.size.height / CGFloat(maxNum)
            
            
           ZStack(alignment: .leading) {
                // Line and point overlay
               graphColor
                    .frame(width: 2)
                    .overlay(
                        Circle()
                            .frame(width: 24, height: 24, alignment: .center)
                            .foregroundColor(graphColor)
                            .opacity(0.2)
                            .overlay(
                                Circle()
                                    .fill()
                                    .frame(width: 12, height: 12, alignment: .center)
                                    .foregroundColor(graphColor)
                            )
                            .offset(x: 0, y: isSelected ? 12 - (selectedYPos * scale) : 12 - (CGFloat(logs[getSelectedIndex()].cost) * scale))
                        , alignment: .bottom)
                    
                    .offset(x: isSelected ? lineOffset : 8 + ((geo.size.width - 16) / 11) * CGFloat(getSelectedIndex()), y: 0)
                    .animation(Animation.spring().speed(4))
                
                // Drag Gesture Code
                Color.white.opacity(0.1)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { touch in
                                let xPos = touch.location.x
                                self.isSelected = true
                                let index = (xPos - 8) / (((geo.size.width - 16) / 11))
                                
                                if index > 0 && index < 11 {
                                    let m = (logs[Int(index) + 1].cost - logs[Int(index)].cost)
                                    self.selectedYPos = CGFloat(m) * index.truncatingRemainder(dividingBy: 1) + CGFloat(logs[Int(index)].cost)
                                }
                                
                                
                                if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < 11 {
                                    self.selectedIndex = Int(index) + 1
                                } else {
                                    self.selectedIndex = Int(index)
                                }
                                self.selectedXPos = min(max(8, xPos), geo.size.width - 8)
                                self.lineOffset = min(max(8, xPos), geo.size.width - 8)
                            }
                            .onEnded { touch in
                                let xPos = touch.location.x
                                self.isSelected = false
                                let index = (xPos - 8) / (((geo.size.width - 16) / 11))
                                
                                if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < 11 {
                                    self.selectedIndex = Int(index) + 1
                                } else {
                                    self.selectedIndex = Int(index)
                                }
                            }
                    )
            }
            
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

struct ActivityHistoryGraph_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGraph(logs: [], selectedIndex: .constant(3))
            .padding()
    }
}

