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
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: urlRequestCachePolicy,
                                    timeoutInterval: 20.0)
        
        urlRequest.allowsConstrainedNetworkAccess = urlRequestAllowsConstrainedNetworkAccess
        
        headers.forEach { (header, value) in
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }
        
        #warning("Update this in the future to throw actual errors instead of failing silently")
        try? encodeParameters(urlRequest: &urlRequest)
        
        urlRequest.httpMethod = httpMethod.rawValue.uppercased()
        
        return urlRequest
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
    
    var shouldPublish401: Bool {
        return true
    }
    
    func encodeParameters(urlRequest: inout URLRequest) throws {
        /// Parameter Encoding
        switch httpMethod {
        case .get, .put, .delete:
            ///To be implemented
            break
        case .post:
            urlRequest.httpBody = try JSONDataEncoder(options: [.sortedKeys]).encode(parameters: parameters)
        }
    }
    
    var refreshTokenPublisherProvider: RefreshTokenPublisherProvider? {
        return nil
    }
}
