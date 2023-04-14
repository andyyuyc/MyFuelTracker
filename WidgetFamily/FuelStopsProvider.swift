//
//  FuelStopsProvider.swift
//  WidgetFamilyExtension
//
//  Created by Asil Arslan on 5.06.2022.
//

import Foundation
import SwiftUI
import UIKit
import CoreData

public struct FuelStopsProvider {

  static func all() -> [Fuel] {
      
      do{
          let request = NSFetchRequest<Fuel>(entityName: "Fuel")
          let results = try PersistenceController.shared.container.viewContext.fetch(request)
          return results
      }catch let error{
          print(error.localizedDescription)
          return []
      }
   
  }
    
  static func random() -> Fuel? {
    let allHabit = FuelStopsProvider.all()
      if allHabit.count > 0 {
          let randomIndex = Int.random(in: 0..<allHabit.count)
          return allHabit[randomIndex]
      }else{
          return nil
      }
    
  }
    
    static func defaultFuelStop() -> Fuel {
        let fuel: Fuel = Fuel(context: PersistenceController.shared.container.viewContext)
        fuel.fuelAmount = 51
        fuel.odometer = 43786
        fuel.cost = 59
        fuel.dateAdded = Date()
        fuel.isFullRefill = false
        fuel.date = Date()
        fuel.notes = ""
        return fuel
    }
    
    static func defaultFuelStop2() -> Fuel {
        let fuel: Fuel = Fuel(context: PersistenceController.shared.container.viewContext)
        fuel.fuelAmount = 45
        fuel.odometer = 44786
        fuel.cost = 49
        fuel.dateAdded = Date()
        fuel.isFullRefill = false
        fuel.date = Date()
        fuel.notes = ""
        return fuel
    }
    
    static func defaultFuelStops() -> [Fuel]{
        return [defaultFuelStop(), defaultFuelStop2()]
    }
}

