//
//  GroupCalendar.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/16.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Parse

class GroupCalendar: NSObject {
    
    static let sharedInstance = GroupCalendar()

    var userCountDic = [User:Int32]()
    var userCountArray = [[User:Int32]]()

    

    
    func createParse(title: String,callback: () -> Void) {
        let calendarQuery = PFQuery(className: "Calendar")
        calendarQuery.whereKey("title", equalTo: title)
        calendarQuery.whereKey("password", equalTo: Calender.sharedInstance.password)
        calendarQuery.getFirstObjectInBackgroundWithBlock { (object, notFind) -> Void in
            if notFind == nil {
            } else {
                let calendarObject = PFObject(className: "Calendar")
                calendarObject["title"] = title
                calendarObject["password"] = Calender.sharedInstance.password
                calendarObject["orner"] = PFUser.currentUser()!
                let relation = calendarObject.relationForKey("users")
                relation.addObject(PFUser.currentUser()!)
                calendarObject.saveInBackgroundWithBlock { (success, error) in
                    if success {
                        calendarQuery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                            if error == nil {
                                Calender.sharedInstance.object_id = (object?.objectId)!
                                callback()
                            } else {
                            }
                        }
                    }
                }
            }
        }
    }
    
    func joinParse(title: String,callback: () -> Void) {
        let calendarQuery = PFQuery(className: "Calendar")
        calendarQuery.whereKey("title", equalTo: title)
        calendarQuery.whereKey("password", equalTo: Calender.sharedInstance.password)
        calendarQuery.getFirstObjectInBackgroundWithBlock { (object, notFind) -> Void in
            if notFind == nil {
                let relation = object!.relationForKey("users")
                relation.addObject(PFUser.currentUser()!)
                Calender.sharedInstance.object_id = (object?.objectId)!
                object!.saveInBackgroundWithBlock { (success, error) in
                    if success {
                        callback()
                    }
                }
            } else {
            }
        }
    }
    
    //タップされた日付をpraseに保存
    func saveTappedDate(date: NSDate, callback: () -> Void) {
//        print(Calender.sharedInstance.object_id)
        let dateQuery = PFQuery(className: "Date")
        dateQuery.whereKey("user_id", equalTo: (PFUser.currentUser()?.objectId)!)
        dateQuery.whereKey("calendar_id", equalTo: Calender.sharedInstance.object_id)
        dateQuery.whereKey("tappedDate", equalTo: date)
        dateQuery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if error == nil {
                object?.deleteInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil {
//                        print("タップされたdateの削除完了")
                        callback()
                    }
                })
            } else {
                let dateObject = PFObject(className: "Date")
                dateObject["tappedDate"] = date
                dateObject["calendar_id"] = Calender.sharedInstance.object_id
                dateObject["user_id"] = PFUser.currentUser()!.objectId
                dateObject.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil {
//                        print("タップされたdate保存完了です")
                        callback()
                    }
                })
            }
        }
    }
    
    //groupに属するuserのタップした日付の数を取得
    func fetchCalendarAttendantUser(calendar: Calender, callback: () -> Void) {
        userCountDic = [:]
        let attendUserquery = PFQuery(className: "Calendar")
        attendUserquery.whereKey("title", equalTo: calendar.title!)
        attendUserquery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if error == nil {
                let users = object!.relationForKey("users")
                users.query().findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    for object in objects! {
                        let objectId = object.objectId
                        let name = object["username"] as! String
                        let user = User(objectId: objectId!, name: name)
                        let userImageFile = object["image"] as! PFFile
                        userImageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                            if error == nil {
                                user.userImage = UIImage(data: imageData!)
                            }
                        })
                        let userDateCountQuery = PFQuery(className: "Date")
                        userDateCountQuery.whereKey("user_id", equalTo: objectId!)
                        userDateCountQuery.whereKey("calendar_id", equalTo: calendar.object_id)
                        userDateCountQuery.countObjectsInBackgroundWithBlock({ (count, error) -> Void in
                            if error == nil {
                                self.userCountDic[user] = count
                            }
                            if self.userCountDic.count == objects?.count {
                                callback()
                            }
                        })
                    }
                })
            }
        }
    }
    
    //取得した日付の数でsort
    func sortUserStampedCount() {
        userCountArray.removeAll()
        _ = Array(userCountDic.values).sort(>)
        for (key, value) in userCountDic {
            var dic = [User:Int32]()
            dic[key] = value
            userCountArray.append(dic)
        }
    }

}
