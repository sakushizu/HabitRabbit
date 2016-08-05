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
    
    private let selectUesrCollectionView = SelectedUserCollectionView()
    private let mModel = SelectedUserCollectionVM()
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(SelectUserTableViewCell.setCollectionView),
            name: "setCollectionViewNotification",
            object: nil
        )
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectUesrCollectionView.dataSource = mModel
        
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCollectionView() {
        self.addSubview(selectUesrCollectionView)
    }
    
}
