//
//  EditUserTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/11.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class EditUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpUserImageView()
        
    }
    
    private func setUpUserImageView() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
    }
    
    func fillWith(user: User) {
        userImageView.sd_setImageWithURL(NSURL(string: user.avatarUrl))
        userNameLabel.text = user.name
    }
    
    

    
}
