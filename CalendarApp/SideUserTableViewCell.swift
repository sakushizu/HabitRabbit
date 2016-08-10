//
//  sideUserTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/23.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class SideUserTableViewCell: UITableViewCell {


    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        setUpUserImageView()
        setUpNameLabel()
    }
    
    private func setUpUserImageView() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
        userImageView.sd_setImageWithURL(NSURL(string: CurrentUser.sharedInstance.user.value!.avatarUrl))
    }
    
    private func setUpNameLabel() {
        nameLabel.text = CurrentUser.sharedInstance.user.value!.name
    }

}
