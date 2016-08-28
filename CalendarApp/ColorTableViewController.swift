
//
//  ColorTableController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/15.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class ColorTableViewController: UITableViewController {

    var color = UIColor.mainColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.baseGrayColor()
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width, height: 40))
        label.font = UIFont.mainFontJa(14)
        label.textColor = UIColor.textColor()
        coverView.addSubview(label)
        if section == 0 {
            label.text = "Selected Color"
            return coverView
        } else {
            label.text = "Color"
            return coverView
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        setNavigationBar()
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        let notification = NSNotification(name: "selectColorNotification", object: self, userInfo: ["color": selectedColor])
        NSNotificationCenter.defaultCenter().postNotification(notification)
        color = selectedColor.color
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    private func setNavigationBar() {
        self.navigationController?.hidesNavigationBarHairline = true
        self.navigationController?.navigationBar.tintColor = UIColor.mainColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mainColor()]
        navigationItem.title = "Select Color"
        
    }

}
