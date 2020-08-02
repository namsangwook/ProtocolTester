//
//  Date+Extension.swift
//  thaiOTT
//
//  Created by knh on 2020/07/20.
//  Copyright © 2020 MB-0017. All rights reserved.
//

import Foundation

extension Date {
    
    public static var now: Date {
        return Date()
    }
    
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "th")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func toSecond() -> Int {
        let timeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    func hour() -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.hour], from: self)
        let hour = components.hour

        return hour ?? 0
    }

    func minute() -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.minute], from: self)
        let minute = components.minute

        return minute ?? 0
    }
    
    func second() -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.second], from: self)
        let minute = components.minute

        return minute ?? 0
    }
    
    func timeSecond() -> Int {
        return self.hour() * 60 * 60 + self.minute() * 60 + self.second()
    }
}
