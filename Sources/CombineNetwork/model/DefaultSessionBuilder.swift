//
//  DefaultSessionBuilder.swift
//
//  Created by Rashaad Ramdeen on 6/18/21.
//

import Foundation

struct DefaultSessionBuilder: SessionBuilder {
    
    var timeout: Int
    var allowsConstrainedNetworkAccess: Bool = false
    
    var session: URLSession {
        //A Boolean value that indicates whether connections may use the network when the user has specified Low Data Mode.
        config.allowsConstrainedNetworkAccess = allowsConstrainedNetworkAccess
        return URLSession(configuration: config)
    }
    
    var config: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(timeout)
        return config
    }
}
