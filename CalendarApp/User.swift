
//
//  User.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/17.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class User: NSObject {
    
//    static let sharedInstance = User(name: "guest", password: "guest")
    
    //ログインしていない場合は、guestが入る
    var type: String!
    
    var objectId: String!
    
    var name: String!
    var password: String!
    var mailAddress: String!
    var userImage: UIImage!
    
    init(name: String, password: String, mailAddress: String, userImage: UIImage) {
        self.name = name
        self.password = password
        self.mailAddress = mailAddress
        self.userImage = userImage
    }
    
    init(objectId: String, name: String) {
        self.objectId = objectId
        self.name = name
    }
    
    init(email: String, password: String) {
        self.mailAddress = email
        self.password = password
    }
    
    init(name: String, mail: String) {
        self.name = name
        self.mailAddress = mail
    }
    
    init(objectId: String, name: String, password: String, mailAddress: String) {
        self.objectId = objectId
        self.name = name
        self.password = password
        self.mailAddress = mailAddress
    }
        
    // RailsSignUp
    class func signUpRails(user: User) {
        
        let params: [String: AnyObject] = [
            "user": [
                "name": user.name,
                "email": user.mailAddress,
                "password": user.password,
                "password_confirmation": user.password,
            ]
        ]
        
        // HTTP通信
        Alamofire.request(
            .POST,
            "http://localhost:3000/users.json",
            parameters: params,
            encoding: .URL
            ).responseJSON { response in
                
                guard response.result.error == nil else {
                    // Alert
                    return
                }
                
                guard (response.result.value != nil) else {
                    return
                }
            }
        
    }
    
    //RailsLogin(outh取得済み)
    class func loginRails(tokenDic: Dictionary<String, String>, callback: () -> Void) {
        
        let token = tokenDic["auth"]! as String
        // HTTP通信
        Alamofire.request(
            .POST,
            "http://localhost:3000/user_sessions/create_with_token.json",
            parameters: nil,
            headers: ["access_token": token],
            encoding: .URL
            ).responseJSON { response in
                guard response.result.error == nil else {
                    print("result.error")
                    // Alert
                    return
                }
                guard let responseValue = response.result.value else {
                    print("responseValue")
                    return
                }

                let responseJSON = JSON(responseValue)
                let name = responseJSON["user"]["name"].stringValue
                let email = responseJSON["user"]["email"].stringValue
                let user = User(name: name, mail: email)
                CurrentUser.sharedInstance.user = user
                
                CurrentUser.sharedInstance.authentication_token = responseJSON["access_token"].stringValue
                callback()
        }
    }
    
    class func firstLoginRails(user: User, callback: () -> Void) {
        
        let params: [String: AnyObject] = [
            "user": [
                "email": user.mailAddress,
                "password": user.password
            ]
        ]
        
        // HTTP通信
        
        Alamofire.request(
            .POST,
            "http://localhost:3000/user_sessions.json",
            parameters: params,
            encoding: .JSON
            ).responseJSON { response in
                guard response.result.error == nil else {
                    // Alert
                    return
                }
                
                guard let responseValue = response.result.value else {
                    return
                }
                
                let responseJSON = JSON(responseValue)
                let name = responseJSON["user"]["name"].stringValue
                let email = responseJSON["user"]["email"].stringValue
                let user = User(name: name, mail: email)
                CurrentUser.sharedInstance.user = user
                
                CurrentUser.sharedInstance.authentication_token = responseJSON["access_token"].stringValue
                self.saveAuthenticationToken()
                callback()
        }
    }
    
    class func saveAuthenticationToken() {
        //tokenArray["auth": "sfdegdgfgfs", "email": "aaa@gmail.com"]
        var tokenDic = Dictionary<String, String>()
        tokenDic["auth"] = CurrentUser.sharedInstance.authentication_token
        tokenDic["email"] = CurrentUser.sharedInstance.user.mailAddress
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tokenDic, forKey: "tokenDic")
        defaults.synchronize()
    }
    
    
//    class func getUserData(){
//        let graphRequest = FBSDKGraphRequest(graphPath: "me",
//                                             parameters: ["fields": "id,name"])
//        
//        graphRequest.startWithCompletionHandler({ (connection, result, error) in
//            guard error == nil && result != nil else{
//                print("Error: \(error)")
//                return
//            }
//            
//            print("User: \(result)")
//        })
//    }
    
    func update(callback: (message: String?) -> Void){
    }
}
