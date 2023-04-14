//
//  SKProduct+Extensions.swift
//  FuelTracker
//
//

import StoreKit
extension SKProduct {

    
    func introductoryPrice() -> String?{
        if introductoryPrice != nil {
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .currency
//            formatter.locale = introductoryPrice!.priceLocale
//            let text = formatter.string(from: price)
            let period = introductoryPrice!.subscriptionPeriod.unit
            var periodString = ""
            switch period {
            case .day:
                periodString = "day"
            case .month:
                periodString = "month"
            case .week:
                periodString = "week"
            case .year:
                periodString = "year"
            default:
                break
            }
            let unitCount = introductoryPrice!.subscriptionPeriod.numberOfUnits
            let unitString = unitCount == 1 ? periodString : "\(unitCount) \(periodString)s"
            return "\(unitString) for " + "FREE"//(text ?? "")
        }
        return nil
    }
    
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        let text = formatter.string(from: price)
        let period = subscriptionPeriod!.unit
        var periodString = ""
        switch period {
        case .day:
            periodString = "day"
        case .month:
            periodString = "month"
        case .week:
            periodString = "week"
        case .year:
            periodString = "year"
        default:
            break
        }
        let unitCount = subscriptionPeriod!.numberOfUnits
        let unitString = unitCount == 1 ? periodString : "\(unitCount) \(periodString)s"
        return (text ?? "") + "\nper \(unitString)"
    }

    
    func unit() -> String {
        let unitCount = subscriptionPeriod!.numberOfUnits
        return "\(unitCount)"
    }
    
    
    func duration() -> String {
        let period = subscriptionPeriod!.unit
        var periodString = ""
        switch period {
        case .day:
            periodString = "day"
        case .month:
            periodString = "month"
        case .week:
            periodString = "week"
        case .year:
            periodString = "year"
        default:
            break
        }
//        let unitCount = subscriptionPeriod!.numberOfUnits
//        let unitString = unitCount == 1 ? periodString : "\(unitCount) \(periodString)s"
        return "\(periodString)"
    }
    
    func price() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        let text = formatter.string(from: price)
        return (text ?? "")
    }
}

