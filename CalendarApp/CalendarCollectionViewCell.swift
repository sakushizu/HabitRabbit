//
//  CalenderCellCollectionViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/21.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    var textLabel = UILabel()
    var stampImageView = UIImageView()
    
    private let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(textLabel)
        self.contentView.addSubview(stampImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        setTextLabel()
        setStampImageView()
    }
    
    //ここから編集
    
    func setTextColor(day: Int) {
        if day % 7 == 0 {
            textLabel.textColor = UIColor.lightRed()
        } else if day % 7 == 6 {
            textLabel.textColor = UIColor.lightBlue()
        } else {
            textLabel.textColor = UIColor.lightGrayColor()
        }
    }
    
    func setWeekCell(week: Int) {
        textLabel.text = weekArray[week]
        userInteractionEnabled = false
        stampImageView.hidden = true
    }
    
    func setDayCell(day: String, isTapped: Bool, imageURL: String) {
        userInteractionEnabled = true
        textLabel.text = day
        
        if isTapped {
            stampImageView.hidden = false
            stampImageView.sd_setImageWithURL(NSURL(string: imageURL), placeholderImage: nil, options: .RefreshCached)
        } else {
            stampImageView.hidden = true
        }
  
    }
    
    private func setTextLabel() {
        textLabel.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        textLabel.font = UIFont.mainFontJa(12)
        textLabel.textAlignment = NSTextAlignment.Center
    }
    
    private func setStampImageView() {
        stampImageView.frame.size = CGSizeMake(30, 30)
        stampImageView.center.x = self.contentView.center.x
        stampImageView.center.y = self.contentView.center.y
        stampImageView.contentMode = UIViewContentMode.ScaleAspectFill
        stampImageView.clipsToBounds = true
    }
    
}
