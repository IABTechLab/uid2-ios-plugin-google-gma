//
//  AppDataLoader.swift
//
//
//  Created by Brad Leege on 3/21/23.
//

import Foundation

final class AppDataLoader {

    static func load(fileName: String, fileExtension: String) throws -> Data {
        
        guard let bundlePath = Bundle.main.path(forResource: fileName, ofType: fileExtension),
              let stringData = try String(contentsOfFile: bundlePath).data(using: .utf8) else {
            throw "Could not load data from file."
        }
        
        return stringData
    }
    
}
