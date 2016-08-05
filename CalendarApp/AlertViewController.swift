//
//  AlertViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/04.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController, UITableViewDelegate {
    
    private let mModel = AlertVM()
    private var mView: AlertView!

    override func loadView() {
        self.view = AlertView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mView = view as! AlertView

        mView.tableView.dataSource = mModel
        mView.tableView.delegate = self
    
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

        
    }
    
    private func createHeaderView() -> UIView {
        let header = UIView()
        header.backgroundColor = UIColor.subColor()
        return header
    }

}
