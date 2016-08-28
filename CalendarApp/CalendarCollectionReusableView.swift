//
//  CalendarCollectionReusableView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/24.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalendarCollectionReusableView: UICollectionReusableView {
    
    static let nibName = "CalendarCollectionReusableView"
    let lineView = UIView()
    
    override init(frame: CGRect) {
        let frame = CGRectZero
        super.init(frame: frame)
        self.addSubview(lineView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layoutLineView()
    }
    
    private func layoutLineView() {
        lineView.frame = CGRect(x: 10, y: 0, width: self.frame.width - 20, height: 0.5)
        lineView.backgroundColor = UIColor.cellLineColor()
    }
        
}
