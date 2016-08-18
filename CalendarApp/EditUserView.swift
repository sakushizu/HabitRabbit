//
//  EditUserView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/12.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class EditUserView: UIView {
    
    let tableView = UITableView()
    let userInvitationButton = UIButton()
    private let screenSize = UIScreen.mainScreen().bounds

    
    override init(frame: CGRect) {
        
        let frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        super.init(frame: frame)
        
        tableView.registerNib(UINib(nibName: "EditUsersTableViewCell", bundle: nil), forCellReuseIdentifier: "EditUsersTableViewCell")
        
        self.addSubview(tableView)
        self.addSubview(userInvitationButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUpTableView()
        setUpUserInvitationButton()
    }
    
    private func setUpTableView() {
        tableView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
    
    private func setUpUserInvitationButton() {
        userInvitationButton.frame = CGRect(x: 15, y: screenSize.height - 60, width: screenSize.width - 30, height: 45)
        userInvitationButton.setTitle("Invite User", forState: UIControlState.Normal)
        userInvitationButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        userInvitationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        userInvitationButton.backgroundColor = UIColor.mainColor()
        userInvitationButton.layer.cornerRadius = 5
        userInvitationButton.layer.masksToBounds = true
    }

}
