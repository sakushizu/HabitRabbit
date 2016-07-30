//
//  StampButtonTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/10.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class CreateTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var indecatorImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    
    let icons = ["", "", "color", "users"]
    let textLabels = ["", "", "Select Color", "Select User"]
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpTitleTextLabel()
        setUpColorView()
    }
    
    func fillWith(row: Int) {
        self.iconImageView.image = UIImage(named: icons[row])
        self.titleTextLabel?.text = textLabels[row]
        self.colorView.hidden = true
    }
    
    private func setUpTitleTextLabel() {
        titleTextLabel.font.fontWithSize(15)
        titleTextLabel.textColor = UIColor.hexStr("C8C7CC", alpha: 1)
    }
    
    private func setUpColorView() {
        colorView.layer.cornerRadius = colorView.frame.width / 2
    }
    

    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
