//
//  RankingTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/22.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {

    @IBOutlet weak var rankingNumLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
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
