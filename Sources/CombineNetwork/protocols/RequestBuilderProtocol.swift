//
//  RequestBuilder.swift
//  
//
//  Created by Rashaad Ramdeen on 11/18/21.
//

import Foundation

protocol RequestBuilder {
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var urlRequest: URLRequest { get }
    var urlRequestCachePolicy: URLRequest.CachePolicy { get }
    
    /**
     Setting this property on a request overrides the allowsConstrainedNetworkAccess property of URLSessionConfiguration. For example, if the session configuration’s allowsConstrainedNetworkAccess value is false, and you create a task from a request whose allowsConstrainedNetworkAccess is true, the task treats the value as true.

     Limit your app’s of use of constrained network access to user-initiated tasks, and put off discretionary tasks until a nonconstrained interface becomes available.
     https://developer.apple.com/documentation/foundation/urlrequest/3358304-allowsconstrainednetworkaccess
     */
    var urlRequestAllowsConstrainedNetworkAccess: Bool { get }
    var parameterEncodingType: ParameterEncodingType { get }
    var parameters: [String: Any] { get }
    var requiresAuthentication: Bool { get }
}
