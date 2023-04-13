//
//  ViewController.swift
//  UID2GoogleGMADevelopmentApp
//
//  See: https://github.com/googleads/googleads-mobile-ios-examples/tree/main/Swift/admob/BannerExample
//
//  Created by Brad Leege on 4/12/23.
//

import GoogleMobileAds
import UIKit

class ViewController: UIViewController {

    /// The banner view.
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Google Mobile Ads SDK version: \(GADMobileAds.sharedInstance().sdkVersion)")
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
}
