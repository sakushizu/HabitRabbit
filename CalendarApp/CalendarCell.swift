//
//  CalenderCellCollectionViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/21.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    var textLabel: UILabel!
    var imageView: UIImageView!
    var circleView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // UILabelを生成
        textLabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        textLabel.font = UIFont(name: "HiraKakuProN-W6", size: 12)
        textLabel.textAlignment = NSTextAlignment.Center
        // Cellに追加
        self.addSubview(textLabel!)
        
//        UIImageViewを作成する.
        imageView = UIImageView(frame: CGRectMake(0,0,30,30))
        // 表示する画像を設定する.
        let myImage = UIImage(named: "ハート.jpg")
        // 画像をUIImageViewに設定する.
        imageView!.image = myImage
//        画像の表示する座標を指定する.
        imageView!.layer.position = CGPoint(x: 25, y: 25)
        imageView!.contentMode = UIViewContentMode.ScaleAspectFill
        imageView!.clipsToBounds = true
        imageView.hidden = true
        self.addSubview(imageView!)
        
        circleView = UIView(frame: CGRectMake(0, 0, 30, 30))
        circleView.layer.position = CGPoint(x: 25, y: 25)
        circleView.backgroundColor = UIColor.clearColor()
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.clipsToBounds = true
        self.addSubview(circleView)
    }
}
