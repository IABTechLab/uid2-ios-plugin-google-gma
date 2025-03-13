//
//  GADRTBAdapter.swift
//

import GoogleMobileAds

/// Adds an async wrapper interface to simplify testing
extension RTBAdapter {
    func collectSignals(for params: RTBRequestParameters) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            collectSignals(for: params, completionHandler: { signal, error in
                guard error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }
                continuation.resume(returning: signal)
            })
        }
    }
}
