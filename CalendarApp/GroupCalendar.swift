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
    
    func saveParse(title: String,callback: () -> Void) {
        let calendarObject = PFObject(className: "Calendar")
        calendarObject["title"] = title
        calendarObject["password"] = self.password
        calendarObject.saveInBackgroundWithBlock { (success, error) in
            if success {
                callback()
            }
        }
    }

}
