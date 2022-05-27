//
//  Publishers+Networking.swift
//
//  Created by Rashaad Ramdeen on 4/23/21.
//

import Foundation
import Combine

/**
 RequestRetryPublisher convenience method
 */
public extension Publisher where Self.Output == URLSession.DataTaskPublisher.Output, Self.Failure == NetworkError {
    func requestRetry(retries: Int, requestBuilder: RequestBuilder) -> Publishers.RequestRetryPublisher<Self> {
        return Publishers.RequestRetryPublisher(upstream: self, retries: retries, requestBuilder: requestBuilder)
    }
}

/**
 RequestRetryPublisher
 */
public extension Publishers {
    struct RequestRetryPublisher<Upstream: Publisher>: Publisher where Upstream.Output == URLSession.DataTaskPublisher.Output, Upstream.Failure == NetworkError {
        public typealias Output = URLSession.DataTaskPublisher.Output
        public typealias Failure = NetworkError
        
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
        
        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            upstream
            .catch { e -> AnyPublisher<Output, Failure> in
                guard retries > 0 else { return Fail(error: e).eraseToAnyPublisher() }
                
                switch e {
                case .unauthorized:
                    guard let refreshTokenPublisher = refreshTokenPublisherProvider?.refreshTokenPublisher() else {
                        return Fail(error: e).eraseToAnyPublisher()
                    }
                    
                    #warning("use async await here")
                    return refreshTokenPublisher.flatMap { response in
                            CN.sessionBuilder.session
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
