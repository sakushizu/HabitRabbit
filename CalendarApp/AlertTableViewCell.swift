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
        setUpAvatarImageView()
    }
    
    func fillWith(calendar: Calendar) {
        avatarImageView.sd_setImageWithURL(NSURL(string: calendar.orner.avatarUrl))
        alertTextLabel.text = "\(calendar.orner.name)さんより\(calendar.title)への招待が届いています。"
    }
    
    private func setUpAvatarImageView() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
        self.selectionStyle = .None
    }


    
}
