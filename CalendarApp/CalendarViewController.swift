//
//  ViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/08.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Foundation
import Bond

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, SideMenuDelegate, UIBarPositioningDelegate, UINavigationBarDelegate, UITextViewDelegate, MenuTableViewControllerToCalendarControllerDelegate {
    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var selectedCalender: Calendar!
    let stampedManager = StampedDateManager.sharedInstance
    var today = NSDate()
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var sideMenu: SideMenu?
    
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
    
    let alertViewController = AlertViewController()
    private var showing: Bool = false

    
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
        
        // MARK - ここから編集
        setNavigationBar()
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //container
    func displayContentController(content:UIViewController){
        addChildViewController(content)
        content.view.frame = content.view.bounds
        self.view.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }
    
    func hideContentController(content:UIViewController){
        content.willMoveToParentViewController(self)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
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
        
        let params = createCalendarParams(indexPath)

        if jadgeIfCellTapped(indexPath) {
            //削除
            stampedManager.deleteStampedDate(params, callback: {
                self.stampedManager.dateCollection.removeAtIndex(params["index"] as! Int)
                self.calenderCollectionView.reloadItemsAtIndexPaths([indexPath])
                self.recordTableView.reloadData()
            })
        } else {
            //追加
            stampedManager.saveStampedDate(params, completion: {
                self.calenderCollectionView.reloadItemsAtIndexPaths([indexPath])
                self.recordTableView.reloadData()
            })
        }
    }
    
    private func createCalendarParams(indexPath: NSIndexPath) -> [String: AnyObject] {
        var index: Int
        let tappedDate = dateManager.currentMonthOfDates[indexPath.row]
        var params: [String: AnyObject] = [
            "date": tappedDate,
            "calendar_id": selectedCalender.id
        ]
        for tmpDate in stampedManager.dateCollection {
            if tmpDate.date == tappedDate {
                index = stampedManager.dateCollection.indexOf({$0 === tmpDate})!
                params["id"] = tmpDate.id
                params["index"] = index
            }
        }
        return params
    }
    
    //タップ済みかの判定
    private func jadgeIfCellTapped(indexPath: NSIndexPath) -> Bool {
        let dates = stampedManager.dateCollection
        for date in dates {
            if date.date == dateManager.currentMonthOfDates[indexPath.row] {
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
        selectedCalender = CalenderManager.sharedInstance.calendarCollection[indexPath.row]
        stampedManager.fetchStampedDates(selectedCalender.id) { 
            self.setSelectedCalendarView()
            self.recordTableView.reloadData()
        }
    }
    
    //サイドバーの表示
    func toggleSideMenu(sender: AnyObject) {
        sideMenu?.toggleMenu()
    }
    

    
    
    // MARK: - ビューの装飾
    func setSelectedCalendarView() {
        
        let color = UIColor(
            red:  (CGFloat(selectedCalender.color_r))/255,
            green: (CGFloat(selectedCalender.color_g))/255,
            blue: (CGFloat(selectedCalender.color_b))/255,
            alpha: 1
        )

        calendarTitle.text = selectedCalender.title

        calenderHeaderView.backgroundColor = color
        segmentContol.hidden = false
        segmentContol.tintColor = color
        segmentLeftLineView.hidden = false
        segmentLeftLineView.backgroundColor = color
        segmentRightLineView.hidden = false
        segmentRightLineView.backgroundColor = color
        self.setRecordView()
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
    
    //MERK: -カレンダーに参加しているUserの取得
    private func setRecordView() {
        
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
        let screenSize = UIScreen.mainScreen().bounds
        let textFieldFrame = CGRectMake(15, 15, screenSize.width - 30, screenSize.height - 30 )
        memoTextView = UITextView(frame: textFieldFrame)
        memoTextView.textColor = UIColor.darkGrayColor()
        memoTextView.font = UIFont.mainFontJa(14)
        memoTextView.layer.borderWidth = 0.5
        memoTextView.layer.cornerRadius = 4
        memoTextView.clipsToBounds = true
        memoTextView.delegate = self
        memoView.addSubview(memoTextView)
        baseView.addSubview(memoView)
    }
    
    // MARK: - 後で行う「メモの処理」
//    func setMemoViewLayer() {
//        if selectedCalender?.color != nil {
//            memoTextView.text = selectedCalender.memo
//            memoTextView.tintColor = selectedCalender.color
//            memoTextView.layer.borderColor = selectedCalender.color.CGColor
//        }
//    }
    
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

    }
    
    func moveUserEditViewController() {
        let storyboard = UIStoryboard(name: "UserEdit", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController()!
        self.presentViewController(nextVC, animated: true, completion: nil)

    }
    
    func tappedAlertButton() {
        //container
        
        if showing {
            self.hideContentController(self.alertViewController)
            showing = false
        } else {
            self.displayContentController(self.alertViewController)
            showing = true
            
        }

    }
    
    func tappedPlusButton() {
        let createCalenderVC = UIStoryboard.viewControllerWith("CreateCalendar", identifier: "createCalendarView") as! CreateCalendarViewController
        self.navigationController?.pushViewController(createCalenderVC, animated: true)
    }
    
    private func setNavigationBar() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        
        let createCalendarItem = UIBarButtonItem(image: UIImage(named: "plus"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CalendarViewController.tappedPlusButton))
        let appointItem = UIBarButtonItem(image: UIImage(named: "appointmentReminder"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CalendarViewController.tappedAlertButton))
        
        let rightItem = [createCalendarItem, appointItem]
        
        self.navigationItem.setRightBarButtonItems(rightItem, animated: true)
        print(appointItem.valueForKey("view")?.center)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CalendarViewController.toggleSideMenu(_:)))
        
    }
    


}