//
//  JoinView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/07.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class JoinView: UIView {
    
    
    var joinedUserCollectionView = JoinedUserCollectionView()
    var joinButton = UIButton()
    var noButton = UIButton()
    private let screenSize = UIScreen.mainScreen().bounds
    private var buttonMargin: CGFloat = 20
    private var buttonWidth: CGFloat!
    private let navigationBarHeight: CGFloat = 64

    
    override init(frame: CGRect) {
        
        let frame = CGRectMake(0, 0, screenSize.width, screenSize.width)
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(noButton)
        self.addSubview(joinButton)
        self.addSubview(joinedUserCollectionView)
        
    }
    
    override func layoutSubviews() {
        self.joinedUserCollectionView.frame = CGRect(x: 20, y: navigationBarHeight, width: self.frame.width - 20, height: 100)
        buttonWidth = (screenSize.width - buttonMargin * 3) / 2
        createButton(noButton, x:buttonMargin, text: "No")
        createButton(joinButton, x: buttonMargin * 2 + buttonWidth, text: "Join")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createButton(button: UIButton, x: CGFloat, text: String) -> UIButton {
        button.frame = CGRect(x: x, y: joinedUserCollectionView.frame.height + navigationBarHeight, width: buttonWidth, height: 40)
        button.setTitle(text, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.textColor(), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.mainFontJa(15)
        button.backgroundColor = UIColor.hexStr("D8D8D8", alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }

}
