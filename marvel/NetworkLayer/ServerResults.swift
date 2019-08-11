//
//  ServerResults.swift
//  Storyboard
//
//  Created by Shree Ranga Raju on 2019-06-07.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

struct ServerResults {
    
    var data: Data?
    var response: ServerResponse?
    var error: Error?
    
    init(withData data: Data?, response: ServerResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    init(withError error: Error) {
        self.error = error
    }
}

enum CustomError: Error {
    case failedToCreateRequest
}

extension CustomError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object.", comment: "")
        }
    }
}
