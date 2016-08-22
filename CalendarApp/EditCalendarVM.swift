//
//  EditCalendarVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/10.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond
import SDWebImage

class EditCalendarVM: NSObject, UITableViewDataSource, UITextFieldDelegate {
    var selectStampImage = Observable<UIImage?>(nil)
    var selectColor: CalendarThemeColor!
    var titleText = Observable<String?>("")
    var users = Observable<[User]>([])
    
    var selectedCalendar = Observable<Calendar?>(nil)
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rowType = RowType(rawValue: indexPath.row)!
        
        switch rowType {
            
        case .TitleCell:
            let cell = tableView.dequeueReusableCellWithIdentifier("TitleTableViewCell", forIndexPath: indexPath) as! TitleTableViewCell
            cell.fillWith(indexPath.row, titleText: self.titleText.value!)
            cell.titleTextField.bnd_text.bindTo(titleText)
            return cell
            
        case .StampCell:
            let stampCell = tableView.dequeueReusableCellWithIdentifier("StampImageTableViewCell", forIndexPath: indexPath) as! StampImageTableViewCell
            stampCell.fillWith(selectStampImage.value)
            return stampCell
            
        case .ColorCell:
            let cell = tableView.dequeueReusableCellWithIdentifier("ColorTableViewCell", forIndexPath: indexPath) as! ColorTableViewCell
            cell.fillWith(selectColor.color)
            return cell
            
        case.UserCell:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectUserTableViewCell", forIndexPath: indexPath) as! SelectUserTableViewCell
            cell.mModel.users = users.value

            guard users.value.count > 0 else {
                cell.selectUesrCollectionView.hidden = true
                return cell
            }
            cell.selectUesrCollectionView.hidden = false
            return cell
        }
    }
    
    func setUpCalendar() {
        let url = NSURL(string: selectedCalendar.value!.stampImageURL)
        downloadAndSetCalendarImage(url!)
        selectColor = CalendarThemeColor(r: selectedCalendar.value!.color_r, g: selectedCalendar.value!.color_g, b: selectedCalendar.value!.color_b)
        titleText.value = selectedCalendar.value!.title
        users.value = (selectedCalendar.value?.joinedUsers)! + (selectedCalendar.value?.invitingUsers)!

        let selectUserNotification = NSNotification(name: "selectUserNotification", object: self, userInfo: ["users": users.value])
        NSNotificationCenter.defaultCenter().postNotification(selectUserNotification)
    }
    
    private func downloadAndSetCalendarImage(url: NSURL) {
        let downloader = SDWebImageManager.sharedManager()
        downloader.downloadImageWithURL(
            url,
            options: .HighPriority,
            progress: nil,
            completed: {image, d, e, f, _ in
                if image != nil {
                    self.selectStampImage.value = image
                }
            }
        )
    }

}
