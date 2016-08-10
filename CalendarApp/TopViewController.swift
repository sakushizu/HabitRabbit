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
        
        signUpBtn.layer.cornerRadius = 2
        signUpBtn.clipsToBounds = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.appPinkColor()
        
    }

    
    @IBAction func tappedSignUpBtn(sender: UIButton) {
        performSegueWithIdentifier("signup", sender: nil)
    }

    @IBAction func tappedLogInBtn(sender: UIButton) {
        performSegueWithIdentifier("login", sender: nil)
    }
    @IBAction func tappedSkipLogInBtn(sender: UIButton) {

    }

}
