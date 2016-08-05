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
        tableView.registerNib(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        tableView.registerNib(UINib(nibName: "ColorTableViewCell", bundle: nil), forCellReuseIdentifier: "ColorTableViewCell")
        tableView.registerNib(UINib(nibName: "StampImageTableViewCell", bundle: nil), forCellReuseIdentifier: "StampImageTableViewCell")
        tableView.registerNib(UINib(nibName: "SelectUserTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectUserTableViewCell")

        
        layoutTableView()
        layoutCreateButton()
        
        

    }
    
    private func layoutTableView() {
        tableView.contentInset = UIEdgeInsets(top: 89, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.hexStr("F6F6F6", alpha: 1)
        tableView.scrollEnabled = false
    }
    
    private func layoutCreateButton() {
        createButton.layer.cornerRadius = 5
    }

}
