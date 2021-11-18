//
//  DefaultSessionBuilder.swift
//  aarons
//
//  Created by Rashaad Ramdeen on 6/18/21.
//  Copyright © 2021 Aaron's, LLC. All rights reserved.
//

import Foundation

struct DefaultSessionBuilder: SessionBuilder {
    var session: URLSession {
        //A Boolean value that indicates whether connections may use the network when the user has specified Low Data Mode.
        config.allowsConstrainedNetworkAccess = true
        return URLSession(configuration: config)
    }
    
    var config: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(30)
        return config
    }
}
