//
//  OperatingSystemUnsupportedError.swift
//

import Foundation

/// Adapter called on an unsupported operating system version i.e. lower than UID2's deployment target.
@objc(UID2GMAOperatingSystemUnsupported)
public final class OperatingSystemUnsupportedError: NSError, @unchecked Sendable {

    convenience init() {
        self.init(domain: "UID", code: 2)
    }
}
