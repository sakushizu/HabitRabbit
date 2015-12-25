//
//  Date.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/28.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class DateManager: UIView {
    
    //表記する日にちの配列
    var currentMonthOfDates = [NSDate]()
    var selectedDate = NSDate()
    let DaysPerWeek: Int = 7
    var numberOfItems: Int!

    //月ごとのセルの数
    func daysAcquisition() -> Int {
        let rangeOfWeeks = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.WeekOfMonth, inUnit: NSCalendarUnit.Month, forDate: firstDateOfMonth())
        let numberOfWeeks: Int = rangeOfWeeks.length
        numberOfItems = numberOfWeeks * DaysPerWeek
        return numberOfItems
    }
    
    func firstDateOfMonth() -> NSDate {
        let components: NSDateComponents = NSCalendar.currentCalendar().components([.Year, .Month, .Day],
            fromDate: selectedDate)
        components.day = 1
        let firstDateMonth = NSCalendar.currentCalendar().dateFromComponents(components)!
        return firstDateMonth
    }
    
    //表記する日にちの取得
    func dateForCellAtIndexPath(numberOfItems: Int) {
        for var i = 0; i < numberOfItems; i++ {
            let ordinalityOfFirstDay = NSCalendar.currentCalendar().ordinalityOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.WeekOfMonth, forDate: firstDateOfMonth())
            let dateComponents = NSDateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            let date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: firstDateOfMonth(), options: NSCalendarOptions(rawValue: 0))!
            currentMonthOfDates.append(date)
        }
    }
    
    //表記の変更
    func conversionDateFormat(indexPath: NSIndexPath) -> String {
        dateForCellAtIndexPath(numberOfItems)
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        return formatter.stringFromDate(currentMonthOfDates[indexPath.row])
    }
    
    func conversionDateFormatFromNSDate(date: NSDate) -> String {
//        dateForCellAtIndexPath(numberOfItems)
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        return formatter.stringFromDate(date)
    }
    
    //前月の表示
    func prevMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    //次月の表示
    func nextMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        return selectedDate
    }

}
