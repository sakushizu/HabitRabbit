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
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var takePhotoBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

        // Configure the view for the selected state
    }
    
}
