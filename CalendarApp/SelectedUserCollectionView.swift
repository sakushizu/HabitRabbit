//
//  SelectedUserCollectionView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/02.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit


class SelectedUserCollectionView: UICollectionView, UICollectionViewDelegate {

    let collectionViewHeight: CGFloat = 50
    let marginLeft: CGFloat = 65
    let marginRight: CGFloat = 35
    let cellHeight: CGFloat = 50
    

    
    init() {
        let screenSize = UIScreen.mainScreen().bounds
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        
        let frame = CGRectMake(marginLeft, 0, screenSize.width - (marginLeft + marginRight), collectionViewHeight)
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        self.backgroundColor = UIColor.whiteColor()
        
        registerClass(SelectedUserCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.delegate = self
        self.userInteractionEnabled = false

        
        setNotification()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK - CollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func reloadDada() {
        self.reloadDada()
    }
    
    private func setNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(SelectedUserCollectionView.reloadData),
            name: "reloadDataNotification",
            object: nil
        )
    }

}
