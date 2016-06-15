//
//  CalendarTheenColor.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/06/09.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalendarThemeColor: NSObject {
    var color: UIColor
    var r: Int
    var g: Int
    var b: Int
    
    init(r: Int, g: Int, b: Int) {
        self.r = r
        self.g = g
        self.b = b
        
        self.color = UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
    
}
