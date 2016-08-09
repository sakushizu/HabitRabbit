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
import Bond

class CalenderManager: NSObject {
    
    static let sharedInstance = CalenderManager()
    
    var calendarCollection = Observable<[Calendar]>([])
    
    func fetchCalendars(completion completion: () -> Void) {
        Alamofire.request(
            .GET,
            "\(Settings.ApiRootPath)/api/calendars/",
            headers: ["access_token": CurrentUser.sharedInstance.authentication_token.value]
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
    
    func joinCalendar(params: [String: Int], completion: () -> Void) {
        // HTTP通信
        Alamofire.request(
            .POST,
            "\(Settings.ApiRootPath)/api/calendar_users",
            parameters: params,
            headers: nil,
            encoding: .URL
            ).responseJSON { response in
                guard response.result.error == nil else {
                    print("result.error")
                    // Alert
                    return
                }
                guard let _ = response.result.value else {
                    print("responseValue")
                    return
                }
                
                let json = JSON(response.result.value!)
                let calendar = Calendar(json: json)
                let calendarManager = CalenderManager.sharedInstance
                calendarManager.calendarCollection.value.append(calendar)
                completion()
        }
    }
    
    func rejectInvitation(params: [String: Int], completion: () -> Void) {
        Alamofire.request(
            .POST,
            "\(Settings.ApiRootPath)/api/users/\(params["user_id"]!)/invitation_users/reject",
            parameters: params,
            headers: nil,
            encoding: .URL
            ).responseJSON { response in
                guard response.result.error == nil else {
                    print("result.error")
                    // Alert
                    return
                }
                guard let _ = response.result.value else {
                    print("responseValue")
                    return
                }
                completion()
        }
    }
    
    
    private func createCalendarsFromJson(json: JSON) -> [Calendar] {
        var calendars = [Calendar]()
        
        for (_, calendarJson) in json {
            let calendar = Calendar(json: calendarJson)
            let user = User(jsonWithUser: calendarJson["user"])
            calendar.orner = user
            for (_, userJson) in calendarJson["users"]  {
                let user = User(jsonWithUser: userJson)
                calendar.joinedUsers.append(user)
            }
            calendars.append(calendar)
        }
        
        return calendars
    }
    
    private func updateCalendarsFromJson(calendarsJson: JSON) {
        calendarCollection.value = createCalendarsFromJson(calendarsJson)
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

