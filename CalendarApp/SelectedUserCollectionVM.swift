//
//  SelectedUserCollectionVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/03.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

//@objc protocol SelectedUserCollectionVMDelegate {
//    func reloadData()
//}

class SelectedUserCollectionVM: NSObject, UICollectionViewDataSource {
    
    var invitationUsers = [User]()
    
//    weak var customDelegate: SelectedUserCollectionVMDelegate?
    
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
        return invitationUsers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SelectedUserCollectionViewCell
        let user = invitationUsers[indexPath.row]
        cell.fillWith(user)
        return cell
    }
    

    func selectUserNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            self.invitationUsers = (userInfo["users"] as? [User])!
        }
        let notification = NSNotification(name: "reloadDataNotification", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    


}
