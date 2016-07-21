//
//  StampCollectionView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/14.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

@objc protocol StampCollectionViewDelegate {
    func setImage(image: UIImage)
}

class StampCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let stampsImages = ["Gift-32.png", "Pushups-32.png", "Wakeup Hill on Stairs Filled-32.png", "Yoga Filled-32.png", "Portrait Mode-32.png","Sports Mode-32.png", "Edit Filled-32.png", "Document-32.png", "Document Filled-32.png", "Panda Filled-32.png", "Hair Dryer-32.png", "Edit Filled-32.png", "Gift-32.png", "Pushups-32.png", "Wakeup Hill on Stairs Filled-32.png", "Yoga Filled-32.png", "Portrait Mode-32.png","Sports Mode-32.png", "Edit Filled-32.png", "Document-32.png", "Document Filled-32.png", "Panda Filled-32.png", "Hair Dryer-32.png", "Edit Filled-32.png", "Gift-32.png", "Pushups-32.png", "Wakeup Hill on Stairs Filled-32.png", "Yoga Filled-32.png", "Portrait Mode-32.png","Sports Mode-32.png", "Edit Filled-32.png", "Document-32.png", "Document Filled-32.png", "Panda Filled-32.png", "Hair Dryer-32.png", "Edit Filled-32.png"]

    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)

        registerNib(UINib(nibName: "StampCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "stampCell")
        registerNib(UINib(nibName: CancelButtonHeaderView.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CancelButtonHeaderView.nibName)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    //MARK: -> headerの記述
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: CancelButtonHeaderView.nibName, forIndexPath: indexPath) as UICollectionReusableView
            
            return headerReusableView
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionReusableView, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: self.frame.width, height: 40)
        return size
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stampsImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("stampCell", forIndexPath: indexPath) as! StampCollectionViewCell
        cell.stampImageView.image = UIImage(named: stampsImages[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let stampImage = UIImage(named: stampsImages[indexPath.row])
        let notification : NSNotification = NSNotification(name: "selectStampNotification", object: self, userInfo: ["stampImage": stampImage!])
        NSNotificationCenter.defaultCenter().postNotification(notification)
        
    }



}
