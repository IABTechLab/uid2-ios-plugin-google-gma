//
//  UID2GMAMediationAdapter.swift
//  
//
//  Created by Brad Leege on 3/20/23.
//

import Foundation
import GoogleMobileAds
import UID2

/// Adapter to connect UID2 to Google Mobile Ads
/// https://developers.google.com/admob/ios/open-bidding-adapter
@objc(UID2GMAMediationAdapter)
class UID2GMAMediationAdapter: NSObject {
    
    required override init() { }
    
}

extension UID2GMAMediationAdapter: GADRTBAdapter {

    static func setUpWith(_ configuration: GADMediationServerConfiguration, completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {

        // Ensure UID2Manager has started
        _ = UID2Manager.shared

        completionHandler(nil)
    }
        
    func collectSignals(for params: GADRTBRequestParameters, completionHandler: @escaping GADRTBSignalCompletionHandler) {
        Task {
            guard let advertisingToken = await UID2Manager.shared.getAdvertisingToken() else {
                completionHandler(nil, AdvertisingTokenNotFoundError())
                return
            }
            completionHandler(advertisingToken, nil)
        }
    }
    
    static func adapterVersion() -> GADVersionNumber {
        var version = GADVersionNumber()
        version.majorVersion = 0
        version.minorVersion = 3
        version.patchVersion = 2
        return version
    }
    
    static func adSDKVersion() -> GADVersionNumber {
        var version = GADVersionNumber()
        version.majorVersion = UID2SDKProperties.getUID2SDKVersion().major
        version.minorVersion = UID2SDKProperties.getUID2SDKVersion().minor
        version.patchVersion = UID2SDKProperties.getUID2SDKVersion().patch
        return version
    }
    
    static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        return nil
    }
    
}
