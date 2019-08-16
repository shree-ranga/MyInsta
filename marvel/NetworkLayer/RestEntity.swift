//
//  RestEntity.swift
//  Storyboard
//
//  Created by Shree Ranga Raju on 2019-06-07.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

// MARK: Managing http headers, url query, and http body parameters
struct RestEntity {
    
    private var params: [String: Any] = [:]
//    private var params: [String: Any]

    
    // MARK: Set values for keys
    mutating func setValue(value: Any, forKey key: String) {
//        guard var params = params else { return }
//        if params == nil {
//            params = [:]
//        }
        params[key] = value
    }
    
    //MARK: Get value for a key
    func getValue(forKey key: String) -> Any? {
//        guard var params = params else { return nil }
        return params[key]
    }
    
    //MARK: Get all values
    func getAllValues() -> [String: Any] {
//        guard let params = params else { return [:]}
        return params
    }
    
    // MARK: Get total Number of items
    func totalItems() -> Int {
//        guard let params = params else {
//            return 0
//        }
        return params.count
    }
    
    mutating func clearParams() {
        params.removeAll()
    }
}
