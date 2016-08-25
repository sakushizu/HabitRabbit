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
        return 2
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.baseGrayColor()
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width, height: 40))
        label.font = UIFont.mainFontJa(15)
        label.textColor = UIColor.darkGrayColor()
        coverView.addSubview(label)
        if section == 0 {
            label.text = "User record"
            return coverView
        } else {
            label.text = "Ranking"
            return coverView
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //MARK カレンダ―に参加しているUserのCount
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier("recordCell", forIndexPath: indexPath) as? RankingTableViewCell
        if CurrentUser.sharedInstance.user.value != nil {
            if indexPath.section == 0 {
                cell?.rankingNumLabel.hidden = true
                cell?.fillWith(CurrentUser.sharedInstance.user.value!)
                return cell!
            } else {
                //MARK: -参加しているUserのランキング表示
//                let userDic = GroupCalendar.sharedInstance.userCountArray[indexPath.row]
//                for (user, count) in userDic {
//                cell?.fillWith(参加しているuser)
//                }
                return cell!
            }
        } else {
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
}
