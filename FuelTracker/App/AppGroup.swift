//
//  AppGroup.swift
//  FuelTracker
//
//

import Foundation

public enum AppGroup: String {
  case name = "group.com.andyyuyc.FuelTracker"

  public var containerURL: URL {
    switch self {
    case .name:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
