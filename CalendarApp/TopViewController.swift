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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpBtn.layer.cornerRadius = 2
        signUpBtn.clipsToBounds = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.appPinkColor()
        
    }

    
    @IBAction func tappedSignUpBtn(sender: UIButton) {
        let createCalenderVC = UIStoryboard.viewControllerWith("UserSession", identifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(createCalenderVC, animated: true)
    }

    @IBAction func tappedLogInBtn(sender: UIButton) {
        let createCalenderVC = UIStoryboard.viewControllerWith("UserSession", identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(createCalenderVC, animated: true)
    }

}
