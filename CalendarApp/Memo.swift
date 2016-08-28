//
//  MemoManager.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/08/26.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Memo: NSObject {
    
    static let sharedInstance = Memo()
    
    var memo = ""
    
    func saveMemo(params: [String: AnyObject], completion: () -> Void) {
        let token = CurrentUser.sharedInstance.authentication_token.value
        Alamofire.request(
            .POST,
            "\(Settings.ApiRootPath)/api/memos",
            parameters: params,
            headers: ["access_token": token],
            encoding: .URL
            ).responseJSON { response in
                guard response.result.error == nil else {
                    print("result.error")
                    // Alert
                    return
                }
                guard let _ = response.result.value else {
                    print("responseValue")
                    return
                }
                completion()
        }
    }
    
    func fetchMemo(params: [String: AnyObject], completion: () -> Void) {
        Alamofire.request(
            .GET,
            "\(Settings.ApiRootPath)/api/memos/",
            parameters: params,
            headers: ["access_token": CurrentUser.sharedInstance.authentication_token.value]
            ).responseJSON { response in
                guard response.result.error == nil else {
                    // Add error handling in the future
                    print("Can't connect to the server: \(response.result.error!)")
                    return
                }
                let json = JSON(response.result.value!)
                self.memo = json["memo"].string!
                completion()
        }
    }
}
