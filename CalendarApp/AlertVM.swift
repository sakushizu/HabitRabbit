//
//  AlertVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/04.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class AlertVM: NSObject, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInvitationManager.sharedInstance.calendars.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertTableViewCell") as! AlertTableViewCell
        cell.fillWith(UserInvitationManager.sharedInstance.calendars.value[indexPath.row])
        return cell
    }

}
