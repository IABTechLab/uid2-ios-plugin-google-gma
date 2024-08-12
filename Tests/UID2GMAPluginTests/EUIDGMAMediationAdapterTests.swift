//
//  EUIDGMAMediationAdapterTests.swift
//

import XCTest
import GoogleMobileAds
import UID2
@testable import UID2GMAPlugin

final class EUIDGMAMediationAdapterTests: XCTestCase {

    /// 🟩 - GMA Adapter Request Signal Success
    func testRequestSignalsSuccess() async throws {
        // Seed the sample UID2Identity data in the UID2Manager
        await EUIDManager.shared.setAutomaticRefreshEnabled(false)
        await EUIDManager.shared.setIdentity(
            UID2Identity(
                advertisingToken: "euid-test-token",
                refreshToken: "refresh-token",
                identityExpires: Date(timeIntervalSinceNow: 60 * 60).millisecondsSince1970,
                refreshFrom: Date(timeIntervalSinceNow: 60 * 40).millisecondsSince1970,
                refreshExpires: Date(timeIntervalSinceNow: 60 * 50).millisecondsSince1970,
                refreshResponseKey: ""
            )
        )

        let signal = try await EUIDGMAMediationAdapter().collectSignals(for: GADRTBRequestParameters())

        // Confirm that Adapter returns expected data
        XCTAssertEqual("euid-test-token", signal)
    }

    /// 🟥 - GMA Adapter Request Signal Error No Identity
    func testRequestSignalsNoIdentity() async throws {
        // Ensure no identity is set
        await EUIDManager.shared.resetIdentity()

        let result = await Task<String?, Error> {
            try await EUIDGMAMediationAdapter().collectSignals(for: GADRTBRequestParameters())
        }.result
        XCTAssertThrowsError(try result.get()) { error in
            let adapterError = error as? AdvertisingTokenNotFoundError
            XCTAssertEqual(AdvertisingTokenNotFoundError(), adapterError)
        }
    }

    /// 🟥  - GMA Adapter Request Signal No Advertising Token Erro
    func testRequestSignalsNoAdvertisingToken() async throws {
        // Set an identity with an invalid advertisingToken
        await EUIDManager.shared.setAutomaticRefreshEnabled(false)
        await EUIDManager.shared.setIdentity(
            UID2Identity(
                advertisingToken: "",
                refreshToken: "refresh-token",
                identityExpires: Date(timeIntervalSinceNow: 60 * 60).millisecondsSince1970,
                refreshFrom: Date(timeIntervalSinceNow: 60 * 40).millisecondsSince1970,
                refreshExpires: Date(timeIntervalSinceNow: 60 * 50).millisecondsSince1970,
                refreshResponseKey: ""
            )
        )

        let result = await Task<String?, Error> {
            try await EUIDGMAMediationAdapter().collectSignals(for: GADRTBRequestParameters())
        }.result
        XCTAssertThrowsError(try result.get()) { error in
            let adapterError = error as? AdvertisingTokenNotFoundError
            XCTAssertEqual(AdvertisingTokenNotFoundError(), adapterError)
        }
    }
    
    /// 🟩 - GMA Adapter Ad SDK Version Check Success
    func testAdSDKVersion() async throws {
        
        let adSDKVersion = EUIDGMAMediationAdapter.adSDKVersion()
        let sdkVersion = await EUIDManager.shared.sdkVersion

        XCTAssertEqual(sdkVersion.major, adSDKVersion.majorVersion)
        XCTAssertEqual(sdkVersion.minor, adSDKVersion.minorVersion)
        XCTAssertEqual(sdkVersion.patch, adSDKVersion.patchVersion)
    }
}
