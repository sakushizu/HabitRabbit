//
//  SelectedUserCollectionVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/03.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class SelectedUserCollectionVM: NSObject, UICollectionViewDataSource {
    
    var users = [User]()
    var joinedUsers = [User]()
    
    override init() {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(SelectedUserCollectionVM.selectUserNotification(_:)),
            name: "selectUserNotification",
            object: nil
        )
        
        
    }
    
    // MARK - CollectionViewDataSource
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SelectedUserCollectionViewCell
        let user = users[indexPath.row]
        cell.fillWith(user)
        return cell
    }
    

    func selectUserNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            users = userInfo["users"] as! [User]
//            joinedUsers = userInfo["joinedUsers"] as! [User]
        }
        let notification = NSNotification(name: "reloadDataNotification", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    


}
