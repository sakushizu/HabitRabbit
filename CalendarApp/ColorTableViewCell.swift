//
//  StampButtonTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/10.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class ColorTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var indecatorImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpTitleTextLabel()
        setUpColorView()
    }
    
    func fillWith(selectColor: UIColor) {
        self.colorView.hidden = false
        self.colorView.backgroundColor = selectColor

        
    }
    
    private func setUpTitleTextLabel() {
        titleTextLabel.font.fontWithSize(15)
        titleTextLabel.textColor = UIColor.hexStr("C8C7CC", alpha: 1)
    }
    
    private func setUpColorView() {
        colorView.layer.cornerRadius = colorView.frame.width / 2
    }

    
}
