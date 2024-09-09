//
//  EUIDGMAMediationAdapter.swift
//  

import Foundation
import GoogleMobileAds
import UID2

/// Adapter to connect EUID to Google Mobile Ads
/// https://developers.google.com/admob/ios/open-bidding-adapter
@available(iOS 13, *)
@objc(EUIDGMAMediationAdapter)
class EUIDGMAMediationAdapter: NSObject {

    required override init() { }

}

@available(iOS 13, *)
extension EUIDGMAMediationAdapter: GADRTBAdapter {

    static func setUpWith(_ configuration: GADMediationServerConfiguration, completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {

        // Ensure UID2Manager has started
        _ = EUIDManager.shared

        completionHandler(nil)
    }

    func collectSignals(for params: GADRTBRequestParameters, completionHandler: @escaping GADRTBSignalCompletionHandler) {
        Task {
            guard let advertisingToken = await EUIDManager.shared.getAdvertisingToken() else {
                completionHandler(nil, AdvertisingTokenNotFoundError())
                return
            }
            completionHandler(advertisingToken, nil)
        }
    }

    static func adapterVersion() -> GADVersionNumber {
        var version = GADVersionNumber()
        version.majorVersion = 1
        version.minorVersion = 0
        version.patchVersion = 0
        return version
    }

    static func adSDKVersion() -> GADVersionNumber {
        let uid2Version = UID2SDKProperties.getUID2SDKVersion()
        var version = GADVersionNumber()
        version.majorVersion = uid2Version.major
        version.minorVersion = uid2Version.minor
        version.patchVersion = uid2Version.patch
        return version
    }

    static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        return nil
    }

}
