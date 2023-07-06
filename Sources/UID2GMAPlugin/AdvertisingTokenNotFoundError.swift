//
//  AdvertisingTokenNotFoundError.swift
//  
//
//  Created by Brad Leege on 3/23/23.
//

import Foundation

/// Advertising Token Not Found for IMA Adapter
@objc(AdvertisingTokenNotFoundError)
public class AdvertisingTokenNotFoundError: NSError {
    
    convenience init() {
        self.init(domain: "UID", code: 1)
    }
    
}
