//
//  AppDelegate.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-07-03.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let keyChain = Keychain(server: BASE_URL, protocolType: .http)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        do {
            let token = try keyChain.get("auth_token")
            if token != nil {
//                let mainVC = ViewController()
                let mainVC = MainTabBarVC()
                window?.rootViewController = mainVC
            } else {
                let mainVC = LoginVC()
                window?.rootViewController = mainVC
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().isTranslucent = false
//        let mainVC = LoginVC()
//        window?.rootViewController = mainVC
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

