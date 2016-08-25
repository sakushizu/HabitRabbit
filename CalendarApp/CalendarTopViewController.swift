//
//  CalendarTopViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/20.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond
import BBBadgeBarButtonItem

enum CalendarTopCellType: Int {
    case User = 0
    case Calendar = 1
}

class CalendarTopViewController: UIViewController, UITableViewDelegate {
    
    let mModel = CalendarTopVM()
    var mView: CalendarTopView!
    private let alertViewController = AlertViewController()
    private var showing: Bool = false
    
    override func loadView() {
        self.view = CalendarTopView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! CalendarTopView
        mView.tableView.dataSource = mModel
        mView.tableView.delegate = self
        
        setNavigationBar()
        
        CurrentUser.sharedInstance.user.observe { user in
            self.mView.tableView.reloadData()
        }
        
        CalenderManager.sharedInstance.calendarCollection.observe { calendar in
            self.mView.tableView.reloadData()
        }
        
        UserInvitationManager.sharedInstance.calendars.observe { calendars in
            if calendars.count >= 0 {
                self.setNavigationBar()
            }
        }

    }
    
    // MARK - TableViewDelegate

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionType = CalendarTopCellType(rawValue: indexPath.section)!
        switch sectionType {
            
        case .User:
            return 80
        case .Calendar:
            return 70
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionType = CalendarTopCellType(rawValue: indexPath.section)!
        switch sectionType {
        case .Calendar:
            let calendar = CalenderManager.sharedInstance.calendarCollection.value[indexPath.row]
            StampedDateManager.sharedInstance.fetchStampedDates(calendar.id, completion: {
                let controller = UIStoryboard.viewControllerWith("Calendar", identifier: "CalendarViewController") as! CalendarViewController
                controller.mModel.selectedCalender = calendar
                self.navigationController?.pushViewController(controller, animated: true)
            })
        default:
            break
        }
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
    
    // MARK - Container
    
    func displayContentController(content: UIViewController){
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
    
    private func setNavigationBar() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.mainColor()
        let plusBarButton = UIBarButtonItem(image: UIImage(named: "plus"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.tappedPlusButton))
        let alertBarButton = createAlertBarButton()
        let rightItems = [plusBarButton, alertBarButton]
        self.navigationItem.setRightBarButtonItems(rightItems, animated: true)
        self.navigationItem.title = "Home"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mainColor()]//色変わらない
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.mainFontJa(17)]
        self.alertViewController.alertIconCentorX = alertBarButton.valueForKey("view")?.center.x
    }
    
    private func createAlertBarButton() -> UIBarButtonItem {
        let alertButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let alertImage = UIImage(named: "alert")!.imageWithRenderingMode(.AlwaysTemplate)
        alertButton.setImage(alertImage, forState: .Normal)
        alertButton.tintColor = UIColor.mainColor() 
        alertButton.addTarget(self, action: #selector(self.tappedAlertButton), forControlEvents: .TouchUpInside)
        alertButton.adjustsImageWhenHighlighted = false
        let alertBarButton = BBBadgeBarButtonItem(customUIButton: alertButton)
        alertBarButton.badgeValue = String(UserInvitationManager.sharedInstance.calendars.value.count)
        alertBarButton.badgeBGColor = UIColor.subColor()
        alertBarButton.badgeTextColor = UIColor.mainColor()
        alertBarButton.badgeOriginX = 12
        alertBarButton.badgePadding = 4
        alertBarButton.shouldAnimateBadge = true
        return alertBarButton
    }

}
