//
//  UserInvitationCollectionViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/31.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class UserInvitationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    let onReuseBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.onReuseBag.dispose()
    }
    
    func fillWith(user: User) {
        userAvatarImageView.sd_setImageWithURL(NSURL(string: user.avatarUrl))
        userNameLabel.text = user.name
    }
    
    private func setUp() {
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
        userAvatarImageView.clipsToBounds = true
    }

}
