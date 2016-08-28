//
//  SignUpView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/26.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    
    let tableView = UITableView()
    let signUpButton = UIButton()
    private let screenSize = UIScreen.mainScreen().bounds
    
    override init(frame: CGRect) {
        
        let frame = CGRectMake(0, 0, screenSize.width, screenSize.width)
        super.init(frame: frame)
        
        tableView.registerNib(UINib(nibName: "PasswordTableViewCell", bundle: nil), forCellReuseIdentifier: "PasswordTableViewCell")
        tableView.registerNib(UINib(nibName: "MailTableViewCell", bundle: nil), forCellReuseIdentifier: "MailTableViewCell")
        tableView.registerNib(UINib(nibName: "UserImageTableViewCell", bundle: nil), forCellReuseIdentifier: "UserImageTableViewCell")
        
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(tableView)
        self.addSubview(signUpButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUpTableView()
        layoutSignUpButton()
    }
    
    private func setUpTableView() {
        tableView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 400)
    }
    
    private func layoutSignUpButton() {
        signUpButton.frame = CGRect(x: 25, y: 350, width: screenSize.width - 50, height: 48)
        signUpButton.backgroundColor = UIColor.mainColor()
        signUpButton.setTitle("Sign up", forState: .Normal)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.titleLabel?.font = UIFont.mainFontJa(15)
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.masksToBounds = true
    }
    
    

}
