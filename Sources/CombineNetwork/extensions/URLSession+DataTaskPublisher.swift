//
//  URLSession+DataTaskPublisher.swift
//
//  Created by Rashaad Ramdeen on 6/21/21.
//

import Foundation
import Combine

public extension URLSession {
    static func dataTaskPublisher(urlsession: URLSession, requestBuilder: RequestBuilder) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        
        //Check if this request requires authentication        
        guard requestBuilder.requiresAuthentication || tokenExpiredOrMissing else {
            return sessionBuilder.session
                .dataTaskPublisher(for: requestBuilder.urlRequest)
                .eraseToAnyPublisher()
        }
        
        let urlResponse = HTTPURLResponse(url: requestBuilder.url, statusCode: 401, httpVersion: "HTTP/1.1", headerFields: nil)!
        let output = (data: Data(), response: urlResponse)
        return Just(output)
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
