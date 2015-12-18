
//
//  ColorTableController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/15.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

@objc protocol ColorTableViewControllerDelegate {
    func setSelectedColor(color: UIColor)
}

class ColorTableViewController: UITableViewController {
    
    weak var customDelegate: ColorTableViewControllerDelegate?

    let colors = [UIColor.lightYellow(), UIColor.lightOrange(), UIColor.lightGreen(), UIColor.lightBlue(), UIColor.lightWhiteBlue(), UIColor.lightPerple(), UIColor.lightPink(), UIColor.lightRed(), UIColor.lightGrayColor()]
    var color = UIColor.whiteColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Selected Color"
        } else {
            return " "
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
            return colors.count
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if indexPath.section == 0 {
            cell.contentView.backgroundColor = color
        } else {
            cell.contentView.backgroundColor = colors[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedColor = colors[indexPath.row]
        color = selectedColor
        customDelegate?.setSelectedColor(color)
        tableView.reloadData()
    }

}
