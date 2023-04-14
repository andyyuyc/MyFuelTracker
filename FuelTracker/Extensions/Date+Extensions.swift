//
//  Date+Extensions.swift
//  FuelTracker
//
//
import SwiftUI

extension Date {
    
    func getCurrentMonthAndYear() -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = "MMM yyyy"
         return dateformat.string(from: self)
     }
    
    func getFormattedDate(format: String) -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = format
         return dateformat.string(from: self)
     }
    
    func getFormattedDate() -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = "dd.MM.yyyy"
         return dateformat.string(from: self)
     }

    func getFormattedTime() -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = "HH:mm"
         return dateformat.string(from: self)
     }
     
     func getFormattedDate(style: DateFormatter.Style) -> String {
          let dateformat = DateFormatter()
         dateformat.dateStyle = style
         dateformat.timeStyle = .none
          return dateformat.string(from: self)
      }
    
    func getFormattedTime(style: DateFormatter.Style) -> String {
         let dateformat = DateFormatter()
        dateformat.dateStyle = .none
        dateformat.timeStyle = style
         return dateformat.string(from: self)
     }
}
