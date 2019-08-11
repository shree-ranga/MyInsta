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
    
    private var values: [String: Any] = [:]
    
    // MARK: Set values for keys
    mutating func setValues(value: Any, forKey key: String) {
        values[key] = value
    }
    
    //MARK: Get value for a key
    func getValue(forKey key: String) -> Any? {
        return values[key]
    }
    
    //MARK: Get all values
    func getAllValues() -> [String: Any] {
        return values
    }
    
    // MARK: Get total Number of items
    func totalItems() -> Int {
        return values.count
    }
}
