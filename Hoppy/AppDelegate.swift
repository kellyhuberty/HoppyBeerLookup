//
//  AppDelegate.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/15/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //View controller coordinator for the app.
    var beerListCoordinator:BeerListCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let splitViewController = UISplitViewController()
        
        beerListCoordinator = BeerListCoordinator(splitViewController: splitViewController)
        
        let keyWindow = UIWindow()
        keyWindow.rootViewController = splitViewController
        keyWindow.makeKeyAndVisible()
        
        window = keyWindow
        
        return true
    }

}

