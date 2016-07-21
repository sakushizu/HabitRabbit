//
//  CancelButtonHeaderView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/15.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CancelButtonHeaderView: UICollectionReusableView {
    
    static let nibName = "CancelButtonHeaderView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    @IBAction func tappedCancelButton(sender: UIButton) {
        //scrollを下げるメソッドを呼びたい
        let ns = NSNotificationCenter.defaultCenter()
        ns.postNotificationName("closeStampImageNotification", object: nil)
    }

}
