//
//  FuelViewModel.swift
//  FuelTracker
//
//

import Foundation
import CoreData
import AppTrackingTransparency
import AdSupport
import WidgetKit

class FuelViewModel: ObservableObject{
    @Published var showAddNewFuelStopView: Bool = false
    @Published var cost: String = ""
    @Published var fuelAmount: String = ""
    @Published var fullRefill: Bool = false
    @Published var odometer: String = ""
    @Published var date: Date = Date()
    @Published var notes: String = ""
    
    @Published var costSymbol = Locale.current.currencyCode ?? "$"
    
    @Published var editFuel: Fuel?
    @Published var showSubscriptionView: Bool = false
    
    init(){
        requestIDFA()
    }
    
    func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
          if AppUserDefaults.shouldShowInitScreen {
              self.showSubscriptionView = true
              AppUserDefaults.shouldShowInitScreen = false
          }
      })
    }
    
    func addFuelStop(context: NSManagedObjectContext) -> Bool {
        var fuel: Fuel!
        if let editFuel = editFuel {
            fuel = editFuel
        }else{
            fuel = Fuel(context: context)
        }
        fuel.cost = Float(cost.replacingOccurrences(of: ",", with: ".")) ?? 0
        fuel.fuelAmount = Float(fuelAmount.replacingOccurrences(of: ",", with: ".")) ?? 0
        fuel.isFullRefill = fullRefill
        fuel.odometer = Int32(odometer) ?? 0
        fuel.date = date
        fuel.notes = notes
        
        if let _ = try? context.save(){
            WidgetCenter.shared.reloadAllTimelines()
            return true
        }
        
        return false
    }
    
    func restoreEditData(){
        if let editFuel = editFuel {
            cost = String(editFuel.cost)
            fuelAmount = String(editFuel.fuelAmount)
            fullRefill = editFuel.isFullRefill
            odometer = String(editFuel.odometer)
            date = editFuel.date ?? Date()
            notes = editFuel.notes ?? ""
        }
    }
    
    func resetData(){
        cost = ""
        fuelAmount = ""
        fullRefill = false
        odometer = ""
        date = Date()
        notes = ""
        editFuel = nil
    }
    
    func deleteFuel(context: NSManagedObjectContext) -> Bool{
        if let editHabit = editFuel {
            context.delete(editHabit)
            if let _ = try? context.save(){
                resetData()
                WidgetCenter.shared.reloadAllTimelines()
                return true
            }
        }
        return false
    }
    
    func doneStatus() -> Bool {
        if cost == "" || fuelAmount == "" || odometer == "" {
            return false
        }
        return true
    }
    
}
