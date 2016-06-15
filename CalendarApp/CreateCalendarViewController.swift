//
//  CreateCalendarViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/10.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import RSKImageCropper



class CreateCalendarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, CreateTableViewDelegate, ColorTableViewControllerDelegate {
    
    var createTableView: CreateTableView!
    var colorTableViewController = ColorTableViewController()
    var cell1: CreateCell1!
    var cell2: CreateCell2!
    var cell3: CreateCell3!
    var groupCell: GroupBtnCell!
    var cell4: CreateCell4!
    
    var selectImage: UIImage!
    var selectColor = UIColor.redColor()
    var selectedThemeColor: CalendarThemeColor?
    
    var pickerVC: UIImagePickerController!
    
    override func loadView() {
        let nib = UINib(nibName: "CreateTableView", bundle: nil)
        view = nib.instantiateWithOwner(nil, options: nil).first as! UIView

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView = view as! CreateTableView
        createTableView.customDelegate = self
        ColorTableViewController().customDelegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        cell1 = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! CreateCell1
       cell2 = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! CreateCell2
        cell3 = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! CreateCell3
        groupCell = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! GroupBtnCell
        cell4 = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0)) as! CreateCell4
    }
    
    override func viewWillAppear(animated: Bool) {
        createTableView.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //controllerの処理
    func createBtn() {
        if cell2.titleTextField.text == "" {
            showAlert("Title is empty!")
        } else {
            let navigationVC = self.navigationController!
            navigationVC.popViewControllerAnimated(false)
            let calendarVC = navigationVC.viewControllers.last as! CalendarViewController
            if Calendar.sharedInstance.password != "" {
                let groupCell =  createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! GroupBtnCell
                if groupCell.button.titleLabel?.text == "Join Calendar" {
                    GroupCalendar.sharedInstance.joinParse(cell2.titleTextField.text!) { () -> Void in
                        self.save("group")
                        calendarVC.sideMenu?.sideMenuTableViewController.tableView.reloadData()
                    }
                } else {
                    let calendar = self.save("group")
                    StockCalendars.saveCalendarRails(calendar)
                    calendarVC.sideMenu?.sideMenuTableViewController.tableView.reloadData()
                    
//                    GroupCalendar.sharedInstance.createParse(cell2.titleTextField.text!) { () -> Void in
//                        self.save("group")
//                        calendarVC.sideMenu?.sideMenuTableViewController.tableView.reloadData()
//                    }
                }
            } else {
                let calendar = self.save("group")
                StockCalendars.saveCalendarRails(calendar)
                calendarVC.sideMenu?.sideMenuTableViewController.tableView.reloadData()
            }
        }
    }
    
    func backBtn() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //controllerの処理
    func save(calendarType: String) -> Calendar {
        let calendar = Calendar()
        calendar.title = cell2.titleTextField.text!
        calendar.image = cell1.stampImageView.image
        calendar.color = selectedThemeColor?.color
        calendar.color_r = selectedThemeColor?.r
        calendar.color_g = selectedThemeColor?.g
        calendar.color_b = selectedThemeColor?.b
        calendar.object_id = Calendar.sharedInstance.object_id
        CalenderManager.sharedInstance.addCalendarCollection(calendar, calendarType: calendarType)
        return calendar
    }

    func libraryBtn() {
        pickImageFromLibrary()
    }
    
    func takePhotoBtn() {
        pickImageFromCamera()
    }
    
    func selectColorBtn() {
        performSegueWithIdentifier("colorTableView", sender: nil)
    }
    
        
    
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(pickerVC, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            selectImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: selectImage, cropMode: RSKImageCropMode.Square)
        imageCropVC.delegate = self // 必須（下で実装）
        imageCropVC.dataSource = self // トリミングしたい領域をカスタマイズする際には必要
        picker.pushViewController(imageCropVC, animated: true)
    }

    
    //画面遷移の時に画像を渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "colorTableView" {
            let colorVC = segue.destinationViewController as! ColorTableViewController
            colorVC.customDelegate = self
        }
    }
    
    
    
    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController) -> CGRect {
        
        var maskSize: CGSize
        var height: CGFloat!
        
//        width = self.view.frame.width
        
        // 縦横比 = 1 : 2でトリミングしたい場合
        //        height = self.view.frame.width / 2
        
        // 正方形でトリミングしたい場合
        height = self.view.frame.width
        
        maskSize = CGSizeMake(self.view.frame.width, height)
        
        let viewWidth: CGFloat = CGRectGetWidth(controller.view.frame)
        let viewHeight: CGFloat = CGRectGetHeight(controller.view.frame)
        
        let maskRect: CGRect = CGRectMake((viewWidth - maskSize.width) * 0.5, (viewHeight - maskSize.height) * 0.5, maskSize.width, maskSize.height)
        return maskRect
    }
    
    // トリミングしたい領域を描画（今回は四角な領域です・・・）
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController) -> UIBezierPath {
        let rect: CGRect = controller.maskRect
        
        let point1: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
        let point2: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        let point3: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))
        let point4: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        let square: UIBezierPath = UIBezierPath()
        square.moveToPoint(point1)
        square.addLineToPoint(point2)
        square.addLineToPoint(point3)
        square.addLineToPoint(point4)
        square.closePath()
        
        return square
    }
    
    func imageCropViewControllerCustomMovementRect(controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
    
    // キャンセルがおされたらトリミング画面を閉じます
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        pickerVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // トリミング前に呼ばれるようです今回は使っていませんが、ないとコンパイルできないので定義しておきます
    func imageCropViewController(controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
    }
    
    // トリミング済みの画像がかえされます
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        pickerVC.dismissViewControllerAnimated(true, completion: nil)
        createTableView.setImage(croppedImage)
    }

    func setSelectedColor(selectedColor: CalendarThemeColor) {
        selectedThemeColor = selectedColor
        createTableView.setColor(selectedColor.color)
    }
    
    //アラート表示のメソッド
    func showAlert(message: String?) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func moveTopView() {
        performSegueWithIdentifier("topView", sender: nil)
    }

}
