//
//  UserTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/20.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUserImageView()
        self.selectionStyle = .None
        
    }
    
    func fillWith(user: User) {
        userNameLabel.text = user.name
        userImageView.sd_setImageWithURL(NSURL(string: user.avatarUrl))
    }
    
    private func setUserImageView() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
    }

    
}
