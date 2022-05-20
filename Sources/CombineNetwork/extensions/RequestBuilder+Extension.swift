//
//  RequestBuilder.swift
//
//  Created by Rashaad Ramdeen on 2/16/21.
//

import Foundation
import Combine

public extension RequestBuilder {
    /**
     Default HTTPMethod GET
     */
    var httpMethod: HTTPMethod {
        return .get
    }
    
    /**
     Default standard headers
     */
    var headers: [String: String] { return [:] }
    
    var parameters: Parameters { return [:] }
    
    /**
     Generated URLRequest
     */
    var urlRequest: URLRequest {
        get throws {
            var urlRequest = URLRequest(url: url,
                                        cachePolicy: urlRequestCachePolicy,
                                        timeoutInterval: 20.0)
            
            urlRequest.allowsConstrainedNetworkAccess = urlRequestAllowsConstrainedNetworkAccess
            
            headers.forEach { (header, value) in
                urlRequest.setValue(value, forHTTPHeaderField: header)
            }
            
            try encodeParameters(urlRequest: &urlRequest)
            
            urlRequest.httpMethod = httpMethod.rawValue.uppercased()
            
            return urlRequest
        }
    }
    
    var urlRequestCachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
    
    var urlRequestAllowsConstrainedNetworkAccess: Bool {
        return false
    }
    
    var requiresAuthentication: Bool {
        return true
    }
    
    func encodeParameters(urlRequest: inout URLRequest) throws {
        /// Parameter Encoding
        switch httpMethod {
        case .get, .put, .delete:
            ///To be implemented
            break
        case .post:
            urlRequest.httpBody = try JSONParameterEncoder(options: [.sortedKeys]).encode(parameters: parameters)
        }
    }
}
