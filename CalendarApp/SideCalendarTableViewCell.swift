//
//  SideCalendarTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/10.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class SideCalendarTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let style = UITableViewCellStyle.Default
        let identifier = "SideCalendarTableViewCell"
        super.init(style: style, reuseIdentifier: identifier)
        
        setUpCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillWith(calendar: Calendar) {
        textLabel?.text = calendar.title
    }
    
    private func setUpCell() {
        self.backgroundColor = UIColor.clearColor()
        self.textLabel!.textColor = UIColor.darkGrayColor()
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        self.selectedBackgroundView = selectedBackgroundView
    }

}
