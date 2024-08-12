//
//  GADRTBAdapter.swift
//

import GoogleMobileAds

/// Adds an async wrapper interface to simplify testing
extension GADRTBAdapter {
    func collectSignals(for params: GADRTBRequestParameters) async throws -> String? {
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
