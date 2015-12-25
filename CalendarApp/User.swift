//
//  User.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/17.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Parse

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
    
    func update(callback: (message: String?) -> Void){
        print(CurrentUser.sharedInstance.user.name)
        print(CurrentUser.sharedInstance.user.password)
        PFUser.logInWithUsernameInBackground(CurrentUser.sharedInstance.user.name, password: CurrentUser.sharedInstance.user.password) { (currentUser, error) -> Void in
            if error == nil {
                currentUser?.username = "mochimochi"
                currentUser?.password = "mochimochi"
                currentUser?["mailAddress"] = "mochimochi"
                currentUser?.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil {
                        print("updateに成功しました。")
                        callback(message: error?.userInfo["error"] as? String)
                    }
                })
             }
        }
    }
}
