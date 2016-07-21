//
//  StampButtonTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/10.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CreateTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cellTextLabel: UILabel!
    @IBOutlet weak var indecatorImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    
    var titleTextField = UITextField()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellTextLabel.font.fontWithSize(15)
        cellTextLabel.textColor = UIColor.hexStr("C8C7CC", alpha: 1)
        colorView.layer.cornerRadius = colorView.frame.width / 2
        
        titleTextField = UITextField(frame: CGRectMake(75, 14, 250, 23))
        titleTextField.borderStyle = UITextBorderStyle.None
        titleTextField.placeholder = "Write a title"
        titleTextField.hidden = true
        titleTextField.font = UIFont(name: "Hiragino Kaku Gothic Pro", size: 15)
        titleTextField.textColor = UIColor.hexStr("555555", alpha: 1)
        self.contentView.addSubview(titleTextField)
        
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
