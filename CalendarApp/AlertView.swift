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
    
    let triangleImageView = UIImageView()
    let tableView = UITableView()
    private let tableViewMargin: CGFloat = 18

    
    override init(frame: CGRect) {
        
        let frame = CGRectMake(0, 0, screenSize.width, screenSize.width)
        super.init(frame: frame)
        
        
        tableView.registerNib(UINib(nibName: "AlertTableViewCell", bundle: nil), forCellReuseIdentifier: "AlertTableViewCell")
        
        self.addSubview(tableView)
        self.addSubview(triangleImageView)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUpTriangleImageView()
        setUpTableView()
        
    }
    
    private func setUpTriangleImageView() {
        triangleImageView.image = UIImage(named: "triangle")
        let size = CGSize(width: 30, height: 23)
        let marginTop: CGFloat = 12
        let y = statusBarHeight + navBarHeight + marginTop

        triangleImageView.frame.size = size
        triangleImageView.center.y = y
        
    }
    
    private func setUpTableView() {
        let triangleHeight: CGFloat = 20
        let y = statusBarHeight + navBarHeight + triangleHeight
        let height = screenSize.height - (statusBarHeight + navBarHeight + triangleHeight)


        tableView.frame = CGRect(x: tableViewMargin, y: y, width: screenSize.width - (tableViewMargin * 2), height: height - tableViewMargin)
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
    }

}
