//
//  Publishers+Networking.swift
//  aarons
//
//  Created by Rashaad Ramdeen on 4/23/21.
//  Copyright © 2021 Aaron's, LLC. All rights reserved.
//

import Foundation
import Combine

/**
 RequestRetryPublisher convenience method
 */
extension Publisher where Self.Output == URLSession.DataTaskPublisher.Output, Self.Failure == NetworkError {
    func requestRetry(retries: Int, requestBuilder: RequestBuilder) -> Publishers.RequestRetryPublisher<Self> {
        return Publishers.RequestRetryPublisher(upstream: self, retries: retries, requestBuilder: requestBuilder)
    }
}

/**
 This protocol is needed for Unit Testing purposes mainly and to
 decople or dependency inject the Publisher that will ultimately make the
 request to refresh token. We are now able to inject a custom provider for testing purposes
 */
protocol RefreshTokenPublisherProvider {
    func refreshTokenPublisher() -> AnyPublisher<URLSession.DataTaskPublisher.Output, NetworkError>
}

/**
 RequestRetryPublisher
 */
extension Publishers {
    struct RequestRetryPublisher<Upstream: Publisher>: Publisher where Upstream.Output == URLSession.DataTaskPublisher.Output, Upstream.Failure == NetworkError {
        typealias Output = URLSession.DataTaskPublisher.Output
        typealias Failure = NetworkError
        
        let upstream: Upstream
        let retries: Int
        let requestBuilder: RequestBuilder
        let refreshTokenPublisherProvider: RefreshTokenPublisherProvider?
        
        init(upstream: Upstream, retries: Int, requestBuilder: RequestBuilder, refreshTokenPublisherProvider: RefreshTokenPublisherProvider? = nil) {
            self.upstream = upstream
            self.retries = retries
            self.requestBuilder = requestBuilder
            self.refreshTokenPublisherProvider = refreshTokenPublisherProvider
        }
        
        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            upstream
            .catch { e -> AnyPublisher<Output, Failure> in
                guard retries > 0 else { return Fail(error: e).eraseToAnyPublisher() }
                
                switch e {
                case .unauthorized:
                    guard let refreshTokenPublisher = refreshTokenPublisherProvider?.refreshTokenPublisher() else {
                        return API.sessionBuilder.session
                        .dataTaskPublisher(for: requestBuilder.urlRequest)
                        .mapError { e in .handleError(error: e) }
                        .receive(on: DispatchQueue.main)
                        .requestRetry(retries: retries - 1, requestBuilder: requestBuilder)
                        .eraseToAnyPublisher()
                    }
                    
                    #warning("use async await here")
                    return refreshTokenPublisher.flatMap { response in
                            API.sessionBuilder.session
                            .dataTaskPublisher(for: requestBuilder.urlRequest)
                            .mapError { e in .handleError(error: e) }
                            .receive(on: DispatchQueue.main)
                            .requestRetry(retries: retries - 1, requestBuilder: requestBuilder)
                            .eraseToAnyPublisher()
                        }.eraseToAnyPublisher()
                case .urlError(let urlError):
                    #warning("Need to support contrained retry here if its turned on")
                    if urlError.code == .timedOut {
                        return self.upstream.requestRetry(retries: retries - 1, requestBuilder: requestBuilder).eraseToAnyPublisher()
                    }
                    fallthrough
                default:
                    return Fail(error: e).eraseToAnyPublisher()
                }
            }
            .subscribe(subscriber)
        }
    }
}
