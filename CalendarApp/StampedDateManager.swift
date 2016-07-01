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
    
    class func saveStampedDate(params: Dictionary<String, AnyObject>, callback: () -> Void) {
        
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
