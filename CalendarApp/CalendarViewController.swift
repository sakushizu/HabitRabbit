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

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, SideMenuDelegate, UIBarPositioningDelegate, UINavigationBarDelegate, UITextViewDelegate, MenuTableViewControllerToCalendarControllerDelegate {
    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today = NSDate()
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var sideMenu: SideMenu?
    var selectedCalender = CalenderManager.sharedInstance.calender
    
    @IBOutlet weak var baseView: UIView!
    var recordTableView: RecordTableView!
    var memoView: UIView!
    var memoTextView: UITextView!
    var settingView: UIView!

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
        
       let menuTableViewController =  MenuTableViewController()
        menuTableViewController.customeDelegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CalendarViewController.saveCaendarMemo), name: UIApplicationWillTerminateNotification, object: nil)
        
        segmentContol.hidden = true
        segmentRightLineView.hidden = true
        segmentLeftLineView.hidden = true
//        CalenderManager.sharedInstance.resetDefaults() //NSUserDefault初期化
        
        //tableViewに表示している名前の配列
        sideMenu = SideMenu(sourceView: self.view)
        sideMenu!.delegate = self
        sideMenu?.sideMenuTableViewController.customeDelegate = self
        
        
        calenderHeaderView.layer.cornerRadius = 2
        calenderHeaderView.clipsToBounds = true
        
        calendarYearLabel.text = changeHeaderTitle(selectedDate)
        calendarMonthLabel.text = monthArray[Int(changeHeaderMonth(selectedDate))! - 1]
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.whiteColor()
        calenderCollectionView.layer.cornerRadius = 2
        calenderCollectionView.clipsToBounds = true
        
        makeRecordView()
        makeMamoView()
        makeSettingView()
        
        memoView.hidden = true
        recordTableView.hidden = true
        settingView.hidden = true
        
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalendarCell
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
            cell.userInteractionEnabled = false
            cell.imageView.hidden = true
            cell.circleView.hidden = true
        case 1:
            cell.textLabel.text = dateManager.conversionDateFormat(indexPath)
            cell.userInteractionEnabled = true
            // UIImageViewをViewに追加する.
            if self.selectedCalender != nil {
                if jadgeIfCellTapped(indexPath) {
                    cell.imageView.sd_setImageWithURL(NSURL(string: selectedCalender.stampImageURL))
                    cell.imageView.hidden = false
                    cell.circleView.hidden = true
                } else {
                    cell.imageView.hidden = true
                    cell.circleView.hidden = true
                }
            } else {
                if cell.textLabel.text ==  dateManager.conversionDateFormatFromNSDate(today) {
                    cell.imageView.hidden = true
                    cell.circleView.backgroundColor = UIColor(red: 255.0 / 255, green: 163.0 / 255, blue: 164.0 / 255, alpha: 0.5)
                }
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
        if selectedCalender != nil {
            let tappedDate = dateManager.currentMonthOfDates[indexPath.row]
            let dates = Calendar.sharedInstance.selectedDates
            if Calendar.sharedInstance.type == "private" {
                if (dates[tappedDate] != nil) {
                    Calendar.sharedInstance.deletedate(tappedDate)
                } else {
                    Calendar.sharedInstance.appendSelectedDates(tappedDate)
                }
                self.calenderCollectionView.reloadData()
            } else {
                //parseに保存
                GroupCalendar.sharedInstance.saveTappedDate(tappedDate){ () -> Void in
                    if (dates[tappedDate] != nil) {
                        Calendar.sharedInstance.deletedate(tappedDate)
                    } else {
                        Calendar.sharedInstance.appendSelectedDates(tappedDate)
                    }
                    self.calenderCollectionView.reloadData()
                }
            }
            recordTableView.reloadData()
        }
    }
    
    //タップ済みかの判定
    func jadgeIfCellTapped(indexPath: NSIndexPath) -> Bool {
        let dates = Calendar.sharedInstance.selectedDates
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
            
            
        } else if indexPath.section == 1 {
            selectedCalender = CalenderManager.sharedInstance.calendarCollection[indexPath.row]
            Calendar.sharedInstance.type = "private"
            setSelectedCalendarView()
        } else {
            Calendar.sharedInstance.type = "group"
            setSelectedCalendarView()
        }
        setMemoViewLayer()
        recordTableView.reloadData()
        
    }
    
    //サイドバーの表示
    @IBAction func toggleSideMenu(sender: AnyObject) {
        sideMenu?.toggleMenu()
    }
    
    @IBAction func tappedCreateCalendarBtn(sender: UIBarButtonItem) {
        performSegueWithIdentifier("CreateCalendarViewController", sender: nil)
    }
    
    
    func setSelectedCalendarView() {
        
        let color = UIColor(
            red:  (CGFloat(selectedCalender.color_r))/255,
            green: (CGFloat(selectedCalender.color_g))/255,
            blue: (CGFloat(selectedCalender.color_b))/255,
            alpha: 1
        )

        calendarTitle.text = selectedCalender.title
//        Calendar.sharedInstance.object_id = selectedCalender.object_id
        Calendar.sharedInstance.title = selectedCalender.title
        calenderHeaderView.backgroundColor = color
        segmentContol.hidden = false
        segmentContol.tintColor = color
        segmentLeftLineView.hidden = false
        segmentLeftLineView.backgroundColor = color
        segmentRightLineView.hidden = false
        segmentRightLineView.backgroundColor = color
        Calendar.sharedInstance.fetchDates()
        if Calendar.sharedInstance.type == "group" {
            self.setRecordView()
        } else {
        }
        self.calenderCollectionView.reloadData()
        sideMenu?.toggleMenu()
    }

    
    @IBAction func segmentedControllerValueChanged(sender: UISegmentedControl) {
        
        for subView in baseView.subviews {
            subView.hidden = true
        }
        baseView.subviews[sender.selectedSegmentIndex].hidden = false
        
        if segmentContol.selectedSegmentIndex == 1 {
            self.recordTableView.reloadData()
            self.setRecordView()
        }
    }
    
    func setRecordView() {
        GroupCalendar.sharedInstance.fetchCalendarAttendantUser(selectedCalender) { () -> Void in
            GroupCalendar.sharedInstance.sortUserStampedCount()
            self.recordTableView.reloadData()
        }
    }
    
    func makeRecordView() {
        let frame = CGRectMake(0, calenderCollectionView.frame.origin.y + 44, self.calenderCollectionView.frame.width,calenderCollectionView.frame.height )
        self.recordTableView = RecordTableView(frame: frame, style: UITableViewStyle.Plain)
        baseView.addSubview(recordTableView)
    }
    
    func makeMamoView() {
        let memoViewFrame = CGRectMake(0, calenderCollectionView.frame.origin.y + 44, self.calenderCollectionView.frame.width, self.calenderCollectionView.frame.height)
        memoView = UIView(frame: memoViewFrame)
        memoView.backgroundColor = UIColor.whiteColor()
        memoView.layer.borderColor = UIColor.lightlightGray().CGColor
        memoView.layer.borderWidth = 1
        memoView.layer.cornerRadius = 3
        memoView.layer.masksToBounds = true
        let textFieldFrame = CGRectMake(15, 15, memoView.frame.width - 30, memoView.frame.height - 30 )
        memoTextView = UITextView(frame: textFieldFrame)
        memoTextView.textColor = UIColor.darkGrayColor()
        memoTextView.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        memoTextView.layer.borderWidth = 0.5
        memoTextView.layer.cornerRadius = 4
        memoTextView.clipsToBounds = true
        memoTextView.delegate = self
        memoView.addSubview(memoTextView)
        baseView.addSubview(memoView)
    }
    
    func setMemoViewLayer() {
        if selectedCalender?.color != nil {
            memoTextView.text = selectedCalender.memo
            memoTextView.tintColor = selectedCalender.color
            memoTextView.layer.borderColor = selectedCalender.color.CGColor
        }
    }
    
    func makeSettingView() {
        let frame = CGRectMake(0, calenderCollectionView.frame.origin.y + 44, self.calenderCollectionView.frame.width,calenderCollectionView.frame.height )
        self.settingView = UIView(frame: frame)
        baseView.addSubview(settingView)
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func saveCaendarMemo() {
        selectedCalender.memo = memoTextView.text
    }
    
    func moveUserEditViewController() {
        let storyboard = UIStoryboard(name: "UserEdit", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController()!
        self.presentViewController(nextVC, animated: true, completion: nil)
//        nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        navigationController?.pushViewController(nextVC, animated: true)
    }

}