//
//  UIStroryBoard+Extension.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/22.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func viewControllerWith(boardName: String, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: boardName, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
}
