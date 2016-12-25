//
//  BoostError.swift
//  Boost
//
//  Created by Ondrej Rafaj on 05/12/2016.
//  Copyright © 2016 manGoweb UK Ltd. All rights reserved.
//

import Foundation


enum BoostErrorReason {
    
    case noFile
    case noData
    case unarchivingFailed
    case cacheNotAccessible
    case missingManifestFile
    case corruptedManifestFile
    case invalidAppContent
    case missingPlatform
    case missingId
    case missingIdentifier
    case fileNotCompatible
    
    case databaseError
    
    case generic(String)
    
}

class BoostError: Error {
    
    
    let type: BoostErrorReason
    let number: Int32
    
    
    // MARK: Initialization
    
    init(_ type: BoostErrorReason) {
        self.type = type
        self.number = errno
    }
    
    init(message: String) {
        self.type = .generic(message)
        self.number = -1
    }

    
}
