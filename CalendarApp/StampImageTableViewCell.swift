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
        
        setUpBackGroundView()
        setUpStampImageView()

    }

    func tappedStampImage() {
        let notification = NSNotificationCenter.defaultCenter()
        notification.postNotificationName("tappedStampImageNotification", object: nil)
    }
    
    func fillWith(selectStampImage: UIImage?) {
        self.stampImageView.image = selectStampImage
    }
    
    private func setUpBackGroundView() {
        backGroundView.layer.cornerRadius = 10
    }
    
    private func setUpStampImageView() {
        stampImageView.userInteractionEnabled = true
        let tappedStampImageGesture = UITapGestureRecognizer(target: self, action: #selector(StampImageTableViewCell.tappedStampImage))
        stampImageView.addGestureRecognizer(tappedStampImageGesture)
    }
    
}
