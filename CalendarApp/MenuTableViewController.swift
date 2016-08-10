//
//  MenuTableViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/10.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import SDWebImage
import Bond

protocol MenuTableViewControllerDelegate {
    func menuControllerDidSelectRow(indexPath:NSIndexPath)
}

@objc protocol MenuTableViewControllerToCalendarControllerDelegate {
    func moveUserEditViewController()
}

enum SectionType: Int {
    case UserCell = 0
    case CalendarCell = 1
}

class MenuTableViewController: UITableViewController {
    
    var delegate : MenuTableViewControllerDelegate?
    var customeDelegate: MenuTableViewControllerToCalendarControllerDelegate?
    private let currentUser = CurrentUser.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "SideUserTableViewCell", bundle: nil), forCellReuseIdentifier: "SideUserTableViewCell")
        self.tableView.registerClass(SideCalendarTableViewCell.self, forCellReuseIdentifier: "SideCalendarTableViewCell")
        
        currentUser.user.observe { user in
            self.tableView.reloadData()
        }
        
        CalenderManager.sharedInstance.calendarCollection.observe { calendar in
            self.tableView.reloadData()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        super.viewWillAppear(true)
    }
    
    
    // MARK - TableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sectionType = SectionType(rawValue: indexPath.section)!
        switch sectionType {
            
        case .UserCell:
            let userCell = self.tableView.dequeueReusableCellWithIdentifier("SideUserTableViewCell", forIndexPath: indexPath) as! SideUserTableViewCell
            userCell.settingButton.addTarget(self, action: #selector(MenuTableViewController.tappedSettingBtn), forControlEvents: .TouchUpInside)
            return userCell
            
        case .CalendarCell:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SideCalendarTableViewCell", forIndexPath: indexPath) as!  SideCalendarTableViewCell
            let calendar = CalenderManager.sharedInstance.calendarCollection.value[indexPath.row]
            cell.fillWith(calendar)
            return cell
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = SectionType(rawValue: section)!
        
        switch sectionType {
            
        case .UserCell:
            return currentUser.user.value == nil ? 0 : 1
            
        case .CalendarCell:
            return CalenderManager.sharedInstance.calendarCollection.value.count
        }
    }
    
    // MARK - TableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionType = SectionType(rawValue: indexPath.section)!
        
        switch sectionType {
            
        case .UserCell:
            return 80
        case .CalendarCell:
            return 40
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionType = SectionType(rawValue: section)!
        
        switch sectionType {
            
        case .UserCell:
            return 0
        case .CalendarCell:
            return 40
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createCoverView()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.menuControllerDidSelectRow(indexPath)
    }
    
    func tappedSettingBtn() {
        self.customeDelegate?.moveUserEditViewController()
    }
    
    private func createCoverView() -> UIView {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.lightlightGray()
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width, height: 40))
        label.font = UIFont.mainFontJa(15)
        label.textColor = UIColor.textColor()
        label.text = "Calendar"
        coverView.addSubview(label)
        return coverView
    }

}
