
//
//  CareateTableView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/12.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit


@objc protocol CreateTableViewDelegate {
    func libraryBtn()
    func takePhotoBtn()
    func selectColorBtn()
    func createBtn()
    func backBtn()
    func moveTopView()
}

class CreateTableView: UIView, UITableViewDelegate, UITableViewDataSource, StampCollectionViewDelegate, UITextFieldDelegate {

    weak var customDelegate: CreateTableViewDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    var stampImage = UIImage(named: "Checked-100")
    var selectedColor = UIColor.whiteColor()
    
    let backTweetView = UIView()
    let textField = UITextField()
    
    var groupCellBtnText = "Create or Join to Group Calendar"
//    var groupCellBtnTextColor = UIColor.lightRed()
    var groupCellBtnFont = UIFont(name: "HelveticaNeue-Light", size: 17)
    
    var stampCollectionView: StampCollectionView!
    var stampViewCount = 0
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self
        
        tableView.registerClass(CreateCell1.self as AnyClass, forCellReuseIdentifier: "cell")
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
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CreateCell1
            cell.selectionStyle = .None
            cell.defaultStampBtn.addTarget(self, action: #selector(CreateTableView.tappedStampBtn), forControlEvents: .TouchUpInside)
            cell.libraryBtn.addTarget(self, action: #selector(CreateTableView.tappedLibraryBtn(_:)), forControlEvents: .TouchUpInside)
            cell.takePhotoBtn.addTarget(self, action: #selector(CreateTableView.tappedTakePhotoBtn), forControlEvents: .TouchUpInside)
            cell.stampImageView.image = stampImage
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! CreateCell2
            cell.titleTextField.delegate = self
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath) as! CreateCell3
            cell.selectColorBtn.addTarget(self, action: #selector(CreateTableView.tappedSelectColorBtn), forControlEvents: .TouchUpInside)
            cell.selectedColorView.backgroundColor = selectedColor
            return cell
        
        } else if indexPath.row == 3 {
            let groupCell = tableView.dequeueReusableCellWithIdentifier("groupBtnCell", forIndexPath: indexPath) as? GroupBtnCell
            groupCell!.button.addTarget(self, action: #selector(CreateTableView.tappedGroupBtn), forControlEvents: .TouchUpInside)
            groupCell!.button.backgroundColor = UIColor.verylightRed()
//            groupCell?.tintColor = UIColor.blackColor()
            groupCell!.button.setTitle(groupCellBtnText, forState: .Normal)
            groupCell!.button.setTitleColor(UIColor.lightRed(), forState: UIControlState.Normal)
            groupCell?.button.titleLabel?.font = groupCellBtnFont
//            groupCell!.button.titleLabel!.textColor = groupCellBtnTextColor
            return groupCell!
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as? CreateCell4
            cell?.backgroundColor = UIColor.appPinkColor()
            cell?.textLabel?.text = "Create Calendar"
            cell?.textLabel?.textColor = UIColor.whiteColor()
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 19)
            cell?.textLabel?.textAlignment = .Center
            return cell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as? CreateCell4
            cell?.backgroundColor = UIColor.appGrayColor()
            cell?.textLabel?.text = "Back"
            cell?.textLabel?.textColor = UIColor.whiteColor()
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 19)
            cell?.textLabel?.textAlignment = .Center
            return cell!
        }
    }
    
    func indexPathForControlEvent(event: UIEvent) -> NSIndexPath {
        let touch: UITouch = event.allTouches()!.first!
        let p: CGPoint = touch.locationInView(self.tableView)
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(p)!
        return indexPath
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let boundSize: CGSize = UIScreen.mainScreen().bounds.size
        if indexPath.row == 0 {
            return 200
        } else if (indexPath.row == 4) || (indexPath.row == 5) {
            return 70
        } else {
            return (boundSize.height - (140 + 200 + 44 + 20)) / 3
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            customDelegate?.createBtn()
        } else if indexPath.row == 5 {
            customDelegate?.backBtn()
        }
    }
    
    func tappedStampBtn() {
        stampBtn()

    }
    func setStampView() {
        // レイアウト作成
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15)
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.itemSize = CGSizeMake(self.frame.width/6, self.frame.width/6)
        
        let frame = CGRectMake(0, self.frame.height, self.frame.width, 300)
        stampCollectionView = StampCollectionView(frame: frame, collectionViewLayout: flowLayout)
        stampCollectionView.backgroundColor = UIColor.whiteColor()
        self.tableView.addSubview(stampCollectionView)
        
        stampCollectionView.customDelegate = self
    }
    
    func stampBtn() {
        if stampViewCount == 0 {
            stampViewCount = 1
            setStampView()
            UICollectionView.animateWithDuration(0.3, animations: { () -> Void in
                self.stampCollectionView.frame.origin = CGPointMake(0, self.frame.height - 300)
            })
        } else {
            stampViewCount = 0
            UICollectionView.animateWithDuration(0.3, animations: { () -> Void in
                self.stampCollectionView.frame.origin = CGPointMake(0, self.frame.height)
            })
        }
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
        if CurrentUser.sharedInstance.user.name == "guest" {
            let passwordView = makePasswordView(CGSizeMake(300, 170), y: 300)
            backTweetView.addSubview(passwordView)
            loginAlertView(passwordView)
        } else {
            let passwordView = makePasswordView(CGSizeMake(300, 300), y: 250)
            backTweetView.addSubview(passwordView)
            setGroupCalendarView(passwordView)
        }
    }

    func loginAlertView(passwordView: UIView) {
        let cautionImageView = UIImageView()
        cautionImageView.frame.size = CGSizeMake(50, 50)
        cautionImageView.center.x = passwordView.frame.width / 2
        cautionImageView.center.y = 45
//        cautionImageView.layer.borderColor = UIColor.appPinkColor().CGColor
//        cautionImageView.layer.borderWidth = 1
//        cautionImageView.layer.cornerRadius = cautionImageView.frame.width / 2
        cautionImageView.image = UIImage(named: "Exclamation Mark Filled-100")
        passwordView.addSubview(cautionImageView)
        let alertLabel = makeLabel("Please Sign up or Login", y: 70, font: UIFont(name: "HelveticaNeue-Light", size: 20)!)
        alertLabel.textAlignment = .Center
        passwordView.addSubview(alertLabel)
        
        let newBtn = makeSubmitBtn("Later", x: 20, y: 120, width: 120 )
        newBtn.addTarget(self, action: #selector(CreateTableView.tappedCancelBtn), forControlEvents: .TouchUpInside)
        passwordView.addSubview(newBtn)
        
        let joinBtn = makeSubmitBtn("Sign up / Login", x: 160, y: 120, width: 120 )
        joinBtn.addTarget(self, action: #selector(CreateTableView.tappedLoginBtn), forControlEvents: .TouchUpInside)
        passwordView.addSubview(joinBtn)
        
    }
    
    func tappedLoginBtn() {
        customDelegate?.moveTopView()
    }
    
    
    func setGroupCalendarView(passwordView: UIView) {
        let textField = makeTextField()
        passwordView.addSubview(textField)
        
        let createLabel = makeLabel("Create or Join", y: 8, font: UIFont(name: "HelveticaNeue", size: 20)!)
        passwordView.addSubview(createLabel)
        
        let passwordLabel = makeLabel("Password", y: 40, font: UIFont(name: "HelveticaNeue-Light", size: 17)!)
        passwordView.addSubview(passwordLabel)
        
        let descriptionLabel = makeDescriptionLabel()
        passwordView.addSubview(descriptionLabel)
        
        let cancelBtn = makeCancelBtn(passwordView)
        passwordView.addSubview(cancelBtn)
        
        let newBtn = makeSubmitBtn("New", x: 20, y: 250, width: 120 )
        newBtn.addTarget(self, action: #selector(CreateTableView.tappedNewBtn), forControlEvents: .TouchUpInside)
        passwordView.addSubview(newBtn)
        
        let joinBtn = makeSubmitBtn("Join", x: 160, y: 250, width: 120 )
        joinBtn.addTarget(self, action: #selector(CreateTableView.tappedJoinBtn), forControlEvents: .TouchUpInside)
        passwordView.addSubview(joinBtn)
    }
    

    
    //groupPasswordView作成
    func makeBackTweetView() -> UIView {
        backTweetView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        backTweetView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return backTweetView
    }
    
    func makePasswordView(size: CGSize, y: CGFloat) -> UIView {
        let passwordView = UIView()
        passwordView.frame.size = size
        passwordView.center.x = self.center.x
        passwordView.center.y = y
        passwordView.backgroundColor = UIColor.whiteColor()
        passwordView.layer.shadowOpacity = 0.3
        passwordView.layer.cornerRadius = 3
        return passwordView
    }
    
    func makeTextField() -> UITextField {
        textField.frame = CGRectMake(16, 75, 272, 38)
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        textField.textColor = UIColor.darkGrayColor()
        textField.tintColor = UIColor.appPinkColor()
        textField.borderStyle = UITextBorderStyle.RoundedRect
        return textField
    }
    
    func makeLabel(text: String, y: CGFloat, font: UIFont) -> UILabel {
        let label = UILabel(frame: CGRectMake(14, y, 280, 40))
        label.text = text
        label.font = font
        label.textColor = UIColor.appPinkColor()
        return label
    }
    
    func makeDescriptionLabel() -> UILabel {
        let label = UILabel(frame: CGRectMake(14, 70, 280, 200))
        label.text = "If you create Group Calendar, please enter new password and tapped Create button.\n\nIf you join Group Calendar, please enter the calendar password and tapped Join button "
        label.numberOfLines = 5
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.textColor = UIColor.appPinkColor()
        return label
    }
    
    func makeCancelBtn(tweetView: UIView) -> UIButton {
        let cancelBtn = UIButton()
        cancelBtn.frame.size = CGSizeMake(20, 20)
        cancelBtn.center.x = tweetView.frame.width-15
        cancelBtn.center.y = 15
        cancelBtn.setBackgroundImage(UIImage(named: "cancel.png"), forState: .Normal)
        cancelBtn.backgroundColor = UIColor.appPinkColor()
        cancelBtn.layer.cornerRadius = cancelBtn.frame.width/2
        cancelBtn.addTarget(self, action: #selector(CreateTableView.tappedCancelBtn), forControlEvents: .TouchUpInside)
        return cancelBtn
    }
    
    func makeSubmitBtn(title: String, x: CGFloat, y: CGFloat, width: CGFloat) -> UIButton {
        let submitBtn = UIButton()
        submitBtn.frame = CGRectMake(x, y, width, 40)
        submitBtn.setTitle(title, forState: .Normal)
        submitBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        submitBtn.backgroundColor = UIColor.appPinkColor()
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        submitBtn.layer.cornerRadius = 7
        return submitBtn
    }
    
    func tappedCancelBtn() {
        Calendar.sharedInstance.password = ""
        groupCellBtnText = "Create or Join to Group Calendar"
//        groupCellBtnTextColor = UIColor.lightRed()
        groupCellBtnFont = UIFont(name: "HelveticaNeue-Light", size: 17)
        textField.text = ""
        self.tableView.reloadData()
        backTweetView.removeFromSuperview()
    }
    
    func tappedNewBtn() {
        if textField.text != "" {
            Calendar.sharedInstance.password = textField.text!
            groupCellBtnText = "Create Group Calendar"
            groupCellBtnFont = UIFont(name: "HelveticaNeue", size: 20)
//            groupCellBtnTextColor = UIColor.whiteColor()
            textField.text = ""
            self.tableView.reloadData()
            backTweetView.removeFromSuperview()
        }
    }
    
    func tappedJoinBtn() {
        if textField.text != "" {
            Calendar.sharedInstance.password = textField.text!
            groupCellBtnText = "Join Calendar"
            groupCellBtnFont = UIFont(name: "HelveticaNeue", size: 20)
//            groupCellBtnTextColor = UIColor.whiteColor()
            textField.text = ""
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
        if Calendar.sharedInstance.password != "" {
            return UIColor.salmonPink()
        } else {
            return UIColor.verylightRed()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
