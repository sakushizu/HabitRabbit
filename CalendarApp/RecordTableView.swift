//
//  RecordTableView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/22.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class RecordTableView: UITableView, UITableViewDataSource, UITableViewDelegate  {
    
    //ソースコードでインスタンスを生成した場合
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(UINib(nibName: "RankingTableViewCell", bundle: nil), forCellReuseIdentifier: "recordCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if Calender.sharedInstance.type == "private" {
            return 1
        } else {
            return 2
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return GroupCalendar.sharedInstance.userCountArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier("recordCell", forIndexPath: indexPath) as? RankingTableViewCell
        if indexPath.section == 0 {
            cell?.rankingNumLabel.hidden = true
            cell?.userNameLabel.text = CurrentUser.sharedInstance.user.name
            cell?.userImageView.image = CurrentUser.sharedInstance.user.userImage
            cell?.recordLabel.text = "\(Calender.sharedInstance.selectedDates.count)completions"
            return cell!
        } else {
            let userDic = GroupCalendar.sharedInstance.userCountArray[indexPath.row]
            for (user, count) in userDic {
                print(user.name)
                print(count)
//                cell?.rankingNumLabel.text = "\(indexPath.row + 1)"
                cell?.userImageView.image = user.userImage
                cell?.userNameLabel.text = user.name
                cell?.recordLabel.text = "\(String(count))completions"
            }
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
