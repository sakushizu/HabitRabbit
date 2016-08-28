//
//  LoginViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/16.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    let mModel = LoginVM()
    var mView: LoginView!
    private var imagePickerVC: UIImagePickerController!
    
    override func loadView() {
        self.view = LoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! LoginView
        mView.tableView.delegate = self
        mView.tableView.dataSource = mModel
        
        setSignUpButtonTarget()

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 60
    }
    
    func tappedSignUpButton() {
        if mModel.mailText.value!.isEmpty || mModel.passwordText.value!.isEmpty {
            let alert = UIAlertController.alertWith(message: "Exsist Empty TextField")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        login()
    }
    
    private func setSignUpButtonTarget() {
        mView.loginButton.addTarget(self, action: #selector(self.tappedSignUpButton), forControlEvents: .TouchUpInside)
    }
    
    private func login() {
        
        let params: [String:AnyObject] = [
            "user":[
                "password": mModel.passwordText.value!,
                "email": mModel.mailText.value!
            ]
        ]
        User.firstLoginRails(params, completion: {
            UserInvitationManager.sharedInstance.fetchInvitationCalendars(completion: { })
            CalenderManager.sharedInstance.fetchCalendars(completion: { })
            let controller = CalendarTopViewController()
            let navigationController = UINavigationController(rootViewController: controller)
            self.presentViewController(navigationController, animated: true, completion: nil)
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
