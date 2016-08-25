//
//  API.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/22.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class API: NSObject {
    
    class func fail(controller: UIViewController) {
        let loginViewController = UIStoryboard.viewControllerWith("UserSession", identifier: "LoginViewController") as! LoginViewController
        let alert = UIAlertController(title: "loginし直してください", message: "OK", preferredStyle: .Alert)
        let navigationContoeroller = UINavigationController(rootViewController: loginViewController)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            controller.presentViewController(navigationContoeroller, animated: true, completion: nil)
        }))
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
}
