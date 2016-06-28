//
//  Calender.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/25.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import SwiftyJSON

class Calendar: NSObject {
    
    static let sharedInstance = Calendar(json: "json")
    
    //カレンダーの情報をもつ辞書型
    var selectedDates: Dictionary<NSDate, String> = [:]
    var id: Int!
    var title: String?
    var color_r: Int!
    var color_g: Int!
    var color_b: Int!
    var color: UIColor!
    var stampImageURL: String!
    var orner: User!
    
    var memo = ""
    
    var object_id: String = ""
    var password: String = ""
    
    var type: String = ""
    
    var defaultsCalendarTitle = ""
    
    
    init(json: JSON) {
        self.id = json["id"].int
        self.title = json["title"].string
        self.color_r = json["color_R"].int
        self.color_g = json["color_G"].int
        self.color_b = json["color_B"].int
        self.stampImageURL = json["stamp_image"].string
        self.orner = User(jsonWithUser: json["user"])
    }
    
    init(title: String, color_r: Int, color_g: Int, color_b: Int, stampImageURL: String) {
        self.title = title
        self.color_r = color_r
        self.color_g = color_g
        self.color_b = color_b
        self.stampImageURL = stampImageURL
    }
    
    
    //選択されたdateの追加
    func appendSelectedDates(preDate: NSDate) {
        selectedDates[preDate] = "tapped"
        save()
    }
    
    //NSUserDefaultに保存
    func save() {
        defaultsCalendarTitle = "\(CurrentUser.sharedInstance.user.name)_\(type)_\(title!)"
        var dayList: Dictionary<String, String> = [:]
        for (key,value) in selectedDates {
            let date = changeNSDateToString(key)
            dayList[date] = value
            let defaults = NSUserDefaults.standardUserDefaults()  //定数defaultsの定数名は任意で変更する事ができます
            defaults.setObject(dayList, forKey: defaultsCalendarTitle)
        }
    }

    //NSUserDefaultから削除
    func deletedate(preDate: NSDate) {
        selectedDates.removeValueForKey(preDate)
        save()
    }
    
    //NSUserDefaultに保存されているデータをselectedDatesに入れる
    func fetchDates() {
        if CurrentUser.sharedInstance.user.name == "guestUser" {
            defaultsCalendarTitle = "\(CurrentUser.sharedInstance.user.name)_\(type)_\(title!)"
        } else {
            defaultsCalendarTitle = "\(CurrentUser.sharedInstance.user.name)_\(type)_\(title!)"
        }
        selectedDates = [:]
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dayList = defaults.objectForKey(defaultsCalendarTitle) as? Dictionary<String, String> {
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
    
    

}















