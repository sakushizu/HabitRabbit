//
//  JoinViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/07.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController {
    
    static let nibName = "JoinViewController"
    
    private var mView: JoinView!
    private let mModel = JoinVM()
    var calendar: Calendar!

    
    override func loadView() {
        self.view = JoinView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! JoinView
        mView.joinedUserCollectionView.dataSource = mModel
        
        mView.joinButton.addTarget(self, action: #selector(JoinViewController.tappedJoinButton), forControlEvents: .TouchUpInside)
        mView.noButton.addTarget(self, action: #selector(JoinViewController.tappedNoButton), forControlEvents: .TouchUpInside)
        mModel.users = calendar.joinedUsers
        
        setNabiBarItem()
        
        
    }
    
    func tappedJoinButton() {
        let params: [String:Int] = [
            "calendar_id": calendar.id,
            "user_id": CurrentUser.sharedInstance.user.value!.id
        ]
        CalenderManager.sharedInstance.joinCalendar(params) {
            UserInvitationManager.sharedInstance.fetchInvitationCalendars(completion: { 
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func tappedNoButton() {
        let params: [String:Int] = [
            "calendar_id": calendar.id,
            "user_id": CurrentUser.sharedInstance.user.value!.id
        ]
        CalenderManager.sharedInstance.rejectInvitation(params) {
            UserInvitationManager.sharedInstance.fetchInvitationCalendars(completion: { 
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func tappedCancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setNabiBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.tappedCancelButton))
    }
    


    

}
