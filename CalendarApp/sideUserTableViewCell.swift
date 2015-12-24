//
//  sideUserTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/23.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class sideUserTableViewCell: UITableViewCell {


    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
