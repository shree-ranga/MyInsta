//
//  RestManager.swift
//  Storyboard
//
//  Created by Shree Ranga Raju on 2019-06-07.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

final class RestManager {
    
    static let shared = RestManager()
    
    // MARK: headers, query, and body parameters (all client side)
    var requestHttpHeaders = RestEntity()
    var urlQueryParameters = RestEntity()
    var httpBodyParameters = RestEntity()
    
    // MARK: Reuest body data
    var httpBody: Data?
    
    // MARK: Private methods
    // MARK: Add URL query parameters
    private func addURLQueryParameters(toURL url: URL) -> URL {
        // Make sure there are query parameters to add
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters.getAllValues() {
                let item = URLQueryItem(name: key, value: (value as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                queryItems.append(item)
            }
            urlComponents.queryItems = queryItems
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        return url
    }
    
    // MARK: Get Http body
    // TODO: Deal with media type data
    // TODO: Deal with form type data
    private func getHttpBody() -> Data? {
        // first check if the http header - content type is set else no data, return nil
        guard let contentType = requestHttpHeaders.getValue(forKey: "Content-Type") else { return nil }
        
        if (contentType as! String).contains("application/json") {
            do {
                let json = try JSONSerialization.data(withJSONObject: httpBodyParameters.getAllValues(), options: [.prettyPrinted])
                return json
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return httpBody
    }
    
    // MARK: Prepare and configure URL Request
    private func prepareURLRequest(with url: URL? , httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        
        // add http method
        request.httpMethod = httpMethod.rawValue
        
        // add headers
        for (header, value) in requestHttpHeaders.getAllValues() {
            request.addValue(value as! String, forHTTPHeaderField: header)
        }
        
        // add body
        request.httpBody = httpBody
        
        // time out interval
        request.timeoutInterval = 60 * 5 // 5 minutes
        
        return request
    }
    
    // MARK: Public methods
    // MARK: Make request to the server
    public func makeRequest(toURL url: URL, withHttpMethod httpMethod: HttpMethod, completion: @escaping (_ result: ServerResults) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            
            let targetURL = self?.addURLQueryParameters(toURL: url)
            let httpBody = self?.getHttpBody()
            
            // Create URLRequest object
            guard let request = self?.prepareURLRequest(with: targetURL, httpBody: httpBody, httpMethod: httpMethod) else {
                completion(ServerResults(withError: CustomError.failedToCreateRequest))
                return
            }
            
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(ServerResults(withData: data, response: ServerResponse(fromURLResponse: response), error: error))
            })
            task.resume()
        }
    }
    
    // MARK: Get single piece of data from the URL
    public func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                completion(data)
            })
            task.resume()
        }
    }
    
}
