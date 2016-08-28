//
//  UserInvitationViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/30.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class UserInvitationViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate {
    
    let mModel = UserInvitaionVM()
    private var mView: UserInvitationView!
    private let userInvitationManager = UserInvitationManager.sharedInstance
    
    let editUserssVM = EditUsersVM()


    // MARK - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! UserInvitationView
        mView.tableView.dataSource = mModel
        mView.collectionView.dataSource = mModel
        mView.tableView.delegate = self
        mView.collectionView.delegate = self
        
        setUpNavigationController()
    }
    
    override func viewDidAppear(animated: Bool) {
        setBinding()
    }
    
    override func viewWillAppear(animated: Bool) {
        setNavigationBar()
    }

    // MARK - Initialize
    
    private func setBinding() {
        mModel.collectionViewIsAppearing.observe({ isAppearing in
            self.mView.toggleCollecionView(showing: isAppearing)
            self.mView.toggleTableViewHeight(collectionViewIsAppearing: isAppearing)
        })
        
        mModel.selectedUsers.observe { users in
            self.mView.tableView.reloadData()
            self.mView.collectionView.reloadData()
            self.mModel.collectionViewIsAppearing.value = users.count > 0
        }
    }
    
    // MARK - TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = createHeaderView()
        let label = createHeaderLabel()
        header.addSubview(label)
        
        return header
    }
    
    // MARK - TableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! UserInvitationTableViewCell
        
        let user = userInvitationManager.users.value[indexPath.row]
        
        mModel.conformUser(user)
        
        let isChecked = mModel.selectedUsers.value.contains(user)
        cell.changeCircleImageView(isChecked)

    }
    
    // MARK - CollectionViewDelegate

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK - NavigationBarButtonItem

    
    func onClickCancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onClickOkButton() {
        
        let setCollctionViewNotification = NSNotification(name: "setCollectionViewNotification", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(setCollctionViewNotification)
        
        let selectUserNotification = NSNotification(name: "selectUserNotification", object: self, userInfo: ["users": mModel.selectedUsers.value])
        NSNotificationCenter.defaultCenter().postNotification(selectUserNotification)
        
        let setUsersForUserEditVMNotification = NSNotification(name: "setUsersForUserEditVMNotification", object: self, userInfo: ["users": mModel.selectedUsers.value])
        NSNotificationCenter.defaultCenter().postNotification(setUsersForUserEditVMNotification)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    // MARK - NavigationController
    
    private func setUpNavigationController() {
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(UserInvitationViewController.onClickCancelButton))
        self.navigationItem.setLeftBarButtonItem(leftBarButton, animated: true)
        self.setRightBarButton()
    }
    
    
    private func setRightBarButton() {
        let button: UIButton = UIButton(type: .System)
        button.frame = CGRectMake(0, 0, 80, 40)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        button.addTarget(self, action: #selector(UserInvitationViewController.onClickOkButton), forControlEvents: .TouchUpInside)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        mModel.selectedUsers.observe { users in
            button.enabled = users.count > 0
            
            UIView.performWithoutAnimation {
                let buttonText = users.count > 0 ? "OK(\(users.count))" : "OK"
                button.setTitle(buttonText, forState: UIControlState.Normal)
                button.layoutIfNeeded()
            }
        }
        
        button.setTitleColor(UIColor.mainColor(), forState: .Normal)
        button.setTitleColor(.grayColor(), forState: .Disabled)
        button.titleLabel?.font = UIFont.mainFontJaRegular(16)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0)
    }
    
    private func createHeaderView() -> UIView {
        let header = UIView()
        header.backgroundColor = UIColor.baseGrayColor()
        return header

    }
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "User"
        label.font = UIFont.mainFontJa(14)
        label.sizeToFit()
        label.center.y = 20
        label.frame.origin.x = 20
        label.textColor = UIColor.textColor()
        return label
    }

    private func setNavigationBar() {
        self.navigationController?.hidesNavigationBarHairline = true
        self.navigationController?.navigationBar.tintColor = UIColor.mainColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mainColor()]
        navigationItem.title = "Select User"
    }


}
