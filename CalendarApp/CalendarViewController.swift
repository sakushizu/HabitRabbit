//
//  CalendarViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/24.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UITextViewDelegate {
    
    let mModel = CalendarVM()
    private var mView: CalendarView!
    
    private var selectedDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()

        mView = view as! CalendarView
        mView.collectionView.delegate = self
        mView.collectionView.dataSource = mModel
        
        mView.setCalendar(selectedDate)
        setButtonTarget()
        mView.setSelectedCalendarView(mModel.selectedCalender)
        setNotification()
        
        mView.setSelectedButton(mView.calendarButton)
        
        mView.textView.delegate = self
        

    }
    
    override func viewWillAppear(animated: Bool) {
        setNavigationBar()
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        
        let params = [
            "user_id": CurrentUser.sharedInstance.user.value!.id,
            "calendar_id": mModel.selectedCalender.id,
            ]
        Memo.sharedInstance.fetchMemo(params) {
            self.mView.memoText.value! = Memo.sharedInstance.memo
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveCalendarMemo()
    }
    
    // MARK - CollectionView Delegate
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let params = createCalendarParams(indexPath)
        
        if mModel.isTapped(indexPath.row) {

            self.mModel.stampedManager.deleteStampedDate(params, callback: {
                self.mModel.stampedManager.dateCollection.removeAtIndex(params["index"] as! Int)
                self.mView.collectionView.reloadItemsAtIndexPaths([indexPath])
            })
        } else {
            
            self.mModel.stampedManager.saveStampedDate(params, completion: {
                self.mView.collectionView.reloadItemsAtIndexPaths([indexPath])
            })
        }
    }
    
    
    // MARK -> CollectionViewLayout header size
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionReusableView, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionType = CalendarCollectionCellType(rawValue: section)!
        switch sectionType {
        case .Day:
            return CGSize(width: mView.collectionView.frame.width, height: 15)
        default:
            return CGSizeZero
        }
    }

    func tappedCalendarBackButton() {
        selectedDate = mModel.dateManager.prevMonth(selectedDate)
        mView.setTappedCalendar(selectedDate)
        
    }
    
    func tappedCalendarNextButton() {
        selectedDate = mModel.dateManager.nextMonth(selectedDate)
        mView.setTappedCalendar(selectedDate)
    }
    
    func tappedEditCalendarButton() {
        let controller = UIStoryboard.viewControllerWith("EditCalendar", identifier: "EditCalendarViewController") as! EditCalendarViewController
        let navigationController = UINavigationController(rootViewController: controller)
        controller.mModel.selectedCalendar.value = self.mModel.selectedCalender.copy() as? Calendar
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func setUpdateCalendar(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            mModel.selectedCalender = userInfo["calendar"] as? Calendar
            self.mView.setSelectedCalendarView(mModel.selectedCalender)
        }
    }
    
    func tappedCalendarButton(button: UIButton) {

        mView.setSelectedButton(button)
        mView.setCalendar(selectedDate)
    }
    
    func tappedRankingButton(button: UIButton) {
        self.mView.setSelectedButton(button)
        StampedDateManager.sharedInstance.fetchMembersStampedDatesRanking(mModel.selectedCalender.id) {
            self.mView.rankingView.reloadData()
        }
    }
    
    func tappedMemoButton(button: UIButton) {
        mView.setSelectedButton(button)
    }
    
    func saveCalendarMemo() {
        let params = [
            "user_id": CurrentUser.sharedInstance.user.value!.id,
            "calendar_id": mModel.selectedCalender.id,
            "memo": mView.memoText.value!
        ]
        Memo.sharedInstance.saveMemo(params as! [String : AnyObject]) { }
    }
    func tappedCloseButton() {
        mView.textView.resignFirstResponder()
    }
    
    private func setButtonTarget() {
        mView.backMonthButton.addTarget(self, action: #selector(self.tappedCalendarBackButton), forControlEvents: .TouchUpInside)
        mView.nextMonthButton.addTarget(self, action: #selector(self.tappedCalendarNextButton), forControlEvents: .TouchUpInside)
        mView.editCalendarButton.addTarget(self, action: #selector(self.tappedEditCalendarButton), forControlEvents: .TouchUpInside)
        
        mView.calendarButton.addTarget(self, action: #selector(self.tappedCalendarButton(_:)), forControlEvents: .TouchUpInside)
        mView.rankingButton.addTarget(self, action: #selector(self.tappedRankingButton(_:)), forControlEvents: .TouchUpInside)
        mView.memoButton.addTarget(self, action: #selector(self.tappedMemoButton(_:)), forControlEvents: .TouchUpInside)
        mView.closeButton.addTarget(self, action: #selector(self.tappedCloseButton), forControlEvents: .TouchUpInside)
    }
    
    private func createCalendarParams(indexPath: NSIndexPath) -> [String: AnyObject] {
        var index: Int
        let tappedDate = self.mModel.dateManager.currentMonthOfDates[indexPath.row]
        var params: [String: AnyObject] = [
            "date": tappedDate,
            "calendar_id": self.mModel.selectedCalender.id
        ]
        for tmpDate in self.mModel.stampedManager.dateCollection {
            if tmpDate.date == tappedDate {
                index = self.mModel.stampedManager.dateCollection.indexOf({$0 === tmpDate})!
                params["id"] = tmpDate.id
                params["index"] = index
            }
        }
        return params
    }
    
    private func setNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.setUpdateCalendar(_:)),
            name: "updateCalendarNotification",
            object: nil
        )
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: #selector(self.saveCalendarMemo),
            name:UIApplicationDidEnterBackgroundNotification,
            object: nil)
    }
    
    private func setNavigationBar() {
        self.navigationController?.hidesNavigationBarHairline = true
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = mView.calendarColor

    }
    

}
