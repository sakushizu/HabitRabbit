

//
//  User.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/17.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
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
    
    var id: Int!
    var name: String!
    var password: String!
    var mailAddress: String!
    var userImage: UIImage!
    var avatarUrl :String!
    
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
    
    init(name: String, mail: String, avatar_url: String) {
        self.name = name
        self.mailAddress = mail
        self.avatarUrl = avatar_url
    }
    
    init(objectId: String, name: String, password: String, mailAddress: String) {
        self.objectId = objectId
        self.name = name
        self.password = password
        self.mailAddress = mailAddress
    }
    
    init(jsonWithUser json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.mailAddress = json["email"].string
        self.avatarUrl = json["avatar"].string
    }
    
    // RailsSignUp
    class func signUpRails(user: User, callback: () -> Void) {
        
        let name = (user.name as String).dataUsingEncoding(NSUTF8StringEncoding)!
        let email = (user.mailAddress as String).dataUsingEncoding(NSUTF8StringEncoding)!
        let password = (user.password as String).dataUsingEncoding(NSUTF8StringEncoding)!
        let password_confirmation = (user.password as String).dataUsingEncoding(NSUTF8StringEncoding)!
        let avatar = UIImagePNGRepresentation(user.userImage as UIImage)
        // HTTP通信
        Alamofire.upload(
            .POST,
            "\(Settings.ApiRootPath)/api/users.json",
            headers: nil,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: name, name: "user[name]")
                multipartFormData.appendBodyPart(data: email, name: "user[email]")
                multipartFormData.appendBodyPart(data: password, name: "user[password]")
                multipartFormData.appendBodyPart(data: password_confirmation, name: "user[password_confirmation]")
                if let unwrappedAvatar = avatar {
                    multipartFormData.appendBodyPart(data: unwrappedAvatar, name: "user[avatar]", fileName: "avatar.png", mimeType: "image/png")
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
    

    
    //RailsLogin(outh取得済み)
    class func loginRails(tokenDic: Dictionary<String, String>, callback: () -> Void) {
        
        let token = tokenDic["auth"]! as String
        // HTTP通信
        Alamofire.request(
            .POST,
            "\(Settings.ApiRootPath)/api/user_sessions/create_with_token.json",
            parameters: nil,
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
                let user = User(jsonWithUser: json)
                CurrentUser.sharedInstance.user = user
                CurrentUser.sharedInstance.authentication_token = token
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
            "\(Settings.ApiRootPath)/api/user_sessions.json",
            parameters: params,
            encoding: .JSON
            ).responseJSON { response in
                guard response.result.error == nil else {
                    // Alert
                    return
                }
                
                guard let _ = response.result.value else {
                    return
                }
                
                let json = JSON(response.result.value!)
                let user = User(jsonWithUser: json)
                CurrentUser.sharedInstance.user = user
                CurrentUser.sharedInstance.authentication_token = json["access_token"].stringValue
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
    
    func logout() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var tokenDic = defaults.objectForKey("tokenDic") as? Dictionary<String, String>
        tokenDic!["auth"] = ""
        defaults.setObject(tokenDic, forKey: "tokenDic")
        defaults.synchronize()
        CurrentUser.sharedInstance.user = nil
    }
    
    
    class func getUserData(callback: () -> Void){
        let graphRequest = FBSDKGraphRequest(graphPath: "me",
                                             parameters: ["fields": "name, email, picture.type(large)"])
        var userInfo: NSDictionary!
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) in
            guard error == nil && result != nil else{
                print("Error: \(error)")
                return
            }
            
            print("User: \(result)")
            userInfo = result as! NSDictionary
            
            FBLogin(userInfo, callback: {
                callback()//TopViewに画面遷移
            })
        })
    }
    
    
    class func FBLogin(userInfo: NSDictionary, callback: () -> Void) {
        let name = userInfo.objectForKey("name") as! String
        let email = userInfo.objectForKey("email") as! String
        let avatar = userInfo.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String
        
        let params: [String: AnyObject] = [
            "user": [
                "email": email,
                "name": name,
                "avatar": avatar
            ]
        ]
        
        // HTTP通信
        
        Alamofire.request(
            .POST,
            "\(Settings.ApiRootPath)/api/users/create_with_FB.json",
            parameters: params,
            encoding: .JSON
            ).responseJSON { response in
                guard response.result.error == nil else {
                    // Alert
                    return
                }
                
                guard let _ = response.result.value else {
                    return
                }
                
                let json = JSON(response.result.value!)
                let user = User(jsonWithUser: json)
                CurrentUser.sharedInstance.user = user
                CurrentUser.sharedInstance.authentication_token = json["access_token"].stringValue
                self.saveAuthenticationToken()
                callback()
        }
    }
    
    func update(callback: (message: String?) -> Void){
    }
}
