
//
//  ColorTableController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/15.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

@objc protocol ColorTableViewControllerDelegate {
    func setSelectedColor(selectedColor: CalendarThemeColor)
}

class ColorTableViewController: UITableViewController {
    
    weak var customDelegate: ColorTableViewControllerDelegate?
    
    var color = UIColor.appPinkColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.lightlightGray()
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width, height: 40))
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        label.textColor = UIColor.darkGrayColor()
        coverView.addSubview(label)
        if section == 0 {
            label.text = "Selected Color"
            return coverView
        } else {
            return coverView
        }
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return CalendarThemeColors.list.count
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if indexPath.section == 0 {
            cell.contentView.backgroundColor = color
        } else {
            cell.contentView.backgroundColor = CalendarThemeColors.list[indexPath.row].color
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedColor = CalendarThemeColors.list[indexPath.row]
        let notification : NSNotification = NSNotification(name: "selectColorNotification", object: self, userInfo: ["color": selectedColor])
        NSNotificationCenter.defaultCenter().postNotification(notification)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}
