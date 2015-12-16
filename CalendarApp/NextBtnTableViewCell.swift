//
//  NextBtnTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/16.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class NextBtnTableViewCell: UITableViewCell {

    @IBOutlet weak var nextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bgColor = self.contentView.backgroundColor
        self.backgroundColor = bgColor
        
        let nextIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        nextIcon.image = UIImage(named: "MoreThan")
        self.accessoryView = nextIcon
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
