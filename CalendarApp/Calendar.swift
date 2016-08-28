//
//  Calender.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/25.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import SwiftyJSON

class Calendar: NSObject, NSCopying {
    
    var id: Int
    var title: String
    var color_r: Int
    var color_g: Int
    var color_b: Int
    var stampImageURL: String
    var orner: User!

    var joinedUsers = [User]()
    var invitingUsers = [User]()

    init(json: JSON) {
        self.id = json["id"].int!
        self.title = json["title"].string!
        self.color_r = json["color_R"].int!
        self.color_g = json["color_G"].int!
        self.color_b = json["color_B"].int!
        self.stampImageURL = json["stamp_image"].string!
        self.orner = User(jsonWithUser: json["user"])
    }
    
    init(id: Int, title: String, color_r: Int, color_g: Int, color_b: Int, stampImageURL: String, orner: User, joinedUsers: [User], invitingUsers: [User]) {
        self.id = id
        self.title = title
        self.color_r = color_r
        self.color_g = color_g
        self.color_b = color_b
        self.stampImageURL = stampImageURL
        self.orner = orner
        self.joinedUsers = joinedUsers
        self.invitingUsers = invitingUsers
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Calendar(id: id, title: title, color_r: color_r, color_g: color_g, color_b: color_b, stampImageURL: stampImageURL, orner: orner, joinedUsers: joinedUsers, invitingUsers: invitingUsers)
        return copy
    }

    
 

}















