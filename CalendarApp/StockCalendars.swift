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
    
    //新規カレンダー保存
    class func saveCalendarRails(params: Dictionary<String, AnyObject>, callback: () -> Void) {
        
        let currentUser = CurrentUser.sharedInstance
        
        let title = (params["title"]! as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_r = (String(params["color_r"]!)).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_g = (String(params["color_g"]!)).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_b = (String(params["color_b"]!)).dataUsingEncoding(NSUTF8StringEncoding)!
        let stampImage = UIImagePNGRepresentation(params["stamp"] as! UIImage)
        // HTTP通信
        Alamofire.upload(
            .POST,
            "http://localhost:3000/api/calendars.json?email=\(currentUser.user.mailAddress)&token=\(currentUser.authentication_token)",
            headers: nil,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: title, name: "title")
                multipartFormData.appendBodyPart(data: color_r, name: "color_R")
                multipartFormData.appendBodyPart(data: color_g, name: "color_G")
                multipartFormData.appendBodyPart(data: color_b, name: "color_B")
                if let unwrappedStampImage = stampImage {
                    multipartFormData.appendBodyPart(data: unwrappedStampImage, name: "stamp_image", fileName: "image.png", mimeType: "image/png")
                }
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        guard response.result.error == nil else {
                            print(response.result.error)
                            return
                        }
                        let json = JSON(response.result.value!)
                        let calendar = Calendar(json: json)
                        let calendarManager = CalenderManager.sharedInstance
                        calendarManager.calendarCollection.append(calendar)
                        print(calendarManager.calendarCollection.append(calendar))
                        
                    }
                case .Failure(let encodingError):
                    // Add error handling in the future
                    print(encodingError)
                }
                callback()
            }
        )
    }
    
}
