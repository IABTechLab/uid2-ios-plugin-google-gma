//
//  AdvertisingTokenNotFoundError.swift
//  
//
//  Created by Brad Leege on 3/23/23.
//

import Foundation

/// Advertising Token Not Found for GMA Adapter
@objc(UID2GMAAdvertisingTokenNotFoundError)
public class AdvertisingTokenNotFoundError: NSError {
    
    convenience init() {
        self.init(domain: "UID", code: 1)
    }
    
}
