//
//  CreateCell1TableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/12.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CreateCell1: UITableViewCell {
    
    var varticalLine1 = UIView()
    var varticalLine2 = UIView()
    var stampImageView = UIImageView()
    var horizontalView = UIView()
    var defaultStampBtn = UIButton()
    var libraryBtn = UIButton()
    var takePhotoBtn = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code      
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.whiteColor()

        stampImageView.frame.size = CGSizeMake(120, 120)
        stampImageView.center.x = self.contentView.center.x
        stampImageView.center.y = (200 - 30) / 2
        self.addSubview(stampImageView)

        varticalLine1 = UIView(frame: CGRectMake(self.frame.width / 3, self.frame.height - 30, 1, 30))
        varticalLine1.backgroundColor = UIColor.lightlightGray()
        self.addSubview(varticalLine1)

        varticalLine2 = UIView(frame: CGRectMake(self.frame.width * 2 / 3, self.frame.height - 30, 1, 30))
        varticalLine2.backgroundColor = UIColor.lightlightGray()
        self.addSubview(varticalLine2)
        
        horizontalView = UIView(frame: CGRectMake(0, self.frame.height - 31, self.frame.width, 1))
        horizontalView.backgroundColor = UIColor.lightlightGray()
        self.addSubview(horizontalView)
        
        setBtn(defaultStampBtn, x: 1, title: "Default Stamp")
        self.addSubview(defaultStampBtn)
        setBtn(libraryBtn, x: 3, title: "Use Library")
        self.addSubview(libraryBtn)
        setBtn(takePhotoBtn, x: 5, title: "Take a Photo")
        self.addSubview(takePhotoBtn)
        
    }
    
    func setBtn(btn: UIButton, x: CGFloat, title: String) {
        btn.frame.size = CGSizeMake((self.frame.width - 12) / 3, 28)
        btn.center.x = self.frame.width * x / 6
        btn.center.y = self.frame.height - 14
        btn.setTitle(title, forState: .Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
    }

}
