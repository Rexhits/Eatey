//
//  AppDelegate.swift
//  Eatey
//
//  Created by Alan Liu on 10/2/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit
import Lockbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UITabBar.appearance().tintColor = UIColor(red: 226/255.0, green: 121/255.0, blue: 63/255.0, alpha: 1.0)
        let myToken = Lockbox.unarchiveObject(forKey: "Token")
        let myUsername = Lockbox.unarchiveObject(forKey: "Username")
        if myToken != nil && myUsername != nil{
            token = myToken! as! NSString
            username = myUsername as! NSString
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "IndexViewController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            return true
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        SocketIOManager.sharedInstance.establishConnection()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        SocketIOManager.sharedInstance.establishConnection()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

