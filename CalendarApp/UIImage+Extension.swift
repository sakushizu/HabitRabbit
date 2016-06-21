//
//  UIImage+Extension.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/17.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Parse
import SDWebImage

extension UIImage {
    
    struct ImageSize {
        static let height: CGFloat = 600
    }
    
    //UIImageをPFFileに変換
    func createFileForm() -> PFFile! {
        let ratio = self.size.width / self.size.height
        let resizedImage = resizeImage(self, towidth: ImageSize.height * ratio, andHeight: ImageSize.height)
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)!
        return PFFile(name: "image.jpg", data: imageData)
    }
    
    //画像のデータサイズを変更
    func resizeImage(originalImage: UIImage, towidth width: CGFloat, andHeight height: CGFloat) -> UIImage {
        let newSize = CGSizeMake(width, height)
        let newRectangle = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(newSize)
        originalImage.drawInRect(newRectangle)
        
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
}
