//
//  StampedDate.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/06/30.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class StampedDate: NSObject {
    
    let id: Int
    let date: NSDate
    
    init(id: Int, date: NSDate) {
        self.id = id
        self.date = date
    }

}
