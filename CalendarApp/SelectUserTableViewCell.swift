//
//  SelectUserTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/02.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class SelectUserTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usesIconImageView: UIImageView!
    
    let selectUesrCollectionView = SelectedUserCollectionView()
    let mModel = SelectedUserCollectionVM()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectUesrCollectionView.dataSource = mModel
        self.addSubview(selectUesrCollectionView)
        selectUesrCollectionView.hidden = true

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(SelectUserTableViewCell.setCollectionView),
            name: "setCollectionViewNotification",
            object: nil
        )
    }
    
    func setCollectionView() {
        selectUesrCollectionView.hidden = false
    }
    
}
