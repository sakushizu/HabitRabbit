//
//  joinedUserCollectionView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/07.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class JoinedUserCollectionView: UICollectionView, UICollectionViewDelegate {
    
    private let screenSize = UIScreen.mainScreen().bounds
    private let flowLayout = UICollectionViewFlowLayout()

    init() {
        flowLayout.scrollDirection = .Vertical
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        
        super.init(frame: CGRectZero, collectionViewLayout: flowLayout)
        
        self.backgroundColor = UIColor.whiteColor()
        
        registerClass(SelectedUserCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        registerNib(UINib(nibName: HeaderCollectionReusableView.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.nibName)
        
        self.delegate = self
        self.userInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - CollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    

    // MARK -> Collectionview header size
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionReusableView, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: self.frame.width, height: 40)
        return size
    }
    
    

}
