//
//  AlertTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/04.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var alertTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpAvatarImageView()
    }
    
    private func setUpAvatarImageView() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
    }


    
}
