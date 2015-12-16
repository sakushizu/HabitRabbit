//
//  CreateCalendarVIew.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/10.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CreateCalendarView: UIView {
    
    @IBOutlet weak var stampImageView: UIImageView!
    @IBOutlet weak var stampView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var selectColorBtn: UIButton!
    @IBOutlet weak var stampBtn: UIButton!
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var takeAPhotoBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var horizontalLine1: UIView!
    @IBOutlet weak var varticalLine2: UIView!
    @IBOutlet weak var verticalLine3: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setStampBtns()
        selectColorBtn.contentHorizontalAlignment = .Left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func setStampBtns() {
        horizontalLine1.frame = CGRectMake(0, 196, self.frame.width, 1)
        varticalLine2.layer.position = CGPoint(x: self.frame.width*1/3, y: 220)
        verticalLine3.layer.position = CGPoint(x: self.frame.width*2/3, y: 220)
        stampBtn.frame = CGRectMake(self.frame.width/6, 218, 109, 30)
        stampBtn.layer.position = CGPoint(x: self.frame.width/6, y:218)
        libraryBtn.frame = CGRectMake(0, 0, 109, 30)
        libraryBtn.layer.position = CGPoint(x: self.frame.width/2, y:218)
        takeAPhotoBtn.frame = CGRectMake(0, 0, 109, 30)
        takeAPhotoBtn.layer.position = CGPoint(x: self.frame.width*5/6, y:218)
    }
    
    

//    class func instance() -> CreateCalendarView {
//        return UINib(nibName: "CreateCalendarView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! CreateCalendarView
//    }

    
    
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
