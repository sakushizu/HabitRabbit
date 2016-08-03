//
//  UserInvitationView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/30.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class UserInvitationView: UIView {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var marginBottomOfTableView: NSLayoutConstraint!
    
    let collectionView = UserInvitationCollectionView()
    private let collectionViewHeight: CGFloat = 80
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.registerNib(UINib(nibName: "UserInvitationTableViewCell", bundle: nil), forCellReuseIdentifier: "UserInvitationTableViewCell")
        
        collectionView.registerNib(UINib(nibName: "UserInvitationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserInvitationCollectionViewCell")
        
        self.addSubview(collectionView)
        
        layoutTableView()
    }

    
    func toggleCollecionView(showing showing: Bool) {
        let y = showing ? self.frame.height - self.collectionViewHeight : self.frame.height
        UICollectionView.animateWithDuration(0.3) {
            self.collectionView.frame.origin = CGPointMake(0, y)
        }
    }
    
    func toggleTableViewHeight(collectionViewIsAppearing collectionViewIsAppearing: Bool) {
        marginBottomOfTableView.constant = collectionViewIsAppearing ? collectionViewHeight : 0
    }
    
    private func layoutTableView() {
        tableView.backgroundColor = UIColor.hexStr("F6F6F6", alpha: 1)
    }


}
