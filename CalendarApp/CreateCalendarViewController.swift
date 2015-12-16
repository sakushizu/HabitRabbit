//
//  CreateCalendarViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/10.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Photos
import RSKImageCropper

class CreateCalendarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, CreateTableViewDelegate, StampCollectionViewDelegate, ColorTableViewControllerDelegate {
    
    var createTableView: CreateTableView!
    var cell1: CreateCell1!
    var cell2: CreateCell2!
    var cell3: CreateCell3!
    var groupCell: GroupBtnCell!
    var cell4: CreateCell4!

    let backTweetView = UIView()
    let textField = UITextField()
    
    var selectImage: UIImage!
    var selectColor = UIColor.redColor()
    
    var stampCollectionView: StampCollectionView!
    var stampViewCount = 0

    var pickerVC: UIImagePickerController!
    
    override func loadView() {
        let nib = UINib(nibName: "CreateTableView", bundle: nil)
        view = nib.instantiateWithOwner(nil, options: nil).first as! UIView

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView = view as! CreateTableView
        createTableView.customDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        cell1 = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! CreateCell1
        cell2 = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! CreateCell2
        cell3 = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! CreateCell3
        groupCell = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! GroupBtnCell
        cell4 = createTableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0)) as! CreateCell4
        
//        ColorTableViewController().customDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        createTableView.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func stampBtn() {
        if stampViewCount == 0 {
            stampViewCount = 1
            setStampView()
            UICollectionView.animateWithDuration(0.3, animations: { () -> Void in
                self.stampCollectionView.frame.origin = CGPointMake(0, self.view.frame.height - 150)
            })
        } else {
            stampViewCount = 0
            UICollectionView.animateWithDuration(0.3, animations: { () -> Void in
                self.stampCollectionView.frame.origin = CGPointMake(0, self.view.frame.height)
            })
        }
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
    
    func groupBtn() {
        let backTweetView = makeBackTweetView()
        self.view.addSubview(backTweetView)
        
        let passwordView = makePasswordView()
        backTweetView.addSubview(passwordView)
        
        let textField = makeTextField()
        passwordView.addSubview(textField)
        
        let createLabel = makeLabel("Create or Join", y: 3)
        passwordView.addSubview(createLabel)
        
        let passwordLabel = makeLabel("Password", y: 20)
        passwordView.addSubview(passwordLabel)
        
        let cancelBtn = makeCancelBtn(passwordView)
        passwordView.addSubview(cancelBtn)
        
        let submitBtn = makeSubmitBtn()
        passwordView.addSubview(submitBtn)
        

    }
    
    func createBtn() {
        let navigationVC = self.navigationController!
        navigationVC.popViewControllerAnimated(false)
        let calendarVC = navigationVC.viewControllers.last as! CalenderViewController
        save()
        calendarVC.sideMenu?.sideMenuTableViewController.tableView.reloadData()
    }
    
    func backBtn() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func save() {
        let calendar = Calender()
        calendar.title = cell2.titleTextField.text!
        calendar.image = cell1.stampImageView.image
        calendar.color = cell3.selectedColorView.backgroundColor
        CalenderManager.sharedInstance.addCalendarCollection(calendar)
        if GroupCalendar.sharedInstance.password != "" {
            GroupCalendar.sharedInstance.saveParse(calendar.title!) { () -> Void in
            }
        }
        CalenderManager.sharedInstance.calendarCollection.append(calendar)
        CalenderManager.sharedInstance.titles.append(calendar.title!)
    }

    func setStampView() {
        // レイアウト作成
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        flowLayout.minimumInteritemSpacing = 3.0
        flowLayout.minimumLineSpacing = 3.0
        flowLayout.itemSize = CGSizeMake(self.view.frame.width/5, self.view.frame.width/5)
        
        let frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 150)
        stampCollectionView = StampCollectionView(frame: frame, collectionViewLayout: flowLayout)
        stampCollectionView.backgroundColor = UIColor.whiteColor()
        createTableView.addSubview(stampCollectionView)
        
        stampCollectionView.customDelegate = self
    }
    
    //groupPasswordView作成
    func makeBackTweetView() -> UIView {
        backTweetView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        backTweetView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return backTweetView
    }
    
    func makePasswordView() -> UIView {
        let passwordView = UIView()
        passwordView.frame.size = CGSizeMake(300, 300)
        passwordView.center.x = self.view.center.x
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
    
    func makeSubmitBtn() -> UIButton {
        let submitBtn = UIButton()
        submitBtn.frame = CGRectMake(10, 250, 280, 40)
        submitBtn.setTitle("OK", forState: .Normal)
        submitBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        submitBtn.backgroundColor = UIColor.lightPerple()
        submitBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        submitBtn.layer.cornerRadius = 7
        submitBtn.addTarget(self, action: "tappedSubmitBtn", forControlEvents: .TouchUpInside)
        return submitBtn
    }
    
    func tappedCancelBtn() {
        GroupCalendar.sharedInstance.password = ""
        createTableView.tableView.reloadData()
        backTweetView.removeFromSuperview()
    }
    
    func tappedSubmitBtn() {
        if textField.text != nil {
            GroupCalendar.sharedInstance.password = textField.text!
            createTableView.tableView.reloadData()
            backTweetView.removeFromSuperview()
        }
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
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if info[UIImagePickerControllerOriginalImage] != nil {
//            selectImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        }
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        
//        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: selectImage, cropMode: RSKImageCropMode.Square)
//        imageCropVC.delegate = self // 必須（下で実装）
//        imageCropVC.dataSource = self // トリミングしたい領域をカスタマイズする際には必要
//        
//        self.navigationController?.pushViewController(imageCropVC, animated: true)
//    }
//
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            selectImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: selectImage, cropMode: RSKImageCropMode.Square)
        imageCropVC.delegate = self // 必須（下で実装）
        imageCropVC.dataSource = self // トリミングしたい領域をカスタマイズする際には必要
        picker.pushViewController(imageCropVC, animated: true)
//        picker.dismissViewControllerAnimated(true, completion: nil)
        

        
//        self.navigationController?.pushViewController(imageCropVC, animated: true)
    }

    
    //画面遷移の時に画像を渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "cropView") {
            let secondController: ImageCropViewController = segue.destinationViewController as! ImageCropViewController
            if let image = selectImage {
                secondController.cameraImage = image
            }
        } else if segue.identifier == "colorTableView" {
            let colorVC = segue.destinationViewController as! ColorTableViewController
            colorVC.customDelegate = self
        }
    }
    
    
    
    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController) -> CGRect {
        
        var maskSize: CGSize
        var width, height: CGFloat!
        
        width = self.view.frame.width
        
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
    
    func setStampImage(image: UIImage){
        createTableView.setImage(image)
    }
    
    func setSelectedColor(color: UIColor) {
        print("selectesColor")
        createTableView.setColor(color)
    }

    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
