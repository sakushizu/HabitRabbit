
//
//  CareateTableView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/12.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

@objc protocol CreateTableViewDelegate {
    func stampBtn()
    func libraryBtn()
    func takePhotoBtn()
    func selectColorBtn()
    func createBtn()
    func backBtn()
}

class CreateTableView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var customDelegate: CreateTableViewDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    var stampImage = UIImage(named: "ハート.jpg")
    var selectedColor = UIColor.whiteColor()
    
    let backTweetView = UIView()
    let textField = UITextField()
    
    var groupCellBtnText = "Create or Join to Group Calendar"
    var groupCellBtnTextColor = UIColor.lightRed()
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerNib(UINib(nibName: "CreateCell1", bundle: nil), forCellReuseIdentifier: "cell1")
        tableView.registerNib(UINib(nibName: "CreateCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        tableView.registerNib(UINib(nibName: "CreateCell3", bundle: nil), forCellReuseIdentifier: "cell3")
        tableView.registerNib(UINib(nibName: "CreateCell4", bundle: nil), forCellReuseIdentifier: "cell4")
        tableView.registerNib(UINib(nibName: "GroupBtnCell", bundle: nil), forCellReuseIdentifier: "groupBtnCell")
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CreateCell1
            actionOfCell1(cell)
            cell.stampImageView.image = stampImage
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! CreateCell2
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath) as! CreateCell3
            cell.selectColorBtn.addTarget(self, action: "tappedSelectColorBtn", forControlEvents: .TouchUpInside)
            cell.selectedColorView.backgroundColor = selectedColor
            return cell
        
        } else if indexPath.row == 3 {
            let groupCell = tableView.dequeueReusableCellWithIdentifier("groupBtnCell", forIndexPath: indexPath) as? GroupBtnCell
            groupCell!.button.addTarget(self, action: "tappedGroupBtn", forControlEvents: .TouchUpInside)
            groupCell!.button.backgroundColor = changeBtnBackGroundColor()
            groupCell!.button.setTitle(groupCellBtnText, forState: .Normal)
            groupCell!.button.setTitleColor(groupCellBtnTextColor, forState: UIControlState.Normal)
            groupCell!.button.titleLabel!.textColor = groupCellBtnTextColor
            return groupCell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! CreateCell4
            cell.createBtn.addTarget(self, action: "tappedCreateBtn", forControlEvents: .TouchUpInside)
            cell.backBtn.addTarget(self, action: "tappedBackBtn", forControlEvents: .TouchUpInside)
            return cell
        }
    }
    
    func indexPathForControlEvent(event: UIEvent) -> NSIndexPath {
        let touch: UITouch = event.allTouches()!.first!
        let p: CGPoint = touch.locationInView(self.tableView)
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(p)!
        return indexPath
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 245
        } else if indexPath.row == 4 {
            return 181
        } else {
            return 56
        }
    }
    
    func actionOfCell1(cell: CreateCell1) {
        cell.defaultStampBtn.addTarget(self, action: "tappedStampBtn", forControlEvents: .TouchUpInside)
        cell.libraryBtn.addTarget(self, action: "tappedLibraryBtn:", forControlEvents: .TouchUpInside)
        cell.takePhotoBtn.addTarget(self, action: "tappedTakePhotoBtn", forControlEvents: .TouchUpInside)
    }
    
    func tappedStampBtn() {
        customDelegate?.stampBtn()

    }
    
    func tappedLibraryBtn(sender: UIButton) {
        customDelegate?.libraryBtn()
    }
    
    func tappedTakePhotoBtn() {
        customDelegate?.takePhotoBtn()
    }
    
    func tappedSelectColorBtn() {
        customDelegate?.selectColorBtn()
    }
    
    func tappedGroupBtn() {
        let backTweetView = makeBackTweetView()
        self.addSubview(backTweetView)
        let passwordView = makePasswordView()
        backTweetView.addSubview(passwordView)
        
        if CurrentUser.sharedInstance.user == nil {
            
        } else {
            setGroupCalendarView(passwordView)
        }
    }

    func loginAlertView()  {
        let createLabel = makeLabel("Create or Join", y: 3)
        //        passwordView.addSubview(createLabel)
        
        
    }
    
    
    func setGroupCalendarView(passwordView: UIView) {
        let textField = makeTextField()
        passwordView.addSubview(textField)
        
        let createLabel = makeLabel("Create or Join", y: 3)
        passwordView.addSubview(createLabel)
        
        let passwordLabel = makeLabel("Password", y: 20)
        passwordView.addSubview(passwordLabel)
        
        let cancelBtn = makeCancelBtn(passwordView)
        passwordView.addSubview(cancelBtn)
        
        let newBtn = makeSubmitBtn("New", x: 20, width: 120 )
        newBtn.addTarget(self, action: "tappedNewBtn", forControlEvents: .TouchUpInside)
        passwordView.addSubview(newBtn)
        
        let joinBtn = makeSubmitBtn("Join", x: 160, width: 120 )
        joinBtn.addTarget(self, action: "tappedJoinBtn", forControlEvents: .TouchUpInside)
        passwordView.addSubview(joinBtn)
    }
    

    
    //groupPasswordView作成
    func makeBackTweetView() -> UIView {
        backTweetView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        backTweetView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return backTweetView
    }
    
    func makePasswordView() -> UIView {
        let passwordView = UIView()
        passwordView.frame.size = CGSizeMake(300, 300)
        passwordView.center.x = self.center.x
        passwordView.center.y = 250
        passwordView.backgroundColor = UIColor.whiteColor()
        passwordView.layer.shadowOpacity = 0.3
        passwordView.layer.cornerRadius = 3
        return passwordView
    }
    
    func makeTextField() -> UITextField {
        textField.frame = CGRectMake(14, 50, 272, 40)
        textField.font = UIFont(name: "Helvetica Neue", size: 14)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        return textField
    }
    
    func makeLabel(text: String, y: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRectMake(14, y, 280, 40))
        label.text = text
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.textColor = UIColor.lightPerple()
        return label
    }
    
    func makeCancelBtn(tweetView: UIView) -> UIButton {
        let cancelBtn = UIButton()
        cancelBtn.frame.size = CGSizeMake(20, 20)
        cancelBtn.center.x = tweetView.frame.width-15
        cancelBtn.center.y = 15
        cancelBtn.setBackgroundImage(UIImage(named: "cancel.png"), forState: .Normal)
        cancelBtn.backgroundColor = UIColor.lightPerple()
        cancelBtn.layer.cornerRadius = cancelBtn.frame.width/2
        cancelBtn.addTarget(self, action: "tappedCancelBtn", forControlEvents: .TouchUpInside)
        return cancelBtn
    }
    
    func makeSubmitBtn(title: String, x: CGFloat, width: CGFloat) -> UIButton {
        let submitBtn = UIButton()
        submitBtn.frame = CGRectMake(x, 250, width, 40)
        submitBtn.setTitle(title, forState: .Normal)
        submitBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        submitBtn.backgroundColor = UIColor.lightPerple()
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        submitBtn.layer.cornerRadius = 7
        return submitBtn
    }
    
    func tappedCancelBtn() {
        GroupCalendar.sharedInstance.password = ""
        groupCellBtnText = "Create or Join to Group Calendar"
        groupCellBtnTextColor = UIColor.lightRed()
        self.tableView.reloadData()
        backTweetView.removeFromSuperview()
    }
    
    func tappedNewBtn() {
        if textField.text != "" {
            GroupCalendar.sharedInstance.password = textField.text!
            groupCellBtnText = "Create Group Calendar"
            groupCellBtnTextColor = UIColor.whiteColor()
            self.tableView.reloadData()
            backTweetView.removeFromSuperview()
        }
    }
    
    func tappedJoinBtn() {
        if textField.text != "" {
            GroupCalendar.sharedInstance.password = textField.text!
            groupCellBtnText = "Join Calendar"
            groupCellBtnTextColor = UIColor.whiteColor()
            self.tableView.reloadData()
            backTweetView.removeFromSuperview()
        }
    }

    
    func tappedCreateBtn() {
        customDelegate?.createBtn()
    }
    
    func tappedBackBtn() {
        customDelegate?.backBtn()
    }

    func setImage(image: UIImage) {
        stampImage = image
        self.tableView.reloadData()
    }
    
    func setColor(color: UIColor) {
        selectedColor = color
        self.tableView.reloadData()
    }
    
    func changeBtnBackGroundColor() -> UIColor {
        if GroupCalendar.sharedInstance.password != "" {
            return UIColor.salmonPink()
        } else {
            return UIColor.verylightRed()
        }
    }

}
