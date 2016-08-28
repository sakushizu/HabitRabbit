//
//  TopViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/16.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class TopViewController: UIViewController {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    private var isLogin = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutButton()
    }
    
    @IBAction func tappedFacebookButton(sender: UIButton) {
        tappedFacebookLoginButton()
    }
    
    @IBAction func tappedSignupButton(sender: UIButton) {
        let createCalenderVC = UIStoryboard.viewControllerWith("UserSession", identifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(createCalenderVC, animated: true)
    }
    
    @IBAction func tappedLoginButton(sender: UIButton) {
        let createCalenderVC = UIStoryboard.viewControllerWith("UserSession", identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(createCalenderVC, animated: true)
    }
    
    private func tappedFacebookLoginButton() {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result, error) in
            guard error == nil else {
                return
            }
            guard !result.isCancelled else {
                return
            }
            User.getUserData({
                let controller = CalendarTopViewController()
                let navigationController = UINavigationController(rootViewController: controller)
                self.presentViewController(navigationController, animated: true, completion: nil)
                CalenderManager.sharedInstance.fetchCalendars(completion: { })
            })
        }
        self.isLogin = !self.isLogin
    }
    
    private func setLayoutButton() {
        facebookButton.layer.cornerRadius = 5
        facebookButton.layer.masksToBounds = true
        signupButton.layer.cornerRadius = 5
        signupButton.layer.masksToBounds = true
    }
}
