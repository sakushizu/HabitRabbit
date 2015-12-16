//
//  FaceBookTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/17.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class FaceBookTableViewCell: UITableViewCell {

    @IBOutlet weak var faceBookLabel: UILabel!
    @IBOutlet weak var facebookImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor(red: 60/255, green: 90/255, blue: 152/255, alpha: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
