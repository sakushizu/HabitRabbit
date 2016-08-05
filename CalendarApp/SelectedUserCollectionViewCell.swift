//
//  SelectedUserCollectionViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/03.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class SelectedUserCollectionViewCell: UICollectionViewCell {
    
    let iconImageView = UIImageView()

    
    override func layoutSubviews() {
        setUpIconImageView()
    }
    
    func fillWith(user: User) {
        iconImageView.sd_setImageWithURL(NSURL(string: user.avatarUrl))
    }
    
    private func setUpIconImageView() {
        let frame = CGRectMake(0, 5, 30, 30)
        iconImageView.frame = frame
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.layer.masksToBounds = true
        self.contentView.addSubview(iconImageView)

    }
    
    
}
