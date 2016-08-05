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
    
    func fetchUsers(completion completion: () -> Void) {
        Alamofire.request(
            .GET,
            "\(Settings.ApiRootPath)/api/users/",
            headers: ["access_token": CurrentUser.sharedInstance.authentication_token!]
            ).responseJSON { response in
                guard response.result.error == nil else {
                    // Add error handling in the future
                    print("Can't connect to the server: \(response.result.error!)")
                    return
                }
                
                let json = JSON(response.result.value!)
                self.updateUsersFromJson(json["users"])
                completion()
        }
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
