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
    var selectedDates:Array<Dictionary<String, NSDate>> = []
    
    
    //選択されたdateの追加
    func appendSelectedDates(preDate: NSDate) -> NSDate {
        var dic = [String:NSDate]()
        //1日後の日付を取得
//        let date = NSDate(timeInterval: 1 * 24 * 60 * 60, sinceDate: preDate)
        dic["day"] = preDate
        selectedDates.append(dic)
        save()
        return preDate
    }
    
    //NSUserDefaultに保存
    func save() {
        var dayList: Array<Dictionary<String, AnyObject>> = []
        for day in selectedDates {
            dayList.append(day)
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dayList, forKey: "dayList")
    }
    
    func fetchDates() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dayList = defaults.objectForKey("dayList") as? Array<Dictionary<String, AnyObject>> {
            for dayDic in dayList {
                let day = Calender.convertCalenderModel(dayDic)
                self.selectedDates.append(day)
            }
        }
    }
    
//    func deletedate(preDate: NSDate) {
//        for date in selectedDates {
//            date.removeValueForKey("\(preDate)")
//        }
//    }
    
    class func convertCalenderModel(attiributes: Dictionary<String, AnyObject>) -> Dictionary<String, NSDate> {
        var dic = Dictionary<String, NSDate>()
        dic["day"] = attiributes["day"] as? NSDate
        return dic
    }

}















