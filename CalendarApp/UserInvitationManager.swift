//
//  UserInvitationManager.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/31.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Alamofire
import Bond
import SwiftyJSON

class UserInvitationManager: NSObject {
    
    static let sharedInstance = UserInvitationManager()
    
    let users = Observable<[User]>([])
    var calendars = Observable<[Calendar]>([])

    
    func fetchUsers(completion completion: () -> Void, fail: (() -> Void)?) {
        Alamofire.request(
            .GET,
            "\(Settings.ApiRootPath)/api/users/",
            headers: ["access_token": CurrentUser.sharedInstance.authentication_token.value]
            ).responseJSON { response in
                guard response.result.error == nil else {
                    // Add error handling in the future
                    print("Can't connect to the server: \(response.result.error!)")
                    return
                }
                
                let statusCode = response.response?.statusCode

                guard statusCode != 401 else {
                    fail!()
                    return
                }
                
                
                let json = JSON(response.result.value!)
                self.updateUsersFromJson(json)
                completion()
        }
    }
    
    func notJoinAndInvatedUsers(params: [String:Int], completion: () -> Void, fail: (() -> Void)?) {
        Alamofire.request(
            .GET,
            "\(Settings.ApiRootPath)/api/users/not_joined_users",
            parameters: params,
            headers: ["access_token": CurrentUser.sharedInstance.authentication_token.value]
            ).responseJSON { response in
                guard response.result.error == nil else {
                    // Add error handling in the future
                    print("Can't connect to the server: \(response.result.error!)")
                    return
                }
                
                let statusCode = response.response?.statusCode
                
                guard statusCode != 401 else {
                    fail!()
                    return
                }
                
                let json = JSON(response.result.value!)
                self.updateUsersFromJson(json)
                completion()
        }
    }
    
    func fetchInvitationCalendars(completion completion: () -> Void) {
        Alamofire.request(
            .GET,
            "\(Settings.ApiRootPath)/api/users/\(CurrentUser.sharedInstance.user.value!.id)/invitation_users",
            parameters: nil,
            headers: nil
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
        self.calendars.value = createCalendarsFromJson(calendarsJson)
    }
    

    
    func removeUser(user: User) {
        let index = self.users.value.indexOf(user)
        self.users.value.removeAtIndex(index!)
    }
    
    private func createUsersFromJson(json: JSON) -> [User] {
        var users = [User]()
        
        for (_, userJson) in json {
            let user = User(jsonWithUser: userJson)
            users.append(user)
        }
        
        return users
    }
    
    private func updateUsersFromJson(usersJson: JSON) {
        users.value = createUsersFromJson(usersJson)
    }

}
