//
//  NetworkLogger.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-15.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

class NetworkLogger {
    static func log(request: URLRequest) {
        print("\n ------------------------- OUTGOING REQUEST ----------------------- \n")
        defer { print("------------------------ END --------------------------------") }
        
        let urlString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        URL: \(urlString) \n
        ENDPOINT: \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\n HEADERS: \(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "BODY: \n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
}
