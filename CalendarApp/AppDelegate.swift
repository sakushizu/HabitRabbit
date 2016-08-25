//
//  AppDelegate.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/11/08.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios/guide#local-datastore
//        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarPosition: .TopAttached, barMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UINavigationBar.appearance().tintColor = UIColor.mainColor()
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.mainColor()]
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
//       CalenderManager.sharedInstance.resetDefaults() //NSUserDefault初期化

        let calendarManager = CalenderManager.sharedInstance
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let tokenDic = defaults.objectForKey("tokenDic") as? [String:String] where tokenDic["auth"] != "" {
            let token = tokenDic["auth"]
            User.loginRails(token! , completion: {
                UserInvitationManager.sharedInstance.fetchInvitationCalendars(completion: {
                })
                calendarManager.fetchCalendars(completion: {
                })
            })
            let controller = CalendarTopViewController()
            let navigationController = UINavigationController(rootViewController: controller)
            self.window?.rootViewController = navigationController

        } else {
            let controller = UIStoryboard.viewControllerWith("Main", identifier: "TopViewController")
            let navigationController = UINavigationController(rootViewController: controller)
            self.window?.rootViewController = navigationController
        }
        
        window?.makeKeyAndVisible()
        return true
        
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }


}

