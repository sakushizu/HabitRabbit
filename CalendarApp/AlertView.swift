//
//  AlertView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/04.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    private let screenSize = UIScreen.mainScreen().bounds
    private let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
    private let navBarHeight: CGFloat = UINavigationController().navigationBar.frame.size.height
    
    private let triangleImageView = UIImageView()
    let tableView = UITableView()
    private let tableViewMargin: CGFloat = 18
    

    
    override init(frame: CGRect) {
        
        let frame = CGRectMake(0, 0, screenSize.width, screenSize.width)
        super.init(frame: frame)
        
        
        tableView.registerNib(UINib(nibName: "AlertTableViewCell", bundle: nil), forCellReuseIdentifier: "AlertTableViewCell")
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUpTriangleImageView()
        setUpTableView()
        
        self.addSubview(tableView)
        
//        self.addSubview(triangleImageView)
        
    }
    
    private func setUpTriangleImageView() {
        triangleImageView.image = UIImage(named: "rectangle")
        let frame = CGRectMake(screenSize.width - 80, 0, 33, 30)
        triangleImageView.frame = frame
    }
    
    private func setUpTableView() {
        let triangleHeight: CGFloat = 15
        let y = statusBarHeight + navBarHeight + triangleHeight
        let height = screenSize.height - (statusBarHeight + navBarHeight + triangleHeight)


        tableView.frame = CGRect(x: tableViewMargin, y: y, width: screenSize.width - (tableViewMargin * 2), height: height - tableViewMargin)
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
    }

}
