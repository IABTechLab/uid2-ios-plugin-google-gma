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
@available(iOS 13, *)
@objc(UID2GMAMediationAdapter)
class UID2GMAMediationAdapter: NSObject {
    
    required override init() { }
    
}

@available(iOS 13, *)
extension UID2GMAMediationAdapter: RTBAdapter {

    static func setUp(with configuration: MediationServerConfiguration, completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {
        guard isOperatingSystemSupported else {
            completionHandler(OperatingSystemUnsupportedError())
            return
        }
        // Ensure UID2Manager has started
        _ = UID2Manager.shared

        completionHandler(nil)
    }
        
    func collectSignals(for params: RTBRequestParameters, completionHandler: @escaping GADRTBSignalCompletionHandler) {
        guard isOperatingSystemSupported else {
            completionHandler(nil, OperatingSystemUnsupportedError())
            return
        }
        Task {
            guard let advertisingToken = await UID2Manager.shared.getAdvertisingToken() else {
                completionHandler(nil, AdvertisingTokenNotFoundError())
                return
            }
            completionHandler(advertisingToken, nil)
        }
    }
    
    static func adapterVersion() -> VersionNumber {
        var version = VersionNumber()
        version.majorVersion = 2
        version.minorVersion = 0
        version.patchVersion = 0
        return version
    }
    
    static func adSDKVersion() -> VersionNumber {
        let uid2Version = UID2SDKProperties.getUID2SDKVersion()
        var version = VersionNumber()
        version.majorVersion = uid2Version.major
        version.minorVersion = uid2Version.minor
        version.patchVersion = uid2Version.patch
        return version
    }
    
    static func networkExtrasClass() -> AdNetworkExtras.Type? {
        return nil
    }
    
}
