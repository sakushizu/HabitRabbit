//
//  JoinVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/07.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class JoinVM: NSObject, UICollectionViewDataSource {
    
    var users = [User]()
    
    // MARK - CollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SelectedUserCollectionViewCell
        cell.fillWith(users[indexPath.row])
        return cell
    }
    
    // MARK -> Collectionview header
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.nibName, forIndexPath: indexPath) as! HeaderCollectionReusableView
            
            return headerReusableView
        } else {
            return UICollectionReusableView()
        }
    }

}
