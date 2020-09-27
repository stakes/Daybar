//
//  Dates.swift
//  TodayTest
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation

class Dates {
    
//    public func todayTimeMin() -> String {
//        let date: Date = Date()
//        let cal: Calendar = Calendar(identifier: .gregorian)
//
//        let newDate: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
//        let formatter = ISO8601DateFormatter()
//        formatter.timeZone = TimeZone.current
//        formatter.formatOptions = [.withInternetDateTime]
//        return formatter.string(from: newDate)
//    }
//
//    public func todayTimeMax() -> String {
//        let date: Date = Date()
//        let cal: Calendar = Calendar(identifier: .gregorian)
//
//        let newDate: Date = cal.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
//        let formatter = ISO8601DateFormatter()
//        formatter.timeZone = TimeZone.current
//        formatter.formatOptions = [.withInternetDateTime]
//        return formatter.string(from: newDate)
//    }
    
    public func incrementDay(_ date: Date) -> Date {
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let cal = Calendar.current
        let nextDate = cal.date(byAdding: dayComponent, to: date)
        return nextDate!
    }
    
    public func decrementDay(_ date: Date) -> Date {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let cal = Calendar.current
        let prevDate = cal.date(byAdding: dayComponent, to: date)
        return prevDate!
    }
    
    public func timeMinForDay(_ date: Date) -> String {
        let date: Date = date
        let cal: Calendar = Calendar(identifier: .gregorian)

        let newDate: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: newDate)
    }
    
    public func timeMaxForDay(_ date: Date) -> String {
        let date: Date = date
        let cal: Calendar = Calendar(identifier: .gregorian)

        let newDate: Date = cal.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: newDate)
    }
    
    public func internetTimeToHumanTime(_ str: String) -> String {
        let date = ISO8601DateFormatter().date(from: str)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date!)
    }
    
    public func todayInWords() -> String {
        let date: Date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd"
        
        return formatter.string(from: date)
    }
    
    public func dayInWords(_ date: Date) -> String {
        let date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd"
        
        return formatter.string(from: date)
    }
    
    public func timeDifferenceInWords(from: String, to: String) -> String {
        let fromDate = ISO8601DateFormatter().date(from: from)
        let toDate = ISO8601DateFormatter().date(from: to)
  
        let diff = toDate?.timeIntervalSince(fromDate!)
        let hours = floor(diff!/60/60)
        let mins = floor((diff! - (hours * 60 * 60))/60)
        
        var str = ""
        if hours > 0 {
            str = str + "\(Int(hours))h"
        }
        if mins > 0 {
            str = str + "\(Int(mins))m"
        }
        return str
    }
    
    public func timeInterval(from: String, to: String) -> String {
        let fromDate = ISO8601DateFormatter().date(from: from)
        let toDate = ISO8601DateFormatter().date(from: to)
        
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: fromDate!, to: toDate!)
    }
    
}
