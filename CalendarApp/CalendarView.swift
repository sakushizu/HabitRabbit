//
//  CalendarView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/24.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class CalendarView: UIView {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarTitleLabel: UILabel!
    @IBOutlet weak var backMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var editCalendarButton: UIButton!
    
    let calendarButton = UIButton()
    let rankingButton = UIButton()
    let memoButton = UIButton()
    
    private let monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    override func awakeFromNib() {
        
        self.collectionView as! CalendarCollectionView
        
        buttonsView.addSubview(calendarButton)
        buttonsView.addSubview(rankingButton)
        buttonsView.addSubview(memoButton)

    }
    
    override func layoutSubviews() {
        layoutButton(calendarButton, x: 0, image: UIImage(named: "calendar")!)
        calendarButton.selected = true
        layoutButton(rankingButton, x: buttonsView.frame.width / 3, image: UIImage(named: "audioWave")!)
        layoutButton(memoButton, x: buttonsView.frame.width * 2 / 3, image: UIImage(named: "memo")!)
    }
    
    func setCalendar(selectedDate: NSDate) {
        yearLabel.text = changeHeaderTitle(selectedDate)
        monthLabel.text = monthArray[Int(changeHeaderMonth(selectedDate))! - 1]
    }
    
    //yearを変更
    func changeHeaderTitle(date: NSDate) -> String {
        let yearFormatter: NSDateFormatter = NSDateFormatter()
        yearFormatter.locale = NSLocale(localeIdentifier: "en_US")
        yearFormatter.dateFormat = "yyyy"
        let selectYear = yearFormatter.stringFromDate(date)
        return selectYear
    }
    
    //monthを変更
    func changeHeaderMonth(date: NSDate) -> String {
        let monthFormatter: NSDateFormatter = NSDateFormatter()
        monthFormatter.locale = NSLocale(localeIdentifier: "en_US")
        monthFormatter.dateFormat = "M"
        let selectMonth = monthFormatter.stringFromDate(date)
        return selectMonth
    }
    
    func setTappedCalendar(selectedDate: NSDate) {
        collectionView.reloadData()
        yearLabel.text = changeHeaderTitle(selectedDate)
        monthLabel.text = monthArray[Int(changeHeaderMonth(selectedDate))! - 1]
    }
    
    // MARK: - ビューの装飾
    
    func setSelectedCalendarView(selectedCalender: Calendar) {
        selectedCalender.stampImageURL  =  "\(selectedCalender.stampImageURL)?\(String.random())"
        let color = UIColor(
            red:  (CGFloat(selectedCalender.color_r))/255,
            green: (CGFloat(selectedCalender.color_g))/255,
            blue: (CGFloat(selectedCalender.color_b))/255,
            alpha: 1
        )
        
        calendarTitleLabel.text = selectedCalender.title
        
        headerView.backgroundColor = color
//        self.setRecordView()
        collectionView.reloadData()
    }
    
    private func layoutButton(button: UIButton, x: CGFloat, image: UIImage) {
        let width: CGFloat = buttonsView.frame.width / 3
        button.frame = CGRect(x: x, y: 0, width: width, height: buttonsView.frame.height)
        button.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        button.setBackgroundColor(UIColor.whiteColor(), forState: .Selected)
        button.setBackgroundColor(UIColor.whiteColor(), forState: .Highlighted)
    }
}
