//
//  UIColor+Extension.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/22.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK - theme color
    class func mainColor() -> UIColor {
        return UIColor(red: 248.0 / 255, green: 151.0 / 255, blue: 190.0 / 255, alpha: 1)
    }
    
    class func subColor() -> UIColor {
        return UIColor(red: 255.0 / 255, green: 240.0 / 255, blue: 245.0 / 255, alpha: 0.9)

    }
    
    class func textColor() -> UIColor {
        return UIColor(red: 85.0 / 255, green: 85.0 / 255, blue: 85.0 / 255, alpha: 1)
    }
    
    // MARK - background color
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 0.8)
    }
    
    class func salmonPink() -> UIColor {
        return UIColor(red: 232.0 / 255, green: 142.0 / 255, blue: 146.0 / 255, alpha: 1)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 192.0 / 255, green: 57.0 / 255, blue: 43 / 255, alpha: 0.5)
    }
    
    class func verylightRed() -> UIColor {
        return UIColor(red: 255.0 / 255, green: 240.0 / 255, blue: 245.0 / 255, alpha: 1)
    }
    
    //category color
    class func lightPink() -> UIColor {
        return UIColor(red: 255.0 / 255, green: 186.0 / 255, blue: 192.0 / 255, alpha: 1)
    }
    
    class func lightOrange() -> UIColor {
        return UIColor(red: 241.0 / 255, green: 200.0 / 255, blue: 72.0 / 255, alpha: 1)
    }
    
    class func lightYellow() -> UIColor {
        return UIColor(red: 229.0 / 255, green: 228.0 / 255, blue: 73.0 / 255, alpha: 1)
    }
    
    class func lightGreen() -> UIColor {
        return UIColor(red: 158.0 / 255, green: 239.0 / 255, blue: 118.0 / 255, alpha: 1)
    }
    
    class func lightPerple() -> UIColor {
        return UIColor(red: 215.0 / 255, green: 214.0 / 255, blue: 245.0 / 255, alpha: 1)
    }
    
    class func lightWhiteBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 225.0 / 255, blue: 229.0 / 255, alpha: 1)
    }
    
    class func lightLightOrenge() -> UIColor {
        return UIColor(red: 243 / 255, green: 156.0 / 255, blue: 242.0 / 255, alpha: 1)
    }
    
    //tableViewの線
    class func lightlightGray() -> UIColor {
        return UIColor(red: 242.0 / 255, green: 242.0 / 255, blue: 242.0 / 255, alpha: 1)
    }
    //appのcolor
    class func appPinkColor() -> UIColor {
        return UIColor(red: 255.0 / 255, green: 163.0 / 255, blue: 164.0 / 255, alpha: 1)
    }
    
    class func appGrayColor() -> UIColor {
        return UIColor(red: 189.0 / 255, green: 195.0 / 255, blue: 199.0 / 255, alpha: 1)
    }
    
    class func hexStr (hexStr : NSString, let alpha : CGFloat) -> UIColor {
        let hexColor = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexColor as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
//            print("invalid hex string")
            return UIColor.whiteColor()
        }
    }
    
    //UIColorからRGBの取得
    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }

    
}
