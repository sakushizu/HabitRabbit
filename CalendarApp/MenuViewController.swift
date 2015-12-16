//
//  MenuViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/07.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import SideMenu

class MenuViewController: UIViewController, Menu {
    
    @IBOutlet
    var menuItems = [UIView] ()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
