//
//  CalenderManager.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/25.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CalenderManager: NSObject {
    
    static let sharedInstance = CalenderManager()
    
    var calender: Calendar!
    var calendarCollection = [Calendar]()
    
    
    
    func fetchCalendars(completion completion: () -> Void) {
        Alamofire.request(
            .GET,
            "\(Settings.ApiRootPath)/api/calendars/",
            headers: ["access_token": CurrentUser.sharedInstance.authentication_token!]
            ).responseJSON { response in
                guard response.result.error == nil else {
                    // Add error handling in the future
                    print("Can't connect to the server: \(response.result.error!)")
                    return
                }
                
                let json = JSON(response.result.value!)
                self.updateCalendarsFromJson(json["calendars"])
                completion()
        }
    }
    
    
    func createCalendarsFromJson(json: JSON) -> [Calendar] {
        var calendars = [Calendar]()
        
        for (_, calendarJson) in json {
            let calendar = Calendar(json: calendarJson)
            print(calendar)
            calendars.append(calendar)
        }
        
        return calendars
    }
    
    func updateCalendarsFromJson(calendarsJson: JSON) {
        calendarCollection = createCalendarsFromJson(calendarsJson)
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

