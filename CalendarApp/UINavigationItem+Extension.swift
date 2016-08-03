//
//  UINavigationBar+Extension.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/03.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    func leftBarButtonItem(title: String, target: AnyObject, action: Selector) {
        self.leftBarButtonItem = UIBarButtonItem(title: title, style: .Done, target: target, action: action)
    }
    
    func rightBarButtonItem(title: String, target: AnyObject, action: Selector) {
        self.rightBarButtonItem = UIBarButtonItem(title: title, style: .Done, target: target, action: action)
    }
    
    
    func leftImageButtonItem(image: String, target: AnyObject, action: Selector) {
        self.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: image), style: .Plain, target: target, action: action)
    }
    
    func rightImageButtonItem(image: String, target: AnyObject, action: Selector) {
        self.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: image), style: .Plain, target: target, action: action)
    }
    

}
