//
//  SignUpViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/16.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    let mModel = SignUpVM()
    var mView: SignUpView!
    private var imagePickerVC: UIImagePickerController!
    
    override func loadView() {
        self.view = SignUpView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! SignUpView
        mView.tableView.delegate = self
        mView.tableView.dataSource = mModel
        
        setSignUpButtonTarget()
        setImagePicker()
        setNotification()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowType = SignUPCellType(rawValue: indexPath.row)!
        switch rowType {
        case .ImageAndName:
            return 90
        case .Mail, .Password:
            return 60
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage? {
            mModel.selectedImage = pickedImage
            mView.tableView.reloadData()
        }
        imagePickerVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tappedSignUpButton() {
        if mModel.nameText.value!.isEmpty || mModel.mailText.value!.isEmpty || mModel.passwordText.value!.isEmpty {
            let alert = UIAlertController.alertWith(message: "Exsist Empty TextField")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        signUp()
    }
    
    func userImageNotification(notification: NSNotification) {
        showImagePickActionSheet()
    }
    
    private func setNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.userImageNotification(_:)),
            name: "tappedUserImageNotification",
            object: nil
        )
    }
    
    private func showImagePickActionSheet() {
        
        let actionSheet = UIAlertController(
            title:"Select UserImage Photo",
            message: nil,
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil
        )
        
        let choosePhotoAction = UIAlertAction(
            title: "Choose from library",
            style: UIAlertActionStyle.Default,
            handler: { action in
                self.imagePickerVC.sourceType = .PhotoLibrary
                self.imagePickerVC.allowsEditing = true
                self.presentViewController(self.imagePickerVC, animated: true, completion: nil)
            }
        )
        
        let takePhotoAction = UIAlertAction(
            title: "Take photo",
            style: UIAlertActionStyle.Default,
            handler: { action in
                guard UIImagePickerController.isSourceTypeAvailable(.Camera) else {
                    return
                }
                self.imagePickerVC.sourceType = .Camera
                self.imagePickerVC.allowsEditing = true
                self.presentViewController(self.imagePickerVC, animated: true, completion: nil)
            }
        )
        
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(choosePhotoAction)
        actionSheet.addAction(takePhotoAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    private func setImagePicker() {
        imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
    }
    
    
    private func setSignUpButtonTarget() {
        mView.signUpButton.addTarget(self, action: #selector(self.tappedSignUpButton), forControlEvents: .TouchUpInside)
    }
    
    private func signUp() {
        
        let params: [String:AnyObject] = [
            "name": mModel.nameText.value!,
            "password": mModel.passwordText.value!,
            "mail": mModel.mailText.value!,
            "avatar": mModel.selectedImage!
        ]
        User.signUpRails(params, completion: {
            UserInvitationManager.sharedInstance.fetchInvitationCalendars(completion: { })
            CalenderManager.sharedInstance.fetchCalendars(completion: { })
            let controller = CalendarTopViewController()
            let navigationController = UINavigationController(rootViewController: controller)
            self.presentViewController(navigationController, animated: true, completion: nil)
        })
    }
    
}
