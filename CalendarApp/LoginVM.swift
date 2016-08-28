//
//  LoginVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/26.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

enum LoginCellType: Int {
    case Mail = 0
    case Password = 1
}

class LoginVM: NSObject, UITableViewDataSource {

    var mailText = Observable<String?>("")
    var passwordText = Observable<String?>("")
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowType = LoginCellType(rawValue: indexPath.row)!
        switch rowType {
        case .Mail:
            let cell = tableView.dequeueReusableCellWithIdentifier("MailTableViewCell", forIndexPath: indexPath) as! MailTableViewCell
            cell.fillWith(mailText.value!)
            cell.mailTextField.bnd_text.bindTo(mailText)
            return cell
        case .Password:
            let cell = tableView.dequeueReusableCellWithIdentifier("PasswordTableViewCell", forIndexPath: indexPath) as! PasswordTableViewCell
            cell.fillWith(passwordText.value!)
            cell.passwordTextField.bnd_text.bindTo(passwordText)
            return cell
        }
    }
}
