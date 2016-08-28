//
//  MailTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/26.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class MailTableViewCell: UITableViewCell {

    @IBOutlet weak var mailTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillWith(mailText: String) {
        mailTextField.text = mailText
    }


}
