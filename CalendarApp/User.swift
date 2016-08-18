

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
    
    var id: Int!
    var name: String!
    var password: String!
    var mailAddress: String!
    var avatarUrl :String!
    

    init(jsonWithUser json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.mailAddress = json["email"].string
        self.avatarUrl = json["avatar"].string
    }
    
    // RailsSignUp
    class func signUpRails(params: [String:AnyObject], completion: () -> Void) {
        
        let name = (params["name"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let email = (params["mail"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let password = (params["password"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let password_confirmation = (params["password"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
        let avatar = UIImagePNGRepresentation(params["avatar"] as! UIImage)
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
                    completion()
            }
        )
    }
    

    
    //RailsLogin(outh取得済み)
    class func loginRails(token: String, completion: () -> Void) {
        
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
                CurrentUser.sharedInstance.user.value = user
                CurrentUser.sharedInstance.authentication_token.value = token
                completion()
        }
    }
    
    class func firstLoginRails(params: [String:AnyObject], completion: () -> Void) {
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
                CurrentUser.sharedInstance.user.value = user
                CurrentUser.sharedInstance.authentication_token.value = json["access_token"].stringValue
                self.saveAuthenticationToken()
                completion()
        }
    }
    
    class func saveAuthenticationToken() {
        var tokenDic = Dictionary<String, String>()
        tokenDic["auth"] = CurrentUser.sharedInstance.authentication_token.value
        tokenDic["email"] = CurrentUser.sharedInstance.user.value!.mailAddress
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
        CurrentUser.sharedInstance.user.value = nil
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
                CurrentUser.sharedInstance.user.value = user
                CurrentUser.sharedInstance.authentication_token.value = json["access_token"].stringValue
                self.saveAuthenticationToken()
                callback()
        }
    }
    
    func update(callback: (message: String?) -> Void){
    }
}
