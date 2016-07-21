//
//  CreateCalendarView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/08.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CreateCalendarView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    override func awakeFromNib() {
        tableView.registerNib(UINib(nibName: "CreateTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateTableViewCell")
        tableView.registerNib(UINib(nibName: "StampImageTableViewCell", bundle: nil), forCellReuseIdentifier: "StampImageTableViewCell")
        
        layoutTableView()
        
        createButton.layer.cornerRadius = 5
        

    }
    
    func layoutTableView() {
        tableView.contentInset = UIEdgeInsets(top: 89, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.hexStr("F6F6F6", alpha: 1)
        tableView.scrollEnabled = false
    }

}
