//
//  GroupCalendar.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/16.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Parse

class GroupCalendar: NSObject {
    
    static let sharedInstance = GroupCalendar()
    
    var password: String = ""
    
    func createParse(title: String,callback: () -> Void) {
        let calendarQuery = PFQuery(className: "Calendar")
        calendarQuery.whereKey("title", equalTo: title)
        calendarQuery.whereKey("password", equalTo: self.password)
        calendarQuery.getFirstObjectInBackgroundWithBlock { (object, notFind) -> Void in
            if notFind == nil {
                print("this calendar already saved.")
            } else {
                let calendarObject = PFObject(className: "Calendar")
                calendarObject["title"] = title
                calendarObject["password"] = self.password
                calendarObject["orner"] = PFUser.currentUser()!
                let relation = calendarObject.relationForKey("users")
                relation.addObject(PFUser.currentUser()!)
                calendarObject.saveInBackgroundWithBlock { (success, error) in
                    if success {
                        callback()
                    }
                }
            }
        }
    }
    
    func joinParse(title: String,callback: () -> Void) {
        let calendarQuery = PFQuery(className: "Calendar")
        calendarQuery.whereKey("title", equalTo: title)
        calendarQuery.whereKey("password", equalTo: self.password)
        calendarQuery.getFirstObjectInBackgroundWithBlock { (object, notFind) -> Void in
            if notFind == nil {
                let relation = object!.relationForKey("users")
                relation.addObject(PFUser.currentUser()!)
                object!.saveInBackgroundWithBlock { (success, error) in
                    if success {
                        callback()
                    }
                }
            } else {
                print("this calnedar not saved yet.")
            }
        }
    }
    
    
}
