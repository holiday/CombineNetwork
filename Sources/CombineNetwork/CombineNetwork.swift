//
//  API.swift
//
//  Created by Rashaad Ramdeen on 4/23/21.
//

import Foundation
import Combine

var sessionBuilder: SessionBuilder = DefaultSessionBuilder(timeout: 30)

var validHttpStatusCodes: ClosedRange<Int> { 200...399 }

/**
 In some cases you may want to disable the unauthorizedPassThroughSubject from firing
 */
var enableUnauthorizedPassThroughSubject = false

/**
 Allows you to perform a final action before fully failing 100% (i.e. all retry attempts to recovery has failed)
 */
var unauthorizedPassThroughSubject: PassthroughSubject<NetworkError, Never>?

var tokenExpiredOrMissing: Bool {
    return false
}

func fetch(
    requestBuilder: RequestBuilder,
    retries: Int = 2,
    receiveSubscription: ((Subscription) -> Void)? = nil) -> AnyPublisher<URLSession.DataTaskPublisher.Output, NetworkError> {
    return
        URLSession.dataTaskPublisher(urlsession: sessionBuilder.session, requestBuilder: requestBuilder)
        .tryMap { output in
            /// Verify that we got an HTTP Response and its status code is within the valid range, otherwise throw a NetworkError with status code
            if let httpResponse = output.response as? HTTPURLResponse, !validHttpStatusCodes.contains(httpResponse.statusCode) {
                throw NetworkError.map(httpResponse.statusCode)
            }
            return output
        }
        .handleEvents(receiveSubscription: receiveSubscription) //for testing and debugging
        .mapError { e in .handleError(error: e) }
        .receive(on: DispatchQueue.main)
        .requestRetry(retries: retries, requestBuilder: requestBuilder)
        .tryCatch { networkError -> AnyPublisher<URLSession.DataTaskPublisher.Output, NetworkError> in
            guard enableUnauthorizedPassThroughSubject else {
                throw networkError
            }
            
            switch networkError {
            case .unauthorized, .error4xx(401):
                /// enableUnauthorizedPassThroughSubject is on therefore send the error via unauthorizedPassThroughSubject
                unauthorizedPassThroughSubject?.send(networkError)
            default:
                break
            }
            
            throw networkError
        }
        .mapError { e in NetworkError.handleError(error: e) }
        .eraseToAnyPublisher()
}

func fetch<T: Decodable>(
    requestBuilder: RequestBuilder,
    retries: Int = 2,
    decodableType: T.Type) -> AnyPublisher<NetworkResponse<T>, NetworkError> {
    return fetch(requestBuilder: requestBuilder, retries: retries)
        .decodeNetworkResponse(decodable: T.self)
        .mapError { e in
            .handleError(error: e)
        }
        .eraseToAnyPublisher()
}
