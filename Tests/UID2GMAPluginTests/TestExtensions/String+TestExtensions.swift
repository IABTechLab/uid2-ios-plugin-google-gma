//
//  File.swift
//  
//
//  Created by Brad Leege on 3/21/23.
//

import Foundation

extension String: LocalizedError {
    
    public var errorDescription: String? { return self }
    
}
