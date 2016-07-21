//
//  StampImageTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/10.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class StampImageTableViewCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var stampImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backGroundView.layer.cornerRadius = 10
        
        stampImageView.userInteractionEnabled = true
        let tappedStampImageGesture = UITapGestureRecognizer(target: self, action: #selector(StampImageTableViewCell.tappedStampImage))
        stampImageView.addGestureRecognizer(tappedStampImageGesture)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tappedStampImage() {
        let ns = NSNotificationCenter.defaultCenter()
        ns.postNotificationName("stampImageNotification", object: nil)
    }
    
}
