//
//  RequestBuilder.swift
//
//  Created by Rashaad Ramdeen on 2/16/21.
//

import Foundation
import Combine

extension RequestBuilder {
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
    
    /**
     Default ParameterEncodingType
     */
    var parameterEncodingType: ParameterEncodingType {
        return httpMethod == .get ? .urlEncoding : .jsonEncoding(options: [])
    }
    
    var parameters: [String: Any] {
        return [:]
    }
    
    /**
     Generated URLRequest
     */
    var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: url, cachePolicy: urlRequestCachePolicy, timeoutInterval: 20.0)
        urlRequest.allowsConstrainedNetworkAccess = urlRequestAllowsConstrainedNetworkAccess
        
        headers.forEach { (header, value) in
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }
        
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
}
