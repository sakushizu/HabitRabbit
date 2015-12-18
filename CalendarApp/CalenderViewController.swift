//
//  ViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/08.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Foundation
import Parse

class CalenderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, SideMenuDelegate {
    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today: NSDate!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var sideMenu: SideMenu?
    var titleArray = CalenderManager.sharedInstance.titles
    var selectedCalender = CalenderManager.sharedInstance.calender
    
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var headerRightBtn: UIButton!
    @IBOutlet weak var headerLeftBtn: UIButton!
    @IBOutlet weak var calenderHeaderView: UIView!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CalenderManager.sharedInstance.fetchCalendarCollection()
//        CalenderManager.sharedInstance.calendarCollection.removeAll()
//        CalenderManager.sharedInstance.titles.removeAll()
        
        //tableViewに表示している名前の配列
        sideMenu = SideMenu(sourceView: self.view)
        sideMenu!.delegate = self

        let createButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createCalendar:")
        self.navigationItem.setRightBarButtonItem(createButton, animated: true)
        self.navigationItem.title = Calender.sharedInstance.title

        // Do any additional setup after loading the view, typically from a nib.
        headerTextLabel.text = changeHeaderTitle(selectedDate)
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.whiteColor()
        
        }
    
    override func viewWillAppear(animated: Bool) {
    
    }

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
            return dateManager.daysAcquisition()
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalenderCell
        //テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
        } else {
            cell.textLabel.textColor = UIColor.lightGrayColor()
        }
        //テキスト配置
        switch(indexPath.section){
        case 0:
            cell.textLabel.text = weekArray[indexPath.row]
            cell.imageView.hidden = true
        case 1:
            cell.textLabel.text = dateManager.conversionDateFormat(indexPath)
            // UIImageViewをViewに追加する.
            if jadgeIfCellTapped(indexPath) {
                cell.imageView.image = selectedCalender.image
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
            let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
            let height: CGFloat = 50
            return CGSizeMake(width, height)
        case 1:
            let numberOfMargin: CGFloat = 8.0
            let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
            let height: CGFloat = width * 1.0
            return CGSizeMake(width, height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    //セルがタップされた時に呼ばれるメソッド
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let tappedDate = dateManager.currentMonthOfDates[indexPath.row]
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
            if dateDic == dateManager.currentMonthOfDates[indexPath.row] {
                return true
            }
        }
        return false
    }

    //セルのマージン
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    //セルのマージン
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    //headerの月を変更
    func changeHeaderTitle(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.dateFormat = "M/yyyy"
        let selectMonth = formatter.stringFromDate(date)
        return selectMonth
    }
    
    //カレンダー新規作成ボタン
    func createCalendar(sender: UIButton) {
        performSegueWithIdentifier("CreateCalendarViewController", sender: nil)
    }
    
    
    //次月の表示ボタン
    @IBAction func tappedHeaderRightBtn(sender: UIButton) {
        selectedDate = dateManager.nextMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTextLabel.text = changeHeaderTitle(selectedDate)
    }
    
    //前月の表示ボタン
    @IBAction func tappedheaderLeftBtn(sender: UIButton) {
        selectedDate = dateManager.prevMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTextLabel.text = changeHeaderTitle(selectedDate)
    }
    
    ////サイドバーのセルがタップされた時の処理
    func sideMenuDidSelectItemAtIndex(indexPath: NSIndexPath) {
        if (indexPath.section == 0) && (indexPath.row == 0) {
            PFUser.logOut()
            CurrentUser.sharedInstance.user = nil
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        selectedCalender = CalenderManager.sharedInstance.calendarCollection[indexPath.row]
        self.navigationItem.title = selectedCalender.title
        Calender.sharedInstance.title = selectedCalender.title
        calenderHeaderView.backgroundColor = selectedCalender.color
        Calender.sharedInstance.fetchDates()
        self.calenderCollectionView.reloadData()
        sideMenu?.toggleMenu()
    }
    
    //サイドバーの表示
    @IBAction func toggleSideMenu(sender: AnyObject) {
        sideMenu?.toggleMenu()
    }

    

}