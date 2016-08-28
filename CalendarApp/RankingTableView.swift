//
//  RecordTableView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/22.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

enum RankingViewCellType: Int {
    case User = 0
    case Member = 1
}

class RankingTableView: UITableView, UITableViewDataSource, UITableViewDelegate  {
    
    
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
        let sectionType = RankingViewCellType(rawValue: section)!
        
        switch sectionType {
        case .User:
            return createHeaderView("User Record")
        case .Member:
            return createHeaderView("Ranking")
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sectionType = RankingViewCellType(rawValue: indexPath.section)!
        
        switch sectionType {
        case .User:
            return 80
        case .Member:
            return 70
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = RankingViewCellType(rawValue: section)!
        
        switch sectionType {
        case .User:
            return 1
        case .Member:
            return CalenderManager.sharedInstance.usersStampedRanking.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier("recordCell", forIndexPath: indexPath) as! RankingTableViewCell
        
        let sectionType = RankingViewCellType(rawValue: indexPath.section)!
        
        switch sectionType {
        case .User:
            cell.setRankingLabel(true, num: indexPath.row)
            cell.fillWith(currentUserIncludeStampCount())
            return cell
        case .Member:
            cell.setRankingLabel(false, num: (indexPath.row + 1))
            let user = CalenderManager.sharedInstance.usersStampedRanking[indexPath.row]
            cell.fillWith(user)
            return cell
        }

    }
    
    private func createHeaderView(title: String) -> UIView {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.whiteColor()
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: self.frame.width, height: 30))
        label.font = UIFont.mainFontJa(16)
        label.textColor = UIColor.textColor()
        label.text = title
        let lineView = UIView(frame: CGRect(x: 20, y: 35, width: self.frame.width - 20, height: 0.5))
        lineView.backgroundColor = UIColor.cellLineColor()
        coverView.addSubview(label)
        coverView.addSubview(lineView)
        return coverView
    }
    
    private func currentUserIncludeStampCount() -> User {
        for user in CalenderManager.sharedInstance.usersStampedRanking {
            user.id == CurrentUser.sharedInstance.user.value!.id
            return user
        }
        return CurrentUser.sharedInstance.user.value!
    }
    
    
}
