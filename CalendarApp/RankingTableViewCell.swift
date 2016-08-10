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
    
    func fillWith(user: User) {
        self.userNameLabel.text = user.name
        self.userImageView.sd_setImageWithURL(NSURL(string: user.avatarUrl))
        //MARK Userが達成した日数
        self.recordLabel.text = "3complation"
        
    }
    
}
