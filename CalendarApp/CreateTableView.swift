
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
    func groupBtn()
}

class CreateTableView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var customDelegate: CreateTableViewDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    var stampImage = UIImage(named: "ハート.jpg")
    var selectedColor = UIColor.whiteColor()
    
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
            let cell = tableView.dequeueReusableCellWithIdentifier("groupBtnCell", forIndexPath: indexPath) as! GroupBtnCell
            cell.button.addTarget(self, action: "tappedGroupBtn", forControlEvents: .TouchUpInside)
            cell.button.backgroundColor = changeGroupCellBtn()
            return cell
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
        print(__FUNCTION__)
        customDelegate?.selectColorBtn()
    }
    
    func tappedGroupBtn() {
        customDelegate?.groupBtn()
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
    
    func changeGroupCellBtn() -> UIColor {
        if GroupCalendar.sharedInstance.password != "" {
            return UIColor.redColor()
        } else {
            return UIColor.darkGrayColor()
        }
    }



    


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
