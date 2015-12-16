//
//  CreateCell1TableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/12.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

@objc protocol CreateCell1Delegate {
    func stampBtn()
}

class CreateCell1: UITableViewCell {
    
    static let sharedInstance = CreateCell1()
    
    weak var customDelegate: CreateCell1Delegate?
    
    @IBOutlet weak var stampImageView: UIImageView!
    @IBOutlet weak var varticalLine1: UIView!
    @IBOutlet weak var varticalLine2: UIView!
    @IBOutlet weak var defaultStampBtn: UIButton!
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var takePhotoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        varticalLine1.layer.position = CGPoint(x: self.frame.width*1/3, y: 220)
        varticalLine2.layer.position = CGPoint(x: self.frame.width*2/3, y: 220)
        defaultStampBtn.frame = CGRectMake(self.frame.width/6, 218, 109, 30)
        defaultStampBtn.layer.position = CGPoint(x: self.frame.width/6, y:218)
        libraryBtn.frame = CGRectMake(0, 0, 109, 30)
        libraryBtn.layer.position = CGPoint(x: self.frame.width/2, y:218)
        takePhotoBtn.frame = CGRectMake(0, 0, 109, 30)
        takePhotoBtn.layer.position = CGPoint(x: self.frame.width*5/6, y:218)
      
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    func tappedStampBtn(sender: UIButton) {
//        customDelegate?.stampBtn()
//    }


    
    
}
