//
//  TopViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/16.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Parse

class TopViewController: UIViewController {

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var skipLogInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarManager = CalenderManager.sharedInstance
//        CalenderManager.sharedInstance.resetDefaults()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let tokenDic = defaults.objectForKey("tokenDic") as? Dictionary<String, String> {
            if tokenDic["auth"] == "" {
                return
            }
            User.loginRails(tokenDic, callback: {
                
                calendarManager.fetchCalendars(completion: {
                    
                  self.performSegueWithIdentifier("calendar", sender: nil)
                })
            })
        }
        
        signUpBtn.layer.cornerRadius = 2
        signUpBtn.clipsToBounds = true
        
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.appPinkColor()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        //アプリがアクティブになったとき
//        notificationCenter.addObserver(
//            self,
//            selector: #selector(UserInvitationManager.fetchInvitationCalendars()),
//            name:UIApplicationDidBecomeActiveNotification,
//            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedSignUpBtn(sender: UIButton) {
        performSegueWithIdentifier("signup", sender: nil)
    }

    @IBAction func tappedLogInBtn(sender: UIButton) {
        performSegueWithIdentifier("login", sender: nil)
    }
    @IBAction func tappedSkipLogInBtn(sender: UIButton) {
        performSegueWithIdentifier("calendar", sender: nil)
        CurrentUser.sharedInstance.type = "guest"
        let user = User(name: "guest", password: "00000000", mailAddress: "nil", userImage: UIImage(named: "user")!)
        CurrentUser.sharedInstance.user = user
    }

}
