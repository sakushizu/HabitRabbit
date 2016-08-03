//
//  UIAlertController+Extension.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/30.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func alertWith(message message: String?) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(OKAction)
        return alert
    }
}
