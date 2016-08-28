//
//  EditUsersViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/11.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class EditUsersViewController: UIViewController, UITableViewDelegate {
    
    var mView: EditUserView!
    let mModel = EditUsersVM()
    
    override func loadView() {
        self.view = EditUserView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! EditUserView
        mView.tableView.dataSource = mModel
        mView.tableView.delegate = self
        
        setUpNavigationController()
        
        mView.userInvitationButton.addTarget(self, action: #selector(self.tappedUserInvitationButton), forControlEvents: .TouchUpInside)
        
        mModel.selectedCalendar.observe { users in
            self.mView.tableView.reloadData()
        }
        setNotification()

    }
    
    override func viewWillAppear(animated: Bool) {
        setNavigationBar()
    }
    
    // MARK - TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionType = EditUsersTableViewSectionType(rawValue: section)!
        let header = createHeaderView()

        switch sectionType {
            
        case .Owner:
            let label = createHeaderLabel("Owner")
            header.addSubview(label)
            return header
        case .Members:
            let label = createHeaderLabel("Members")
            header.addSubview(label)
            return header
        case .InvitationUsers:
            let label = createHeaderLabel("InvitationUsers")
            header.addSubview(label)
            return header
        }

    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        mView.tableView.setEditing(editing, animated: true)
    }
    

    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if mView.tableView.editing {
            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.None
        }
    }
    
    func tappedUserInvitationButton() {
        let params = ["calendar_id": mModel.selectedCalendar.value!.id]
        UserInvitationManager.sharedInstance.notJoinUsers(params,
            completion: {
                let controller = UIStoryboard.viewControllerWith("CreateCalendar", identifier: "UserInvitationViewController") as! UserInvitationViewController
                let navigationController = UINavigationController(rootViewController: controller)
                controller.mModel.selectedUsers.value = self.mModel.selectedCalendar.value!.invitingUsers
                self.presentViewController(navigationController, animated: true, completion: nil)
            }, fail: {
                API.fail(self)
            }
        )
    }
    
    func tappedOKButton() {
        let users: [User] = mModel.selectedCalendar.value!.joinedUsers + mModel.selectedCalendar.value!.invitingUsers
        let selectUserNotification = NSNotification(name: "selectUserNotification", object: self, userInfo: ["users": users])
        
        NSNotificationCenter.defaultCenter().postNotification(selectUserNotification)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setUsersForUserEditVMNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo!["users"] as? [User]! {
            self.mModel.selectedCalendar.value?.invitingUsers = userInfo
            self.mView.tableView.reloadData()
        }
    }
    
    private func setNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.setUsersForUserEditVMNotification(_:)),
            name: "setUsersForUserEditVMNotification",
            object: nil
        )
    }
    
    private func createHeaderView() -> UIView {
        let header = UIView()
        header.backgroundColor = UIColor.baseGrayColor()
        return header
    }
    
    private func createHeaderLabel(titleText: String) -> UILabel {
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.mainFontJa(14)
        label.sizeToFit()
        label.center.y = 20
        label.frame.origin.x = 20
        label.textColor = UIColor.textColor()
        return label
    }
    
    
    // MARK - NavigationController
    
    private func setUpNavigationController() {
        self.navigationItem.leftBarButtonItem = editButtonItem()
        setRightBarButton()
    }
    
    
    private func setRightBarButton() {
        let button: UIButton = UIButton(type: .System)
        button.frame = CGRectMake(0, 0, 80, 40)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        button.addTarget(self, action: #selector(self.tappedOKButton), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        button.setTitle("OK", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.mainColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.mainFontJaRegular(16)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0)
    }
    
    private func setNavigationBar() {
        self.navigationController?.hidesNavigationBarHairline = true
        self.navigationController?.navigationBar.tintColor = UIColor.mainColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mainColor()]
        self.navigationItem.title = "Edit Members"

    }
}
