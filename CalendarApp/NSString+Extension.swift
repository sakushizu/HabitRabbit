//
//  NSString+Extension.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/18.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

extension String {
    
    static func random(length: Int = 20) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }
        
        return randomString
    }
}