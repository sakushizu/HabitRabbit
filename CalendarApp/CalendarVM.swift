//
//  CalendarVM.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/24.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

enum CalendarCollectionCellType: Int {
    case Week = 0
    case Day = 1
}

class CalendarVM: NSObject, UICollectionViewDataSource {
    
    var selectedCalender: Calendar!
    let dateManager = DateManager()
    let stampedManager = StampedDateManager.sharedInstance

    

    // MARK - CollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = CalendarCollectionCellType(rawValue: section)!
        switch sectionType {
        case .Week:
            return 7
        case .Day:
            return dateManager.daysAcquisition()
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarCollectionViewCell", forIndexPath: indexPath) as! CalendarCollectionViewCell
        
        let sectionType = CalendarCollectionCellType(rawValue: indexPath.section)!
        cell.setTextColor(indexPath.row)

        //テキスト配置
        switch sectionType {
        case .Week:
            cell.setWeekCell(indexPath.row)
        case .Day:
            let day = dateManager.conversionDateFormat(indexPath)
            cell.setDayCell(day, isTapped: isTapped(indexPath.row), imageURL: selectedCalender.stampImageURL)
        }

        return cell
    }
    
    // MARK -> CollectionView header
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: CalendarCollectionReusableView.nibName, forIndexPath: indexPath) as! CalendarCollectionReusableView
            return headerReusableView
        } else {
            return UICollectionReusableView()
        }
    }
    
    //タップ済みかの判定
    func isTapped(day: Int) -> Bool {
        let dates = stampedManager.dateCollection
        for date in dates {
            if date.date == dateManager.currentMonthOfDates[day] {
                return true
            }
        }
        return false
    }
    
}
