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
    
    var usersStampedRanking = [User]()
    
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
    
    //新規カレンダー保存
    func saveCalendarRails(params: [String:AnyObject], completion: () -> Void) {
        
        let title = (params["title"]! as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_r = (String(params["color_r"]!)).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_g = (String(params["color_g"]!)).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_b = (String(params["color_b"]!)).dataUsingEncoding(NSUTF8StringEncoding)!
        let user_ids = (params["user_ids"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let stampImage = UIImagePNGRepresentation(params["stamp"] as! UIImage)
        // HTTP通信
        Alamofire.upload(
            .POST,
            "\(Settings.ApiRootPath)/api/calendars.json?",
            headers: ["access_token": CurrentUser.sharedInstance.authentication_token.value],
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: title, name: "title")
                multipartFormData.appendBodyPart(data: color_r, name: "color_R")
                multipartFormData.appendBodyPart(data: color_g, name: "color_G")
                multipartFormData.appendBodyPart(data: color_b, name: "color_B")
                multipartFormData.appendBodyPart(data: user_ids, name: "user_ids")
                
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
                        let calendar = Calendar(json: json["calendar"])
                        let calendarManager = CalenderManager.sharedInstance
                        calendarManager.calendarCollection.value.append(calendar)
                        
                        completion()
                        
                    }
                case .Failure(let encodingError):
                    // Add error handling in the future
                    print(encodingError)
                }
            }
        )
    }
    
    func upDateCalendar(params: [String:AnyObject], completion: () -> Void) {
        
        let title = (params["title"]! as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_r = (String(params["color_r"]!)).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_g = (String(params["color_g"]!)).dataUsingEncoding(NSUTF8StringEncoding)!
        let color_b = (String(params["color_b"]!)).dataUsingEncoding(NSUTF8StringEncoding)!
        let invitationUser_ids = (params["invitationUser_ids"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let joined_ids = (params["joined_ids"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let stampImage = UIImagePNGRepresentation(params["stamp"] as! UIImage)
        let calendar_id = params["calendar_id"] as! Int
        // HTTP通信
        Alamofire.upload(
            .PATCH,
            "\(Settings.ApiRootPath)/api/calendars/\(calendar_id)",
            headers: ["access_token": CurrentUser.sharedInstance.authentication_token.value],
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: title, name: "title")
                multipartFormData.appendBodyPart(data: color_r, name: "color_R")
                multipartFormData.appendBodyPart(data: color_g, name: "color_G")
                multipartFormData.appendBodyPart(data: color_b, name: "color_B")
                multipartFormData.appendBodyPart(data: invitationUser_ids, name: "invitationUser_ids")
                multipartFormData.appendBodyPart(data: joined_ids, name: "joined_ids")

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
                        let calendar = Calendar(json: json["calendar"])
                        let calendarManager = CalenderManager.sharedInstance
                        let index = calendarManager.calendarCollection.value.map({ $0.id }).indexOf(calendar.id)
                        calendarManager.calendarCollection.value[index!] = calendar
                        
                        let notification = NSNotification(name: "updateCalendarNotification", object: self, userInfo: ["calendar": calendar])
                        NSNotificationCenter.defaultCenter().postNotification(notification)
                        completion()
                }
                case .Failure(let encodingError):
                    // Add error handling in the future
                    print(encodingError)
                }
    
            }
            
        )

    }
    
    func joinCalendar(params: [String: Int], completion: () -> Void) {
        // HTTP通信
        Alamofire.request(
            .POST,
            "\(Settings.ApiRootPath)/api/users/\(CurrentUser.sharedInstance.user.value!.id)/calendar_users",
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
            .PATCH,
            "\(Settings.ApiRootPath)/api/users/\(CurrentUser.sharedInstance.user.value!.id)/calendar_users/reject",
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
            
            for (_, userJson) in calendarJson["joined_users"]  {
                let user = User(jsonWithUser: userJson)
                calendar.joinedUsers.append(user)
            }
            for (_, userJson) in calendarJson["inviting_users"]  {
                let user = User(jsonWithUser: userJson)
                calendar.invitingUsers.append(user)
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

