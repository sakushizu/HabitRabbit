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
    
    let icons = ["pen", "", "color", "users"]
    let textLabels = ["", "", "Select Color", "Select User"]
    
    var titleTextField = UITextField()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpTitleTextLabel()
        setUpColorView()
        setUpTitleTextField()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutTitleTextField()
    }
    
    func fillFithTitleCell(row: Int, titleText: String){
        self.iconImageView.image = UIImage(named: icons[row])
        self.indecatorImageView.hidden = true
        self.iconImageView.image = UIImage(named: icons[row])
        self.titleTextLabel?.hidden = true
        self.titleTextField.hidden = false
        self.titleTextField.text = titleText
        self.colorView.hidden = true
    }
    
    func fillWith(row: Int) {
        self.iconImageView.image = UIImage(named: icons[row])
        self.titleTextLabel?.hidden = false
        self.titleTextField.hidden = true
        self.indecatorImageView.hidden = false
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
    
    private func layoutTitleTextField() {
        titleTextField = UITextField(frame: CGRectMake(75, 14, 250, 23))
        self.contentView.addSubview(titleTextField)
    }
    
    private func setUpTitleTextField() {
        titleTextField.borderStyle = UITextBorderStyle.None
        titleTextField.placeholder = "Write a title"
        titleTextField.hidden = true
        titleTextField.font = UIFont(name: "Hiragino Kaku Gothic Pro", size: 15)
        titleTextField.textColor = UIColor.hexStr("555555", alpha: 1)
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
