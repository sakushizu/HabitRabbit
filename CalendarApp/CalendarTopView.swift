//
//  CalendarTop.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/20.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalendarTopView: UIView {
    
    let tableView = UITableView()
    private let screenSize = UIScreen.mainScreen().bounds
    
    override init(frame: CGRect) {
        let frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height)
        super.init(frame: frame)
        
        tableView.registerNib(UINib(nibName: "UserTableViewCell",bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        tableView.registerNib(UINib(nibName: "CalendarTableViewCell",bundle: nil), forCellReuseIdentifier: "CalendarTableViewCell")
        
        self.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layoutTableView()
    }
    
    private func layoutTableView() {
        tableView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }

}
