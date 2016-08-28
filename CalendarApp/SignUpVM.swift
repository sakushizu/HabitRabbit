//
//  SignUpVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/26.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

enum SignUPCellType: Int {
    case ImageAndName = 0
    case Mail = 1
    case Password = 2
}

class SignUpVM: NSObject, UITableViewDataSource {
    
    var selectedImage = UIImage(named: "user")
    var nameText = Observable<String?>("")
    var mailText = Observable<String?>("")
    var passwordText = Observable<String?>("")
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowType = SignUPCellType(rawValue: indexPath.row)!
        switch rowType {
        case .ImageAndName:
            let cell = tableView.dequeueReusableCellWithIdentifier("UserImageTableViewCell", forIndexPath: indexPath) as! UserImageTableViewCell
            cell.fillWith(selectedImage!, name: nameText.value!)
            cell.userNameTextField.bnd_text.bindTo(nameText)
            return cell
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
