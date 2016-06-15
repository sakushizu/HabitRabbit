//
//  StockCalendars.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/06/09.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StockCalendars: NSObject {
    static let sharedInstance = StockCalendars()
    
//     保存ボタンが押されたときに呼ばれるメソッドを定義
    class func saveCalendarRails(calendar: Calendar) {
        
        let currentUser = CurrentUser.sharedInstance
        
        let params: [String: AnyObject] = [
            "title": calendar.title!,
            "color_R": calendar.color_r,
            "color_G": calendar.color_g,
            "color_B": calendar.color_b
        ]
        
        // HTTP通信
        Alamofire.request(.POST, "http://localhost:3000/api/calendars.json?email=\(currentUser.user.mailAddress)&token=\(currentUser.authentication_token)", parameters: params, encoding: .URL).responseJSON { response in
            
            print("=============request=============")
            print(response.request)
            print("=============response============")
            print(response.response)
            print("=============JSON================")
            print(JSON(response.result.value!))
            print("=============error===============")
            print(response.result.error)
            print("=================================")
        }
        
    }

}
