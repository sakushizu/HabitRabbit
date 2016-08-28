//
//  EditCalendarViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/10.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit


class EditCalendarViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    var mModel = EditCalendarVM()
    private var mView: EditCalendarView!
    private var imagePickerVC: UIImagePickerController!
    private var stampCollectionView = StampCollectionView()
    private var selectedUserCollectionVM = SelectedUserCollectionVM()
    private var stampViewCount = StampViewType.Down
    private let userInvitationManager = UserInvitationManager.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! EditCalendarView
        mView.tableView.dataSource = mModel

        mView.tableView.delegate = self
        mView.updateButton.addTarget(self, action: #selector(EditCalendarViewController.clickUpdateButton(_:)), forControlEvents: .TouchUpInside)
        
        setImagePicker()
        setNotification()
        mView.addSubview(stampCollectionView)

        setNabiBarItem()
        
        mModel.selectStampImage.observe { image in
            self.mView.tableView.reloadData()
        }
        
        mModel.selectedCalendar.observe { calendar in
            self.mView.tableView.reloadData()
        }
        
        mModel.setUpCalendar()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setNavigationBar()
    }
    
        
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowType = RowType(rawValue: indexPath.row)!
        
        switch rowType {
        case .TitleCell, .ColorCell, .UserCell:
            return 50
            
        case .StampCell:
            return 90
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowType = RowType(rawValue: indexPath.row)!
        
        if rowType == .ColorCell {
            
            let colorTableVC = UIStoryboard.viewControllerWith("CreateCalendar", identifier: "colorTableViewController") as! ColorTableViewController
            colorTableVC.color = mModel.selectColor.color
            self.navigationController?.pushViewController(colorTableVC, animated: true)
            
        } else if rowType == .UserCell {
            
            let controller = EditUsersViewController()
            controller.mModel.selectedCalendar = self.mModel.selectedCalendar
            let navigationController = UINavigationController(rootViewController: controller)
            self.presentViewController(navigationController, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage? {
            mModel.selectStampImage.value = pickedImage
            mView.tableView.reloadData()
        }
        
        imagePickerVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clickUpdateButton(sender: UIButton) {
        
        if mModel.titleText.value! == "" {
            let alert = UIAlertController.alertWith(message: "Title is empty!")
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let controller = UIStoryboard.viewControllerWith("Calendar", identifier: "CalendarViewController") as! CalendarViewController
            self.save(controller)
        }
    }
    
    //MARK: -> notification
    
    func stampImageNotification(notification: NSNotification) {
        showImagePickActionSheet()
    }
    
    func closeStampImageNotification(notification: NSNotification) {
        self.setStampController()
    }
    func selectStampNotification(notification: NSNotification) {
        let indexPath = NSIndexPath(forRow: RowType.StampCell.rawValue, inSection: 0)
        if let userInfo = notification.userInfo {
            mModel.selectStampImage.value = userInfo["stampImage"] as? UIImage
            mView.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    func selectColorNotification(notification: NSNotification) {
        let indexPath = NSIndexPath(forRow: RowType.ColorCell.rawValue, inSection: 0)
        if let userInfo = notification.userInfo {
            mModel.selectColor = (userInfo["color"] as? CalendarThemeColor)!
            mView.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            mView.tableView.reloadData()
        }
    }
    func setInvitedUsers(notification: NSNotification) {
        if let userInfo = notification.userInfo!["invitedUsers"] as? [User]! {
            self.mModel.selectedCalendar.value?.invitingUsers = userInfo
            mView.tableView.reloadData()
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CreateCalendarViewController.stampImageNotification(_:)),
            name: "tappedStampImageNotification",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CreateCalendarViewController.closeStampImageNotification(_:)),
            name: "closeStampImageNotification",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CreateCalendarViewController.selectStampNotification(_:)),
            name: "selectStampNotification",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CreateCalendarViewController.selectColorNotification(_:)),
            name: "selectColorNotification",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.setInvitedUsers(_:)),
            name: "setInvitedUsersNotification",
            object: nil
        )
    }
    
    
    
    private func showImagePickActionSheet() {
        
        let actionSheet = UIAlertController(
            title:"Select Stamp Icon",
            message: nil,
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil
        )
        
        let choosePhotoAction:UIAlertAction = UIAlertAction(
            title: "Choose from library",
            style: UIAlertActionStyle.Default,
            handler: { action in
                self.imagePickerVC.sourceType = .PhotoLibrary
                self.imagePickerVC.allowsEditing = true
                self.presentViewController(self.imagePickerVC, animated: true, completion: nil)
            }
        )
        
        let takePhotoAction:UIAlertAction = UIAlertAction(
            title: "Take photo",
            style: UIAlertActionStyle.Default,
            handler: { action in
                self.imagePickerVC.sourceType = .Camera
                self.imagePickerVC.allowsEditing = true
                self.presentViewController(self.imagePickerVC, animated: true, completion: nil)
            }
        )
        
        let chooseStampAction:UIAlertAction = UIAlertAction(
            title: "Choose from Stamps",
            style: UIAlertActionStyle.Default,
            handler: { action in
                self.setStampController()
            }
        )
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(choosePhotoAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(chooseStampAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    private func setImagePicker() {
        imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
    }
    
    private func setStampController() {
        stampBtn()
    }
    //MARK: -> StampCollectionView表示切り替え
    private func stampBtn() {
        if stampViewCount == .Down {
            stampViewCount = .Up
            UICollectionView.animateWithDuration(0.3) {
                self.stampCollectionView.frame.origin = CGPointMake(0, self.view.frame.height - 300)
            }
        } else {
            stampViewCount = .Down
            UICollectionView.animateWithDuration(0.3) {
                self.stampCollectionView.frame.origin = CGPointMake(0, self.view.frame.height)
            }
        }
    }
    
    private func save(calendarVC: CalendarViewController) {

        let params: [String: AnyObject] = [
            "title": mModel.titleText.value!,
            "stamp": mModel.selectStampImage.value!,
            "color_r": mModel.selectColor.r,
            "color_g": mModel.selectColor.g,
            "color_b": mModel.selectColor.b,
            "invitationUser_ids": setUserIdArray(mModel.selectedCalendar.value!.invitingUsers),
            "joined_ids": setUserIdArray(mModel.selectedCalendar.value!.joinedUsers),
            "calendar_id": mModel.selectedCalendar.value!.id
        ]
        
        CalenderManager.sharedInstance.upDateCalendar(params, completion: {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    private func setUserIdArray(users: [User]) -> String {
        var userIdArray = [String]()
        for user in users {
            userIdArray.append(user.id.description)
        }
        let userIds = userIdArray.joinWithSeparator(",")
        return userIds
    }
    
    func tappedCancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setNabiBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.tappedCancelButton))
    }
    
    private func setNavigationBar() {
        self.navigationController?.hidesNavigationBarHairline = true
        self.navigationController?.navigationBar.tintColor = UIColor.mainColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mainColor()]
        navigationItem.title = "Edit Calendar"
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
    }
    
}
