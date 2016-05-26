//
//  AppDelegate.swift
//  iFinder
//
//  Created by Tanner on 5/17/16.
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.makeKeyAndVisible()
        self.window!.rootViewController = FileBrowser(initialPath: NSURL(fileURLWithPath: "/"))
        
        return true
    }
}

