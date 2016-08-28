    //
//  EditUsersVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/11.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

enum EditUsersTableViewSectionType: Int {
    case Owner = 0
    case Members = 1
    case InvitationUsers = 2
}

class EditUsersVM: NSObject, UITableViewDataSource {
    
    var selectedCalendar = Observable<Calendar?>(nil)

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = EditUsersTableViewSectionType(rawValue: section)!
        
        switch sectionType {
        case .Owner:
            return 1
            
        case .Members:
            return selectedCalendar.value!.joinedUsers.count
            
        case .InvitationUsers:
            return selectedCalendar.value!.invitingUsers.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EditUsersTableViewCell") as! EditUsersTableViewCell
        
        let sectionType = EditUsersTableViewSectionType(rawValue: indexPath.section)!
    
        switch sectionType {
        case .Owner:
            cell.fillWith(selectedCalendar.value!.orner)
            return cell
            
        case .Members:
            cell.fillWith(selectedCalendar.value!.joinedUsers[indexPath.row])
            return cell
            
        case .InvitationUsers:
            cell.fillWith(selectedCalendar.value!.invitingUsers[indexPath.row])
            return cell
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let sectionType = EditUsersTableViewSectionType(rawValue: indexPath.section)!
        switch sectionType {
        case .Owner:
            return false
            
        case .Members:
            return true
            
        case .InvitationUsers:
            return true
        }
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let sectionType = EditUsersTableViewSectionType(rawValue: indexPath.section)!
            switch sectionType {
            case .Members:
                let block: () -> Void = {
                    self.selectedCalendar.value!.joinedUsers.removeAtIndex(indexPath.row)
                }
                self.alertBeforeDeleteUser(block)
                
            case .InvitationUsers:
                let block: () -> Void = {
                    self.selectedCalendar.value!.invitingUsers.removeAtIndex(indexPath.row)
                }
                self.alertBeforeDeleteUser(block)
                
            default:
                break
            }
        }
    }

    
    func alertBeforeDeleteUser(completion: () -> Void) {
        let sweetAlert = SweetAlert()
        sweetAlert.showAlert("Are you sure?", subTitle: "", style: AlertStyle.Warning, buttonTitle:"cancel", buttonColor:UIColor.redColor() , otherButtonTitle:  "　　ok　　", otherButtonColor:UIColor.redColor()) { (isOtherButton) -> Void in

            guard isOtherButton else {
                completion()
                SweetAlert().showAlert("success!", subTitle: "", style: AlertStyle.Success)
                return
            }
        }
    }
    

    
}
