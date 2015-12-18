//
//  LoginViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/16.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let images = ["User", "Lock"]
    let placeholderTexts = ["Username", "Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "CreateUserTableViewCell", bundle: nil), forCellReuseIdentifier: "createUserCell")
        tableView.registerNib(UINib(nibName: "OrViewTableViewCell", bundle: nil), forCellReuseIdentifier: "orCell")
        tableView.registerNib(UINib(nibName: "NextBtnTableViewCell", bundle: nil), forCellReuseIdentifier: "nextCell")
        tableView.registerNib(UINib(nibName: "FaceBookTableViewCell", bundle: nil), forCellReuseIdentifier: "faceBookCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) || (section == 1) {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("createUserCell", forIndexPath: indexPath) as! CreateUserTableViewCell
            cell.icon.image = UIImage(named: images[indexPath.row])
            cell.textField.placeholder = placeholderTexts[indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            let nextCell = tableView.dequeueReusableCellWithIdentifier("nextCell", forIndexPath: indexPath) as! NextBtnTableViewCell
            nextCell.nextLabel.text = "Done"
            return nextCell
        } else if indexPath.section == 2 {
            let orCell = tableView.dequeueReusableCellWithIdentifier("orCell", forIndexPath: indexPath) as! OrViewTableViewCell
            return orCell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("faceBookCell", forIndexPath: indexPath) as! FaceBookTableViewCell
            cell.faceBookLabel.text = "Log In With Facebook"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            
            let nameCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! CreateUserTableViewCell
            let passwordCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! CreateUserTableViewCell
            if nameCell.textField.text!.isEmpty || passwordCell.textField.text!.isEmpty {
//                showAlert("User name or password is empty")
            } else {
                let user = User(name: nameCell.textField.text!, password: passwordCell.textField.text!)
                user.login { (message) in
                    if message == nil {
                        print("login")
                        self.performSegueWithIdentifier("calendar", sender: nil)
                    } else {
                        //self.showAlert(message)
                    }
                }
            }
        } else if indexPath.section == 3 {
            //facebookログイン
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navigationBarHeight = navigationController!.navigationBar.frame.height
        let cellsHeight: CGFloat = 65 * 4
        let cellsHeaderHeight: CGFloat = 50 * 2
        if indexPath.section == 2 {
            return self.tableView.frame.height - (statusBarHeight + navigationBarHeight + cellsHeight + cellsHeaderHeight)
        } else {
            return 65
        }
    }
    
    //アラート表示のメソッド
    func showAlert(message: String?) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }

}
