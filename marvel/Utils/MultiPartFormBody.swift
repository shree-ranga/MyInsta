//
//  GenerateBoundary.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-09.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

class MultiPartFormBody {
    let lineBreak = "\r\n"
    
    let uploadData: Data
    let serverField: String
    let boundary: String
    let fileName: String

    
    init(uploadData: Data, serverField: String, boundary: String, fileName: String) {
        self.uploadData = uploadData
        self.serverField = serverField
        self.boundary = boundary
        self.fileName = fileName

    }
    
    func getBody() -> Data {
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(serverField)\"; filename=\"\(fileName)\" \(lineBreak)")
        body.append("Content-Type: application/octet-stream \(lineBreak + lineBreak)")
        body.append(uploadData)
        body.append(lineBreak)
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
