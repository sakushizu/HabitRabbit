//
//  MenuTableViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/10.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Parse
import SDWebImage

protocol MenuTableViewControllerDelegate {
    func menuControllerDidSelectRow(indexPath:NSIndexPath)
}

@objc protocol MenuTableViewControllerToCalendarControllerDelegate {
    func moveUserEditViewController()
}


class MenuTableViewController: UITableViewController {
    
    let sectionTitles = ["", "Calendar"]
    let user = CurrentUser.sharedInstance.user

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "sideUserTableViewCell", bundle: nil), forCellReuseIdentifier: "sideUserCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        super.viewWillAppear(true)
    }
    
    var delegate : MenuTableViewControllerDelegate?
    var customeDelegate: MenuTableViewControllerToCalendarControllerDelegate?
    var tableData : Array<String> = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return currentUser.user.value == nil ? 0 : 1
        } else {
            return CalenderManager.sharedInstance.calendarCollection.value.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 40
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.lightlightGray()
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width, height: 40))
        label.font = UIFont.mainFontJa(15)
        label.textColor = UIColor.darkGrayColor()
        coverView.addSubview(label)
        if section == 1 {
            label.text = "Private"
            return coverView
        } else if section == 2 {
            label.text = "Group"
            return coverView
        } else {
            return coverView
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.darkGrayColor()
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        cell.selectedBackgroundView = selectedBackgroundView
        if indexPath.section == 0 {
            let userCell = self.tableView.dequeueReusableCellWithIdentifier("sideUserCell", forIndexPath: indexPath) as! sideUserTableViewCell
            userCell.backgroundColor = UIColor.clearColor()
            if CurrentUser.sharedInstance.user == nil {
                userCell.userImageView.image = UIImage(named: "user")
                userCell.nameLabel.text = "Guest"
            } else {
                userCell.userImageView.sd_setImageWithURL(NSURL(string: user.avatarUrl))
                userCell.nameLabel.text = CurrentUser.sharedInstance.user.name
            }
            userCell.settingButton.addTarget(self, action: #selector(MenuTableViewController.tappedSettingBtn), forControlEvents: .TouchUpInside)
            return userCell
        } else {
            let calendar = CalenderManager.sharedInstance.calendarCollection.value[indexPath.row]
            cell.textLabel?.text = calendar.title
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100.0
        } else {
            return 50.0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.menuControllerDidSelectRow(indexPath)
    }
    
    func tappedSettingBtn() {
        self.customeDelegate?.moveUserEditViewController()
    }

}
