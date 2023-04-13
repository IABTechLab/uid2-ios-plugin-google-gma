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
import UID2

class ViewController: UIViewController {

    /// The banner view.
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await loadUID2Identity()
            print("Google Mobile Ads SDK version: \(GADMobileAds.sharedInstance().sdkVersion)")
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
 
    private func loadUID2Identity() async {
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // Sample UID2Identity data
            let uid2IdentityData = try AppDataLoader.load(fileName: "uid2identity", fileExtension: "json")
            let uid2IdentityFromFile = try decoder.decode(UID2Identity.self, from: uid2IdentityData)
            
            // Emulate A UID2Identity With Valid Times
            let identityExpires = Date(timeIntervalSinceNow: 60 * 60).millisecondsSince1970
            let refreshFrom = Date(timeIntervalSinceNow: 60 * 40).millisecondsSince1970
            let refreshExpires = Date(timeIntervalSinceNow: 60 * 50).millisecondsSince1970
            
            let uid2Identity = UID2Identity(advertisingToken: uid2IdentityFromFile.advertisingToken,
                                            refreshToken: uid2IdentityFromFile.refreshToken,
                                            identityExpires: identityExpires,
                                            refreshFrom: refreshFrom,
                                            refreshExpires: refreshExpires,
                                            refreshResponseKey: uid2IdentityFromFile.refreshResponseKey)
            
            await UID2Manager.shared.setIdentity(uid2Identity)
        } catch {
            print("Error loading UID2Identity")
        }
        
    }
    
}
