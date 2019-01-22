//
//  AppDelegate.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = AppRouter().setupInitialFlow()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        ReachabilityManager.shared.startMonitoring()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        ReachabilityManager.shared.stopMonitoring()
    }
}
