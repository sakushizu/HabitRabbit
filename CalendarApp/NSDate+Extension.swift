//
//  NSDate+Extension.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/25.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

extension NSDate {
    func monthAgoDate() -> NSDate {
        let addValue: Int = -1
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func monthLaterDate() -> NSDate {
        let addValue: Int = 1
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    //String -> NSdate
    class func dateFromISOString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.dateFromString(string)!
    }

}
