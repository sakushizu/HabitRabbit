//
//  CreateCalendar.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/08.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class CreateCalendar: NSObject, UITableViewDataSource, UITextFieldDelegate {
    
    let icons = ["pen", "", "color", "users"]
    let textLabels = ["", "", "Select Color", "Select User"]
    var selectStampImage = UIImage(named: "Approval.png")
    var selectColor = CalendarThemeColor(r: 248, g: 151, b: 190)
    var titleText = Observable<String?>("")
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rowType = RowType(rawValue: indexPath.row)!
        
        switch rowType {
            
        case .TitleCell:
            let cell = tableView.dequeueReusableCellWithIdentifier("CreateTableViewCell", forIndexPath: indexPath) as! CreateTableViewCell
            cell.iconImageView.image = UIImage(named: icons[indexPath.row])
            cell.indecatorImageView.hidden = true
            cell.iconImageView.image = UIImage(named: icons[indexPath.row])
            cell.cellTextLabel?.hidden = true
            cell.titleTextField.hidden = false
            cell.titleTextField.bnd_text.bindTo(self.titleText)
            cell.colorView.hidden = true
            return cell
            
        case .StampCell:
            let stampCell = tableView.dequeueReusableCellWithIdentifier("StampImageTableViewCell", forIndexPath: indexPath) as! StampImageTableViewCell
            stampCell.stampImageView.image = selectStampImage
            return stampCell

        case .ColorCell, .UserCell:
            let cell = tableView.dequeueReusableCellWithIdentifier("CreateTableViewCell", forIndexPath: indexPath) as! CreateTableViewCell
            cell.iconImageView.image = UIImage(named: icons[indexPath.row])
            cell.cellTextLabel?.hidden = false
            cell.titleTextField.hidden = true
            cell.indecatorImageView.hidden = false
            cell.cellTextLabel?.text = textLabels[indexPath.row]
            cell.colorView.hidden = true
            
            if rowType == .ColorCell {
                cell.colorView.hidden = false
                cell.colorView.backgroundColor = selectColor.color
            }
            
            return cell
        }
    }
        

}
