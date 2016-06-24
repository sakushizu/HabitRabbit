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
    class func saveCalendarRails(calendar: Calendar, callback: () -> Void) {
        
        let currentUser = CurrentUser.sharedInstance
        
        let title = (calendar.title! as String).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_r = (String(calendar.color_r)).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_g = (String(calendar.color_g)).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_b = (String(calendar.color_b)).dataUsingEncoding(NSUTF8StringEncoding)!
        let stampImage = UIImagePNGRepresentation(calendar.image as UIImage)
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
                        
                    }
                case .Failure(let encodingError):
                    // Add error handling in the future
                    print(encodingError)
                }
                callback()
            }
        )
    }
        
//        let params: [String: AnyObject] = [
//            "title": calendar.title!,
//            "color_R": calendar.color_r,
//            "color_G": calendar.color_g,
//            "color_B": calendar.color_b,
//            "stampImage": UIImagePNGRepresentation(calendar.image as UIImage)!
//        ]
//        
//        // HTTP通信
//        Alamofire.request(
//            .POST,
//            "http://localhost:3000/api/calendars.json?email=\(currentUser.user.mailAddress)&token=\(currentUser.authentication_token)",
//            parameters: params,
//            encoding: .URL)
//            .responseJSON { response in
//            
//            print("=============request=============")
//            print(response.request)
//            print("=============response============")
//            print(response.response)
//            print("=============JSON================")
//            print(JSON(response.result.value!))
//            print("=============error===============")
//            print(response.result.error)
//            print("=================================")
//        }
//        
//    }

}
