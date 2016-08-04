//
//  AlertViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/04.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    private let mModel = AlertVM()
    private var mView: AlertView!

    override func loadView() {
        self.view = AlertView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! AlertView

        mView.tableView.dataSource = mModel
        

    }

}
