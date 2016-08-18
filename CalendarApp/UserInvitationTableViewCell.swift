//
//  UserInvitationTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/31.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class UserInvitationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let checked = Observable<Bool>(false)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpCircleImageView()
        setUpAvatarImageView()
        
        self.checked.observe { checked in
            if checked {
                self.circleImageView.image = UIImage(named: "selectCircle")
            } else {
                self.circleImageView.image = UIImage(named: "unSelctCircle")
            }
            
        }
    }
    
    func fillWith(user: User) {
        avatarImageView.sd_setImageWithURL(NSURL(string: user.avatarUrl))
        nameLabel.text = user.name
    }
    
    func changeCircleImageView(isChecked: Bool) {
        checked.value = isChecked
    }
    
    private func setUpCircleImageView() {
        circleImageView.layer.cornerRadius = circleImageView.frame.width / 2
        circleImageView.layer.masksToBounds = true
    }
    
    private func setUpAvatarImageView() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
    }
}
