//
//  CreateCell3.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/12.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CreateCell3: UITableViewCell {

    @IBOutlet weak var selectColorBtn: UIButton!
    @IBOutlet weak var selectedColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectColorBtn.contentHorizontalAlignment = .Left
        
        let priorityIcon = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        selectedColorView.layer.cornerRadius = priorityIcon.frame.width / 2

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
