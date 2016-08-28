//
//  CalendarView.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/24.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class CalendarView: UIView {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var baseCalendarView: UIView!
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
    var calendarColor: UIColor!
    var rankingView = RankingTableView()
    var textView: UITextView!
    var closeButton: UIButton!
    var memoText = Observable<String?>("")
    
    private var baseRankingView: UIView!
    private var baseMemoView: UIView!
    
    private let monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    override func awakeFromNib() {
        
        self.collectionView as! CalendarCollectionView
        
        buttonsView.addSubview(calendarButton)
        buttonsView.addSubview(rankingButton)
        buttonsView.addSubview(memoButton)
        
        createRankingView()
        createMemoView()
        cerateTextViewCloseButton()

    }
    
    override func layoutSubviews() {
        layoutButton(calendarButton, x: 0, nomalImage: UIImage(named: "calendar")!, selectedImage: UIImage(named: "calendarFilled")!)
        layoutButton(rankingButton, x: buttonsView.frame.width / 3, nomalImage: UIImage(named: "audioWave")!, selectedImage: UIImage(named: "audioWaveFilled")!)
        layoutButton(memoButton, x: buttonsView.frame.width * 2 / 3, nomalImage: UIImage(named: "memo")!, selectedImage: UIImage(named: "memoFilled")!)
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
        calendarColor = UIColor(
            red:  (CGFloat(selectedCalender.color_r))/255,
            green: (CGFloat(selectedCalender.color_g))/255,
            blue: (CGFloat(selectedCalender.color_b))/255,
            alpha: 1
        )
        calendarTitleLabel.text = selectedCalender.title
        headerView.backgroundColor = calendarColor
        collectionView.reloadData()
    }
    
    func setSelectedButton(selectedButton: UIButton) {
        let buttons = [calendarButton, rankingButton, memoButton]
        let views = [baseCalendarView, baseRankingView, baseMemoView]
        for button in buttons {
            if button == selectedButton {
                button.selected = true
                button.tintColor = calendarColor
                views[buttons.indexOf(button)!].hidden = false
            } else {
                button.selected = false
                button.tintColor = UIColor.whiteColor()
                views[buttons.indexOf(button)!].hidden = true
            }
        }
    }
    
    private func layoutButton(button: UIButton, x: CGFloat, nomalImage: UIImage, selectedImage: UIImage) {
        let width: CGFloat = self.frame.width / 3
        button.frame = CGRect(x: x, y: 0, width: width, height: buttonsView.frame.height)
        button.setImage(nomalImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        button.setImage(selectedImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Selected)
        button.setBackgroundColor(UIColor.whiteColor(), forState: .Selected)
        button.setBackgroundColor(UIColor.whiteColor(), forState: .Highlighted)
    }
    
    private func createRankingView() {
        let frame = CGRect(x: 0, y: 0, width: baseView.frame.width, height: baseView.frame.height)
        baseRankingView = UIView(frame: frame)
        let rankingFrame = CGRect(x: 0, y: 0, width: baseRankingView.frame.width, height: baseRankingView.frame.height)
        rankingView.frame = rankingFrame
        baseView.addSubview(baseRankingView)
        baseRankingView.addSubview(rankingView)
    }
    
    private func createMemoView() {
        let frame = CGRect(x: 0, y: 0, width: baseView.frame.width, height: baseView.frame.height)
        baseMemoView = UIView(frame: frame)
        let textViewframe = CGRect(x: 20, y: 40, width: baseView.frame.width - 40, height: baseView.frame.height - 60)
        textView = UITextView(frame: textViewframe)
        textView.layer.borderColor = UIColor.whiteColor().CGColor
        textView.font = UIFont.mainFontJa(14)
        textView.textColor = UIColor.textColor()
        textView.bnd_text.bidirectionalBindTo(memoText)
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: self.frame.width, height: 30))
        label.font = UIFont.mainFontJa(16)
        label.textColor = UIColor.textColor()
        label.text = "Memo"
        let lineView = UIView(frame: CGRect(x: 20, y: 35, width: self.frame.width - 20, height: 0.5))
        lineView.backgroundColor = UIColor.cellLineColor()
        baseMemoView.addSubview(label)
        baseMemoView.addSubview(lineView)
        baseMemoView.addSubview(textView)
        baseView.addSubview(baseMemoView)
        
    }
    
    private func cerateTextViewCloseButton() {
        let closeView = UIView()
        closeView.frame.size.height = 40
        closeView.backgroundColor = UIColor.baseGrayColor()
        closeButton = UIButton(frame: CGRect(x: self.frame.width - 50, y: 5, width: 50, height: 30))
        closeButton.setImage(UIImage(named: "multiply"), forState: .Normal)
        closeView.addSubview(closeButton)
        textView.inputAccessoryView = closeView
        
    }
    
}
