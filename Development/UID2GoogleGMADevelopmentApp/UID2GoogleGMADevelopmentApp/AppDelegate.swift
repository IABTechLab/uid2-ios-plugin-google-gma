//
//  AppDelegate.swift
//  UID2GoogleGMADevelopmentApp
//
//  Created by Brad Leege on 4/12/23.
//

import GoogleMobileAds
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start()
        
        return true
    }

}
