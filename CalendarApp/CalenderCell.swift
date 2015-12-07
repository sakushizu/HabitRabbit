//
//  CalenderCellCollectionViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/21.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalenderCell: UICollectionViewCell {
    @IBOutlet var title :UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
////        UIImageViewを作成する.
//        imageView = UIImageView(frame: CGRectMake(0,0,30,30))
//        // 表示する画像を設定する.
//        let myImage = UIImage(named: "ハート.jpg")
//        // 画像をUIImageViewに設定する.
//        imageView!.image = myImage
////        画像の表示する座標を指定する.
//        imageView!.layer.position = CGPoint(x: 25, y: 25)
//        imageView!.contentMode = UIViewContentMode.ScaleAspectFill
//        imageView!.clipsToBounds = true
//        self.addSubview(imageView!)
//        print(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
}
