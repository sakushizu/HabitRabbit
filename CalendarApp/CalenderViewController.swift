//
//  ViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/08.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Foundation

class CalenderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let date = Date()
    
    let DaysPerWeek: Int = 7
    let CellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today: NSDate!
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerRightBtn: UIButton!
    @IBOutlet weak var headerLeftBtn: UIButton!
    @IBOutlet weak var calenderHeaderView: UIView!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let createButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createCalendar:")
        self.navigationItem.setRightBarButtonItem(createButton, animated: true)
        self.navigationItem.title = Calender.sharedInstance.title
       
//        Calender.sharedInstance.selectedDates.removeAll()
//        Calender.sharedInstance.save()
        
        Calender.sharedInstance.fetchDates()
        
        // Do any additional setup after loading the view, typically from a nib.
        headerTitle.text = changeHeaderTitle(selectedDate)
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.whiteColor()
    }
//    
//    override func viewWillAppear(animated: Bool) {
//        let createButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createCalendar:")
//        self.navigationItem.setRightBarButtonItem(createButton, animated: true)
//        self.navigationItem.title = Calender.sharedInstance.title
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        switch(section){
        case 0:
            return 7
        case 1:
            return date.daysAcquisition()
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CalenderCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalenderCell
        //テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.title.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.title.textColor = UIColor.lightBlue()
        } else {
            cell.title.textColor = UIColor.lightGrayColor()
        }
        //テキスト配置
        switch(indexPath.section){
        case 0:
            let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fry", "Sat"]
            cell.title.text = weekArray[indexPath.row]
            cell.backgroundColor = UIColor.whiteColor()
            cell.imageView.hidden = true
        case 1:
            cell.title.text = date.conversionDateFormat(indexPath)
            cell.imageView?.image = UIImage(named: "ハート.jpg")
            // UIImageViewをViewに追加する.
            //背景色変更
            if jadgeIfCellTapped(indexPath) {
                cell.imageView.hidden = false
            } else {
                cell.imageView.hidden = true
            }
        default:
            cell.imageView.hidden = true
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch(indexPath.section) {
        case 0:
            let numberOfMargin: CGFloat = 8.0
            let width: CGFloat = (collectionView.frame.size.width - CellMargin * numberOfMargin) / CGFloat(DaysPerWeek)
            let height: CGFloat = 50
            return CGSizeMake(width, height)
        case 1:
            let numberOfMargin: CGFloat = 8.0
            let width: CGFloat = (collectionView.frame.size.width - CellMargin * numberOfMargin) / CGFloat(DaysPerWeek)
            let height: CGFloat = width * 1.0
            return CGSizeMake(width, height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    //セルがタップされた時に呼ばれるメソッド
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let tappedDate = date.currentMonthOfDates[indexPath.row]
        let dates = Calender.sharedInstance.selectedDates
        if (dates[tappedDate] != nil) {
            Calender.sharedInstance.deletedate(tappedDate)
        } else {
            Calender.sharedInstance.appendSelectedDates(tappedDate)
        }
        self.calenderCollectionView.reloadData()
    }
    
    //タップ済みかの判定
    func jadgeIfCellTapped(indexPath: NSIndexPath) -> Bool {
        let dates = Calender.sharedInstance.selectedDates
        for dateDic in dates.keys {
            if dateDic == date.currentMonthOfDates[indexPath.row] {
                return true
            }
        }
        return false
    }

    //セルのマージン
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellMargin
    }
    
    //セルのマージン
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellMargin
    }
    
    //headerの月を変更
    func changeHeaderTitle(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "M/yyyy"
        let selectMonth = formatter.stringFromDate(date)
        return selectMonth
    }
    
    func createCalendar(sender: UIButton) {
        Calender.sharedInstance.title = "running"
        self.navigationItem.title = Calender.sharedInstance.title
        Calender.sharedInstance.fetchDates()
        self.calenderCollectionView.reloadData()
    }
    
    //次月の表示ボタン
    @IBAction func tappedHeaderRightBtn(sender: UIButton) {
        selectedDate = date.nextMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
    }
    
    //前月の表示ボタン
    @IBAction func tappedheaderLeftBtn(sender: UIButton) {
        selectedDate = date.prevMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
    }
    

}