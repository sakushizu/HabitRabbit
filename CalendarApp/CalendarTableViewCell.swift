//
//  CalendarTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/20.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import SDWebImage

class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calendarTitleLabel: UILabel!
    @IBOutlet weak var stampImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    func fillWith(calendar: Calendar) {
        self.contentView.backgroundColor = UIColor.setUIColor(calendar.color_r, green: calendar.color_g, blue: calendar.color_b)
        calendarTitleLabel.text = calendar.title
        stampImageView.sd_setImageWithURL(NSURL(string: calendar.stampImageURL)) { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, url: NSURL!) in
            self.stampImageView.image = image.imageWithRenderingMode(.AlwaysTemplate)
            self.stampImageView.tintColor = UIColor.whiteColor()
        }
    }
}
