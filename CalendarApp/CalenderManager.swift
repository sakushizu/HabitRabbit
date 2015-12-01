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
    //選択された日の保存
    var SelectedDays:[CalenderCell] = []
    var calenderArray:[Calender] = []
    
    func addSelectedDays(cell: CalenderCell) {
        self.SelectedDays.append(cell)
        save()
    }
    
    //NSUserDefaultに保存
    func save() {
        var dayList: Array<Dictionary<String, AnyObject>> = []
        for day in SelectedDays {
            let dayDic = CalenderManager.convertDictionary(day)
            dayList.append(dayDic)
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dayList, forKey: "dayList")
    }
    
    func fetchTodos() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dayList = defaults.objectForKey("dayList") as? Array<Dictionary<String, AnyObject>> {
            for dayDic in dayList {
                let day = CalenderManager.convertTodoModel(dayDic)
                self.SelectedDays.append(day)
                
            }
        }
    }
    
    //辞書型に変換
    class func convertDictionary(cell: CalenderCell) -> Dictionary<String, AnyObject> {
        var  dic = Dictionary<String, AnyObject>()
        dic["text"] = cell.title
        return dic
    }
    
    class func convertTodoModel(day: Dictionary<String, AnyObject>) -> CalenderCell {
        let cell = CalenderCell()
        cell.title = day["title"] as! UILabel
        return cell
    }
}
