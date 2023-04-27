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
class UID2GMAMediationAdapter: NSObject {
    
    required override init() { }
    
}

extension UID2GMAMediationAdapter: GADRTBAdapter {

    static func setUpWith(_ configuration: GADMediationServerConfiguration, completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {
        completionHandler(nil)
    }
        
    func collectSignals(for params: GADRTBRequestParameters, completionHandler: @escaping GADRTBSignalCompletionHandler) {
        Task {
            guard let advertisingToken = await UID2Manager.shared.getAdvertisingToken() else {
                completionHandler(nil, UID2GoogleAdapterErrors.advertisingTokenNotFoundForGMA)
                return
            }
            completionHandler(advertisingToken, nil)
        }
    }
    
    static func adapterVersion() -> GADVersionNumber {
        var version = GADVersionNumber()
        version.majorVersion = 0
        version.minorVersion = 0
        version.patchVersion = 1
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
