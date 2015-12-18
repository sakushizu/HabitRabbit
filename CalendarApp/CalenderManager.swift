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
    var titles = [String]()
    var calendarCollection = [Calender]()

    func addCalendarCollection(calendar: Calender){
        self.calendarCollection.append(calendar)
        self.titles.append(calendar.title!)
        self.saveSelfCalendar()
    }
    
    func saveSelfCalendar() {
        var calendarList: Array<Dictionary<String, AnyObject>> = []
        for calendar in calendarCollection {
            let calendarDic = CalenderManager.convertDictionary(calendar)
            calendarList.append(calendarDic)
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(calendarList, forKey: "calendarList")
        defaults.synchronize()
    }
    
    func fetchCalendarCollection() {
        self.calendarCollection = []
        self.titles = []
        let defaults = NSUserDefaults.standardUserDefaults()
        if let calendarList = defaults.objectForKey("calendarList") as? Array<Dictionary<String, AnyObject>> {
            for calendarDic in calendarList {
                let calendar = CalenderManager.convertCalendarModel(calendarDic)
                self.calendarCollection.append(calendar)
                self.titles.append(calendar.title!)
            }
        }
    }
    
    class func convertDictionary(calendar: Calender) -> Dictionary<String, AnyObject> {
        var dic = Dictionary<String, AnyObject>()
        dic["title"] = calendar.title
        let colorData = NSKeyedArchiver.archivedDataWithRootObject(calendar.color)
        dic["color"] = colorData
        let imageData = UIImagePNGRepresentation(calendar.image)
        dic["image"] = imageData
        return dic
    }
    
    class func convertCalendarModel(attiributes: Dictionary<String, AnyObject>) -> Calender {
        let calendar = Calender()
        calendar.title = attiributes["title"] as? String
        let color = attiributes["color"] as! NSData
        if let savedColor  = NSKeyedUnarchiver.unarchiveObjectWithData(color) as? UIColor {
            calendar.color = savedColor
        }
        let imageData = attiributes["image"] as! NSData
        let image = UIImage(data: imageData)
        calendar.image = image
        return calendar
    }

}

