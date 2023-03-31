//
//  UID2GMAMediationAdapterTests.swift
//  
//
//  Created by Brad Leege on 3/20/23.
//

import XCTest
import GoogleMobileAds
import UID2
@testable import UID2GMAPlugin

final class UID2GMAMediationAdapterTests: XCTestCase {

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    
    /// 🟩 - GMA Adapter Request Signal Success
    func testRequestSignalsSuccess() async throws {
        
        // Sample UID2Identity data
        let uid2IdentityData = try DataLoader.load(fileName: "uid2identity", fileExtension: "json")
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
        
        // Seed the sample UID2Identity data in the UID2Manager
        await UID2Manager.shared.setAutomaticRefreshEnabled(false)
        await UID2Manager.shared.setIdentity(uid2Identity)

        // Adapter to test
        let adapter = UID2GMAMediationAdapter()
        
        // Wraps Completion Handler Function Call In Async / Await
        let signal: String = try await withCheckedThrowingContinuation { continuation in
            
            adapter.collectSignals(for: GADRTBRequestParameters(), completionHandler:  { signal, error in
                guard let signal = signal else {
                    continuation.resume(throwing: "Signal was Nil")
                    return
                }
                continuation.resume(returning: signal)
                return
            })
            
        }
    
        // Confirm that Adapter returns expected data
        XCTAssertEqual(uid2Identity.advertisingToken, signal)
    }
    
    /// 🟥  - GMA Adapter Request Signal No Advertising Token Erro
    func testRequestSignalsNoAdvertisingToken() async throws {
        
        // Sample UID2Identity data
        let uid2IdentityData = try DataLoader.load(fileName: "uid2identity", fileExtension: "json")
        let uid2IdentityFromFile = try decoder.decode(UID2Identity.self, from: uid2IdentityData)
        
        // Emulate A UID2Identity With Valid Times
        let identityExpires = Date(timeIntervalSinceNow: 60 * 60).millisecondsSince1970
        let refreshFrom = Date(timeIntervalSinceNow: 60 * 40).millisecondsSince1970
        let refreshExpires = Date(timeIntervalSinceNow: 60 * 50).millisecondsSince1970
        
        let uid2Identity = UID2Identity(advertisingToken: "",
                                        refreshToken: uid2IdentityFromFile.refreshToken,
                                        identityExpires: identityExpires,
                                        refreshFrom: refreshFrom,
                                        refreshExpires: refreshExpires,
                                        refreshResponseKey: uid2IdentityFromFile.refreshResponseKey)
        
        // Seed the sample UID2Identity data in the UID2Manager
        await UID2Manager.shared.setAutomaticRefreshEnabled(false)
        await UID2Manager.shared.setIdentity(uid2Identity)

        // Adapter to test
        let adapter = UID2GMAMediationAdapter()
        
        // Wraps Completion Handler Function Call In Async / Await
        let _: String = try await withCheckedThrowingContinuation { continuation in
            
            adapter.collectSignals(for: GADRTBRequestParameters(), completionHandler:  { signal, error in
                
                guard let error = error as? UID2GoogleAdapterErrors else {
                    continuation.resume(throwing: "Error returned was not expected type.")
                    return
                }
                
                XCTAssertEqual(UID2GoogleAdapterErrors.advertisingTokenNotFoundForGMA, error)
            
                continuation.resume(returning: "Successful Test")
                
                return
            })
            
        }
    
    }
    
    func testAdSDKVersion() async throws {
        
        let adSDKVersion = UID2GMAMediationAdapter.adSDKVersion()
        let sdkVersion = await UID2Manager.shared.sdkVersion

        
        XCTAssertEqual(sdkVersion.major, adSDKVersion.majorVersion)
        XCTAssertEqual(sdkVersion.minor, adSDKVersion.minorVersion)
        XCTAssertEqual(sdkVersion.patch, adSDKVersion.patchVersion)

    }
    
}
