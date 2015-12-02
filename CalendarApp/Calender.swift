//
//  Calender.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/25.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class Calender: NSObject {
    
    static let sharedInstance = Calender()
    //選択されたdateの配列
    var selectedDates:Dictionary<NSDate, String> = [:]
    
    
    //選択されたdateの追加
    func appendSelectedDates(preDate: NSDate) {
        selectedDates[preDate] = "tapped"
        save()
    }
    
    //NSUserDefaultに保存
    func save() {
        var dayList: Dictionary<String, String> = [:]
        for (key,value) in selectedDates {
            let date = changeNSDateToString(key)
            dayList[date] = value
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dayList, forKey: "dayList")
    }
    
    //NSUserDefaultから削除
    func deletedate(preDate: NSDate) {
        selectedDates.removeValueForKey(preDate)
        save()
    }
    
    //NSUserDefaultに保存されているデータをselectedDatesに入れる
    func fetchDates() {
        selectedDates = [:]
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dayList = defaults.objectForKey("dayList")! as? Dictionary<String,String> {
            for (key,value) in dayList {
                let date = changeStringToNSDate(key)
                selectedDates[date] = value
            }
        }
    }
    
    //日付の型をNSDateに変更
    func changeStringToNSDate(stringDate: String) -> NSDate {
        let date_formatter: NSDateFormatter = NSDateFormatter()
        date_formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return date_formatter.dateFromString(stringDate)!
    }
    //日付の型をStringに変更
    func changeNSDateToString(stringDate: NSDate) -> String {
        let date_formatter: NSDateFormatter = NSDateFormatter()
        date_formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = date_formatter.stringFromDate(stringDate)
        return date
    }
    
//    class func convertCalenderModel(attiributes: Dictionary<String, AnyObject>) -> Dictionary<String, NSDate> {
//        var dic = Dictionary<String, NSDate>()
//        dic[\()"] = attiributes["day"] as? NSDate
//        return dic
//    }

}















