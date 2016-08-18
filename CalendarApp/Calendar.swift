//
//  Calender.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/25.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import SwiftyJSON

class Calendar: NSObject {
    
    
    //カレンダーの情報をもつ辞書型
    var selectedDates: Dictionary<NSDate, String> = [:]
    var id: Int
    var title: String
    var color_r: Int
    var color_g: Int
    var color_b: Int
    var stampImageURL: String
    var orner: User
//    var joinedUsersWithOwner = [User]()
    var joinedUsers = [User]()
    var invitingUsers = [User]()
    
    var memo = ""
    
    var object_id: String = ""
    var password: String = ""
    
    var type: String = ""
    
    var defaultsCalendarTitle = ""
    
    
    init(json: JSON) {
        self.id = json["id"].int!
        self.title = json["title"].string!
        self.color_r = json["color_R"].int!
        self.color_g = json["color_G"].int!
        self.color_b = json["color_B"].int!
        self.stampImageURL = json["stamp_image"].string!
        self.orner = User(jsonWithUser: json["user"])
    }

    
 

}















