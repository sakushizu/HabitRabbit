//
//  UserInvitaionVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/30.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class UserInvitaionVM: NSObject, UITableViewDataSource, UICollectionViewDataSource {
    
    let userInvitationManager = UserInvitationManager.sharedInstance
    
    let collectionViewIsAppearing = Observable<Bool>(false)
    let selectedUsers = Observable<[User]>([])

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInvitationManager.users.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = userInvitationManager.users.value[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("UserInvitationTableViewCell", forIndexPath: indexPath) as! UserInvitationTableViewCell
        cell.fillWith(user)
        
        let isChecked = selectedUsers.value.contains(user)
        cell.changeCircleImageView(isChecked)
        
        return cell
    }
    
    // MARK - CollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUsers.value.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserInvitationCollectionViewCell", forIndexPath: indexPath) as! UserInvitationCollectionViewCell
        let user = selectedUsers.value[indexPath.row]
        cell.fillWith(user)
        
        cell.cancelButton.bnd_tap.observe { event in // 高等テクニック
            self.selectedUsers.value.removeAtIndex(indexPath.item)
        }.disposeIn(cell.onReuseBag)
        
        return cell
    }
    
    func conformUser(user: User) {
        if let index = self.selectedUsers.value.indexOf(user) {
            self.selectedUsers.value.removeAtIndex(index)
        } else {
            self.selectedUsers.value.append(user)
        }
    }
    
}
