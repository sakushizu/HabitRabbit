
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

//    let colors = [UIColor.lightYellow(), UIColor.lightOrange(),UIColor.hexStr("#f1c40f", alpha: 1), UIColor.lightGreen(), UIColor.lightBlue(), UIColor.lightWhiteBlue(), UIColor.lightPerple(), UIColor.lightPink(), UIColor.lightRed(), UIColor.lightGrayColor(), UIColor.lightLightOrenge()]
    let colors = [UIColor.hexStr("#1abc9c", alpha: 1), UIColor.hexStr("#16a085", alpha: 1), UIColor.hexStr("#2ecc71", alpha: 1), UIColor.hexStr("#27ae60", alpha: 1), UIColor.hexStr("#3498db", alpha: 1), UIColor.hexStr("#2980b9", alpha: 1), UIColor.hexStr("#9b59b6", alpha: 1), UIColor.hexStr("#8e44ad", alpha: 1), UIColor.hexStr("#2c3e50", alpha: 1), UIColor.hexStr("#34495e", alpha: 1),UIColor.hexStr("#f39c12", alpha: 1), UIColor.hexStr("#f1c40f", alpha: 1), UIColor.hexStr("#e67e22", alpha: 1), UIColor.hexStr("#d35400", alpha: 1), UIColor.hexStr("#e74c3c", alpha: 1), UIColor.hexStr("#c0392b", alpha: 1), UIColor.hexStr("#bdc3c7", alpha: 1), UIColor.hexStr("#95a5a6", alpha: 1), UIColor.hexStr("#7f8c8d", alpha: 1)]
    
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
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}
