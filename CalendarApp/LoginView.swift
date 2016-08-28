//
//  LoginView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/26.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    let tableView = UITableView()
    let loginButton = UIButton()
    private let screenSize = UIScreen.mainScreen().bounds
    
    override init(frame: CGRect) {
        
        let frame = CGRectMake(0, 0, screenSize.width, screenSize.width)
        super.init(frame: frame)
        
        tableView.registerNib(UINib(nibName: "PasswordTableViewCell", bundle: nil), forCellReuseIdentifier: "PasswordTableViewCell")
        tableView.registerNib(UINib(nibName: "MailTableViewCell", bundle: nil), forCellReuseIdentifier: "MailTableViewCell")
        
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(tableView)
        self.addSubview(loginButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUpTableView()
        layoutLoginButton()
    }
    
    private func setUpTableView() {
        tableView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 400)
    }
    
    private func layoutLoginButton() {
        loginButton.frame = CGRect(x: 25, y: 350, width: screenSize.width - 50, height: 48)
        loginButton.backgroundColor = UIColor.mainColor()
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.titleLabel?.font = UIFont.mainFontJa(15)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
    }

}
