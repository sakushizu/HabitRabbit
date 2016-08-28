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

        triangleImageView.frame.size = size
        triangleImageView.center.y = 12
        
    }
    
    private func setUpTableView() {
        let triangleHeight: CGFloat = 20
        tableView.frame = CGRect(x: tableViewMargin, y: triangleHeight, width: screenSize.width - (tableViewMargin * 2), height: screenSize.height - (triangleHeight + tableViewMargin))
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
    }

}
