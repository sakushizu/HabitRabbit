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
    
    init(name: String, password: String) {
        self.name = name
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
    
    func signUp(callback: (message: String?) -> Void) {
    let user = PFUser()
        user.username = name
        user.password = password
        user["mailAddress"] = mailAddress
        user["image"] = userImage!.createFileForm()
        user.signUpInBackgroundWithBlock { (success, error) in
            callback(message: error?.userInfo["error"] as? String)
        }
    }
    
    func login(callback: (message: String?) -> Void) {
        PFUser.logInWithUsernameInBackground(self.name, password: self.password) { (user, error) -> Void in
            if let PFCurrentUser = PFUser.currentUser() {
                CurrentUser.sharedInstance.user = User(objectId: PFCurrentUser.objectId!, name: PFCurrentUser.username!)
                let userImageFile = PFCurrentUser["image"] as! PFFile
                userImageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                    if error == nil {
                        CurrentUser.sharedInstance.user.userImage = UIImage(data: imageData!)
                    }
                })
                callback(message: nil)
            } else {
                callback(message: error?.userInfo["error"] as? String)
            }
        }
        
    }
    
    // RailsSignUp
    class func signUpRails(user: User) {
        
        let params: [String: AnyObject] = [
            "user": [
                "name": user.name,
                "email": user.mailAddress,
                "password": user.password,
                "password_confirmation": user.password
            ]
        ]
        
        // HTTP通信
        Alamofire.request(.POST, "http://localhost:3000/users.json", parameters: params, encoding: .URL)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // Alert
                    return
                }
                
                guard let responseValue = response.result.value else {
                    return
                }
                
                _ = JSON(responseValue)
            }
        
    }
    
    //RailsLogin
    class func loginRails(tokenDic: Dictionary<String, String>) {
        
        let params: [String: AnyObject] = [
            "token": tokenDic["auth"]!,
            "email": tokenDic["email"]!
        ]
        
        // HTTP通信
        Alamofire.request(.POST, "http://localhost:3000/users/sign_in.json", parameters: params, encoding: .URL)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // Alert
                    return
                }
                
                guard let responseValue = response.result.value else {
                    return
                }
                
                let responseJSON = JSON(responseValue)
                let name = responseJSON["name"].stringValue
                let email = responseJSON["email"].stringValue
                let user = User.init(name: name, mail: email)
                CurrentUser.sharedInstance.user = user
                CurrentUser.sharedInstance.authentication_token = responseJSON["authentication_token"].stringValue
        }
        
    }
    
    class func firstLoginRails(user: User) {
        
        let params: [String: AnyObject] = [
            "user": [
                "name": user.name,
                "password": user.password
            ]
        ]
        
        // HTTP通信
        Alamofire.request(.POST, "http://localhost:3000/users/sign_in.json", parameters: params, encoding: .URL)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // Alert
                    return
                }
                
                guard let responseValue = response.result.value else {
                    return
                }
                
                let responseJSON = JSON(responseValue)
                let name = responseJSON["name"].stringValue
                let email = responseJSON["email"].stringValue
                let user = User.init(name: name, mail: email)
                CurrentUser.sharedInstance.user = user
                
                CurrentUser.sharedInstance.authentication_token = responseJSON["authentication_token"].stringValue
                self.saveAuthenticationToken()

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
    
    
    class func getUserData(){
        let graphRequest = FBSDKGraphRequest(graphPath: "me",
                                             parameters: ["fields": "id,name"])
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) in
            guard error == nil && result != nil else{
                print("Error: \(error)")
                return
            }
            
            print("User: \(result)")
        })
    }
    
    
    func update(callback: (message: String?) -> Void){
        _ = PFUser.currentUser()
    }
}
