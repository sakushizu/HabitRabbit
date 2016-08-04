//
//  UserInvitationCollectionView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/31.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class UserInvitationCollectionView: UICollectionView {
    
    
    let collectionViewHeight: CGFloat = 80
    
    init() {
        let screenSize = UIScreen.mainScreen().bounds
        let itemWidth = screenSize.width / 6
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.itemSize = CGSize(width: itemWidth, height: collectionViewHeight)
        
        let frame = CGRectMake(0, screenSize.height - collectionViewHeight, screenSize.width, self.collectionViewHeight)
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        setUpLayout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tappedCollectionViewCell() {
        
    }
    
    private func setUpLayout() {
        self.backgroundColor = UIColor.whiteColor()
    }

    
}
