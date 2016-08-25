//
//  CalendarTopVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/20.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class CalendarTopVM: NSObject, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = CalendarTopCellType(rawValue: section)!
        
        switch sectionType {
        case .User:
            return CurrentUser.sharedInstance.user.value == nil ? 0 : 1
        case .Calendar:
            return CalenderManager.sharedInstance.calendarCollection.value.count

        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sectionType = CalendarTopCellType(rawValue: indexPath.section)!
        
        switch sectionType {
        case .User:
            let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell", forIndexPath: indexPath) as! UserTableViewCell
            cell.fillWith(CurrentUser.sharedInstance.user.value!)
            return cell
        case .Calendar:
            let cell = tableView.dequeueReusableCellWithIdentifier("CalendarTableViewCell", forIndexPath: indexPath) as! CalendarTableViewCell
            cell.fillWith(CalenderManager.sharedInstance.calendarCollection.value[indexPath.row])
            return cell
        }
        
    }
    
    

}
