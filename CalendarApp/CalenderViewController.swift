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



class CalenderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, SideMenuDelegate, UIBarPositioningDelegate, UINavigationBarDelegate {
    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today: NSDate!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var sideMenu: SideMenu?
    var selectedCalender = CalenderManager.sharedInstance.calender
    
    var recordTableView: RecordTableView!
    var memoView: UIView!
    
//    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var headerRightBtn: UIButton!
    @IBOutlet weak var headerLeftBtn: UIButton!
    @IBOutlet weak var calenderHeaderView: UIView!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    @IBOutlet weak var calendarNavBar: UINavigationBar!
    
    @IBOutlet weak var calendarTitle: UILabel!
    @IBOutlet weak var calendarMonthLabel: UILabel!
    @IBOutlet weak var calendarYearLabel: UILabel!

    
    
    
    @IBOutlet weak var segmentContol: UISegmentedControl!
    @IBOutlet weak var segmentLeftLineView: UIView!
    @IBOutlet weak var segmentRightLineView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (PFUser.currentUser() == nil) && (CurrentUser.sharedInstance.type != "guest") {
            performSegueWithIdentifier("topView", sender: nil)
        }
        
        segmentContol.hidden = true
        segmentRightLineView.hidden = true
        segmentLeftLineView.hidden = true
//        CalenderManager.sharedInstance.resetDefaults()
        CalenderManager.sharedInstance.fetchCalendarCollection()
        
        //tableViewに表示している名前の配列
        sideMenu = SideMenu(sourceView: self.view)
        sideMenu!.delegate = self
        
        calenderHeaderView.layer.cornerRadius = 2
        calenderHeaderView.clipsToBounds = true
        
        calendarYearLabel.text = changeHeaderTitle(selectedDate)
        calendarMonthLabel.text = monthArray[Int(changeHeaderMonth(selectedDate))! - 1]
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.whiteColor()
        calenderCollectionView.layer.cornerRadius = 2
        calenderCollectionView.clipsToBounds = true
        
        let frame = CGRectMake(self.calenderCollectionView.frame.origin.x, self.calenderCollectionView.frame.origin.y - 44, self.calenderCollectionView.frame.width, self.calenderCollectionView.frame.height)
        self.recordTableView = RecordTableView(frame: frame, style: UITableViewStyle.Plain)
        
        let memoViewFrame = CGRectMake(self.calenderCollectionView.frame.origin.x + 13, self.calenderCollectionView.frame.origin.y + 13 - 44, self.calenderCollectionView.frame.width - 26, self.calenderCollectionView.frame.height - 26)
        memoView = UIView(frame: memoViewFrame)
        
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
        if Calender.sharedInstance.type == "private" {
            if (dates[tappedDate] != nil) {
                Calender.sharedInstance.deletedate(tappedDate)
            } else {
                Calender.sharedInstance.appendSelectedDates(tappedDate)
            }
            self.calenderCollectionView.reloadData()
        } else {
            //parseに保存
            GroupCalendar.sharedInstance.saveTappedDate(tappedDate){ () -> Void in
                if (dates[tappedDate] != nil) {
                    Calender.sharedInstance.deletedate(tappedDate)
                } else {
                    Calender.sharedInstance.appendSelectedDates(tappedDate)
                }
                self.calenderCollectionView.reloadData()
            }
        }
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
    
    //yearを変更
    func changeHeaderTitle(date: NSDate) -> String {
        let yearFormatter: NSDateFormatter = NSDateFormatter()
        yearFormatter.locale = NSLocale(localeIdentifier: "en_US")
        yearFormatter.dateFormat = "yyyy"
        let selectYear = yearFormatter.stringFromDate(date)
        return selectYear
    }
    
    //monthを変更
    func changeHeaderMonth(date: NSDate) -> String {
        let monthFormatter: NSDateFormatter = NSDateFormatter()
        monthFormatter.locale = NSLocale(localeIdentifier: "en_US")
        monthFormatter.dateFormat = "M"
        let selectMonth = monthFormatter.stringFromDate(date)
        return selectMonth
    }
    
    //カレンダー新規作成ボタン
//    func createCalendar(sender: UIButton) {
//        performSegueWithIdentifier("CreateCalendarViewController", sender: nil)
//    }
    
    
    //次月の表示ボタン
    @IBAction func tappedHeaderRightBtn(sender: UIButton) {
        selectedDate = dateManager.nextMonth(selectedDate)
        calenderCollectionView.reloadData()
        calendarYearLabel.text = changeHeaderTitle(selectedDate)
        calendarMonthLabel.text = monthArray[Int(changeHeaderMonth(selectedDate))! - 1]
    }
    
    //前月の表示ボタン
    @IBAction func tappedheaderLeftBtn(sender: UIButton) {
        selectedDate = dateManager.prevMonth(selectedDate)
        calenderCollectionView.reloadData()
        calendarYearLabel.text = changeHeaderTitle(selectedDate)
        calendarMonthLabel.text = monthArray[Int(changeHeaderMonth(selectedDate))! - 1]
    }
    
    ////サイドバーのセルがタップされた時の処理
    func sideMenuDidSelectItemAtIndex(indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            PFUser.logOut()
            CurrentUser.sharedInstance.user = nil
            performSegueWithIdentifier("topView", sender: nil)
            
        } else if indexPath.section == 1 {
            selectedCalender = CalenderManager.sharedInstance.calendarCollection[indexPath.row]
            Calender.sharedInstance.type = "private"
            setSelectedCalendarView()
        } else {
            selectedCalender = CalenderManager.sharedInstance.groupCalendarCollection[indexPath.row]
            Calender.sharedInstance.type = "group"
            setSelectedCalendarView()
        }
    }
    
    //サイドバーの表示
    @IBAction func toggleSideMenu(sender: AnyObject) {
        sideMenu?.toggleMenu()
    }
    
    @IBAction func tappedCreateCalendarBtn(sender: UIBarButtonItem) {
        performSegueWithIdentifier("CreateCalendarViewController", sender: nil)
    }
    
    
    func setSelectedCalendarView() {
//        self.calendarNavBar.backgroundColor = selectedCalender.color
        calendarTitle.text = selectedCalender.title
        Calender.sharedInstance.object_id = selectedCalender.object_id
        Calender.sharedInstance.title = selectedCalender.title
        calenderHeaderView.backgroundColor = selectedCalender.color
        segmentContol.hidden = false
        segmentContol.tintColor = selectedCalender.color
        segmentLeftLineView.hidden = false
        segmentLeftLineView.backgroundColor = selectedCalender.color
        segmentRightLineView.hidden = false
        segmentRightLineView.backgroundColor = selectedCalender.color
        Calender.sharedInstance.fetchDates()
        if Calender.sharedInstance.type == "group" {
            self.setRecordView()
        } else {
            let frame = CGRectMake(self.calenderCollectionView.frame.origin.x, self.calenderCollectionView.frame.origin.y, self.calenderCollectionView.frame.width, self.calenderCollectionView.frame.height)
            self.recordTableView = RecordTableView(frame: frame, style: UITableViewStyle.Plain)
        }
        self.calenderCollectionView.reloadData()
        sideMenu?.toggleMenu()
    }

//    
//    @IBAction func segmentedControllerValueChanged(sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            whiteView.removeFromSuperview()
//        case 1:
//            whiteView = recordTableView
//        case 2:
//            whiteView.removeFromSuperview()
//            calenderCollectionView.addSubview(whiteView)
//            setMamoView()
//        case 3:
//            whiteView.removeFromSuperview()
//            
//        default:
//            break
//        }
//        
//        
//    }
    
    func setRecordView() {
        GroupCalendar.sharedInstance.fetchCalendarAttendantUser(selectedCalender) { () -> Void in
            GroupCalendar.sharedInstance.sortUserStampedCount()
            self.recordTableView.reloadData()
        }
    }
    
    func setMamoView() {
//        let frame = CGRectMake(self.calenderCollectionView.frame.origin.x + 13, self.calenderCollectionView.frame.origin.y + 13, self.calenderCollectionView.frame.width - 26, self.calenderCollectionView.frame.height - 26)
//        memoView = UIView(frame: frame)
        memoView.backgroundColor = UIColor.whiteColor()
        memoView.layer.borderColor = UIColor.lightlightGray().CGColor
        memoView.layer.borderWidth = 1
        memoView.layer.cornerRadius = 3
        memoView.layer.masksToBounds = true
        let textFieldFrame = CGRectMake(15, 15, memoView.frame.width - 30, memoView.frame.height - 30 )
        let memoTextView = UITextView(frame: textFieldFrame)
        memoTextView.textColor = UIColor.darkGrayColor()
        memoTextView.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        memoTextView.tintColor = selectedCalender.color
        memoView.addSubview(memoTextView)
    }
    

}