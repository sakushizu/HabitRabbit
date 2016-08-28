//
//  PasswordTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/26.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class PasswordTableViewCell: UITableViewCell {

    @IBOutlet weak var passwordTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        passwordTextField.secureTextEntry = true

    }
    
    func fillWith(password: String) {
        passwordTextField.text = password
    }
    
}
