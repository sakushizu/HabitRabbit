//
//  StampedDateManager.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/06/30.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//一つのカレンダーのstampされた日付管理
class StampedDateManager: NSObject {
    
   static let sharedInstance = StampedDateManager()
    var dateCollection = [StampedDate]()
    
    func fetchStampedDates(calendarId: AnyObject, completion: () -> Void) {
        
        let params: [String: AnyObject] = [
            "calendar_id": calendarId
        ]
        
        Alamofire.request(
            .GET,
            "\(Settings.ApiRootPath)/api/stamped_dates/",
            parameters: params,
            headers: ["access_token": CurrentUser.sharedInstance.authentication_token!]
            ).responseJSON { response in
                guard response.result.error == nil else {
                    // Add error handling in the future
                    print("Can't connect to the server: \(response.result.error!)")
                    return
                }
                
                let json = JSON(response.result.value!)
                self.updateCalendarsFromJson(json["stamped_dates"])
                completion()
        }
    }
    
    
    private func createDateFromJson(json: JSON) -> [StampedDate] {
        var dates = [StampedDate]()
        
        for (_, stampedDateJson) in json {
            let convertDate = NSDate.dateFromISOString(stampedDateJson["date"].string!)
            let date = StampedDate(date: convertDate)
            dates.append(date)
        }
        
        return dates
    }
    
    private func updateCalendarsFromJson(datesJson: JSON) {
        dateCollection = createDateFromJson(datesJson)
    }
    
    
    func saveStampedDate(params: Dictionary<String, AnyObject>, callback: () -> Void) {
        
        let token = CurrentUser.sharedInstance.authentication_token
        // HTTP通信
        Alamofire.request(
            .POST,
            "\(Settings.ApiRootPath)/api/stamped_dates",
            parameters: params,
            headers: ["access_token": token],
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
                let convertDate = NSDate.dateFromISOString(json["date"].string!)
                let date = StampedDate(date: convertDate)
                StampedDateManager.sharedInstance.dateCollection.append(date)
                callback()
        }
    }
}
