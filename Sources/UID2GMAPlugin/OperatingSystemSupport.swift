//
//  OperatingSystemUnsupportedError.swift
//

import Foundation

/// Adapter implementations in this package are called at runtime, ignoring @available attributes.
/// By checking the operating system version we can avoid calling UID code which is unavailable.
let isOperatingSystemSupported = ProcessInfo.processInfo.isOperatingSystemAtLeast(
    .init(
        majorVersion: 13,
        minorVersion: 0,
        patchVersion: 0
    )
)

/// Adapter called on an unsupported operating system version i.e. lower than UID2's deployment target.
@objc(UID2GMAOperatingSystemUnsupported)
public final class OperatingSystemUnsupportedError: NSError, @unchecked Sendable {

    convenience init() {
        self.init(domain: "UID", code: 2)
    }
}
