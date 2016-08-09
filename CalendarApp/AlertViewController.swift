//
//  AlertViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/04.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class AlertViewController: UIViewController, UITableViewDelegate {
    
    var mView: AlertView!
    var AlertIconCentorX: CGFloat!
    private let mModel = AlertVM()

    override func loadView() {
        self.view = AlertView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! AlertView

        mView.tableView.dataSource = mModel
        mView.tableView.delegate = self
    
    override func viewDidLayoutSubviews() {
        mView.triangleImageView.center.x = AlertIconCentorX
    }
    
    // MARK - TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let joinVC = JoinViewController()
        let navigationController = UINavigationController(rootViewController: joinVC)
        joinVC.calendar = UserInvitationManager.sharedInstance.calendars.value[indexPath.row]
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    private func createHeaderView() -> UIView {
        let header = UIView()
        header.backgroundColor = UIColor.subColor()
        return header
    }

}
