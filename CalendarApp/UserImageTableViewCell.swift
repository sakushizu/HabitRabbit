//
//  UserImageTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/17.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class UserImageTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUserImageView()
    }
    
    func fillWith(selectedImage: UIImage, name: String) {
        userImageView.image = selectedImage
        userNameTextField.text = name
    }
    
    func tappedUserImage() {
        let notification = NSNotificationCenter.defaultCenter()
        notification.postNotificationName("tappedUserImageNotification", object: nil)
    }
    
    private func setUserImageView() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.userInteractionEnabled = true
        let tappedUserImageGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedUserImage))
        userImageView.addGestureRecognizer(tappedUserImageGesture)
    }

    
}
