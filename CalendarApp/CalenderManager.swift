//
//  CalenderManager.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/25.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalenderManager: NSObject {
    static let sharedInstance = CalenderManager()
    var calender = Calender()
    var calendarCollection = [Calender]()
    var groupCalendarCollection = [Calender]()
    
    
    var key: String!

    func addCalendarCollection(calendar: Calender, calendarType: String){
        if calendarType == "private" {
            self.calendarCollection.append(calendar)
        } else {
            self.groupCalendarCollection.append(calendar)
        }
        self.saveSelfCalendar(calendarType)
    }
    
    func saveSelfCalendar(calendarType: String) {
        var calendarList: Dictionary<String,  Array<Dictionary<String, AnyObject>>> = [:]
        var privateArray = [Dictionary<String, AnyObject>]()
        var groupArray = [Dictionary<String, AnyObject>]()
        
        for calendar in calendarCollection {
            let calendarDic = CalenderManager.convertDictionary(calendar, calendarType: calendarType)
            privateArray.append(calendarDic)
        }
        for calendar in groupCalendarCollection {
            let calendarDic = CalenderManager.convertDictionary(calendar, calendarType: calendarType)
            groupArray.append(calendarDic)
        }
        calendarList["private"] = privateArray
        calendarList["group"] = groupArray
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if CurrentUser.sharedInstance.user == nil {
            defaults.setObject(calendarList, forKey: "calendarList")
            defaults.synchronize()
        } else {
            defaults.setObject(calendarList, forKey: CurrentUser.sharedInstance.user.name)
            defaults.synchronize()
        }
    }
    
    func fetchCalendarCollection() {
        self.calendarCollection = []
        self.groupCalendarCollection = []
        let defaults = NSUserDefaults.standardUserDefaults()
        if CurrentUser.sharedInstance.user == nil {
            key = "calendarList"
        } else {
            key = CurrentUser.sharedInstance.user.name
        }
        if let calendarList = defaults.objectForKey(key) as? Dictionary<String,  Array<Dictionary<String, AnyObject>>> {
            for (calendarType, calendarArray) in calendarList {
                if calendarType == "private" {
                    for calendarDic in calendarArray {
                        let calendar = CalenderManager.convertCalendarModel(calendarDic)
                        self.calendarCollection.append(calendar)
                    }
                } else if calendarType == "group" {
                    for calendarDic in calendarArray {
                        let calendar = CalenderManager.convertCalendarModel(calendarDic)
                        self.groupCalendarCollection.append(calendar)
                    }
                }
            }
        }
    }
    
    class func convertDictionary(calendar: Calender, calendarType: String) -> Dictionary<String, AnyObject> {
        var dic = Dictionary<String, AnyObject>()
        dic["title"] = calendar.title
        dic["memo"] = calendar.memo
        let colorData = NSKeyedArchiver.archivedDataWithRootObject(calendar.color)
        dic["color"] = colorData
        let imageData = UIImagePNGRepresentation(calendar.image)
        dic["image"] = imageData
        if calendarType == "group" {
            dic["object_id"] = calendar.object_id
        }
        return dic
    }
    
    class func convertCalendarModel(attiributes: Dictionary<String, AnyObject>) -> Calender {
        let calendar = Calender()
        calendar.title = attiributes["title"] as? String
        calendar.memo = attiributes["memo"] as! String
        if let object_id = attiributes["object_id"] as? String {
            calendar.object_id = object_id
        }
        let color = attiributes["color"] as! NSData
        if let savedColor  = NSKeyedUnarchiver.unarchiveObjectWithData(color) as? UIColor {
            calendar.color = savedColor
        }
        let imageData = attiributes["image"] as! NSData
        let image = UIImage(data: imageData)
        calendar.image = image
        return calendar
    }
    
    //NSUserDefaultsの全てのobjectのリセット
    func resetDefaults() {
        let defs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let dict: [NSObject : AnyObject] = defs.dictionaryRepresentation()
        for key in dict.keys {
            defs.removeObjectForKey(key as! String)
        }
        defs.synchronize()
    }

}

