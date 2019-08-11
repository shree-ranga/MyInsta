//
//  ServerResponse.swift
//  Storyboard
//
//  Created by Shree Ranga Raju on 2019-06-07.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

struct ServerResponse {
    
    var response: URLResponse? // This doesn't contain the actual data from the server
    var httpStatusCode: Int = 0
    var headers = RestEntity()
    
    init(fromURLResponse response: URLResponse?) {
        guard let response = response else { return }
        self.response = response
        
        guard let httpURLResponse = response as? HTTPURLResponse else { return }
        httpStatusCode = httpURLResponse.statusCode
        for (key, value) in httpURLResponse.allHeaderFields {
            headers.setValues(value: value, forKey: "\(key)")
        }
    }
}

