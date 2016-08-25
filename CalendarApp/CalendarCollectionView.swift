//
//  CalendarCollectionView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/24.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalendarCollectionView: UICollectionView {
    
    private var flowLayout = UICollectionViewFlowLayout()
    private let itemSpacing: CGFloat = 10.0
    
    override func awakeFromNib() {
        setFlowLayout()
        
        registerClass(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        self.backgroundColor = UIColor.whiteColor()
        registerClass(CalendarCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CalendarCollectionReusableView")
        
    }
    
    private func setFlowLayout(){
        let size: CGFloat =  (self.frame.width - itemSpacing * 6) / 7
        flowLayout.scrollDirection = .Vertical
        flowLayout.itemSize = CGSize(width: size, height: size - 5)
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = itemSpacing
        self.collectionViewLayout = flowLayout
    }
    

    


}
