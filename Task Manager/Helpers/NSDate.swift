//
//  NSDate.swift
//  Task Manager
//
//  Created by Victor Blokhin on 02/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import Foundation


extension NSDate {
    static var now: NSDate {
        get {
            return NSDate(timeIntervalSinceNow: 0)
        }
    }
    
    static var tomorrow: NSDate {
        get {
            return NSDate(timeIntervalSinceNow: 86400)
        }
    }
    func isGreaterThan(_ dateTime: NSDate) -> Bool {
        
        return self.timeIntervalSince1970 > dateTime.timeIntervalSince1970
    }
    
    func isLessThan(_ dateTime: NSDate) -> Bool {
        
        return self.timeIntervalSince1970 < dateTime.timeIntervalSince1970
    }
    
    func isEqualTo(_ dateTime: NSDate) -> Bool {
        
        return self.timeIntervalSince1970 == dateTime.timeIntervalSince1970
    }
    
    func isDateGreaterThan(_ date: NSDate) -> Bool {
        
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date as! Date)!
        let selfDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self as! Date)!
        
        return selfDate.timeIntervalSince1970 > date.timeIntervalSince1970
    }
    
    func isDateLessThan(_ date: NSDate) -> Bool {
        
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date as! Date)!
        let selfDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self as! Date)!
        
        return selfDate.timeIntervalSince1970 < date.timeIntervalSince1970
    }
    
    func isDateEqualTo(_ date: NSDate) -> Bool {
        
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date as! Date)!
        let selfDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self as! Date)!
        
        return selfDate.timeIntervalSince1970 == date.timeIntervalSince1970
    }
    
    var formattedDateTime: String {
        get {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy HH:mm"
                return formatter.string(from: self as Date)
            }
    }
    
    var formattedDate: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: self as Date)
        }
    }
}
