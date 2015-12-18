//
//  CurrentUser.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/17.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CurrentUser: NSObject {
    static let sharedInstance = CurrentUser()
    var user: User!
}
