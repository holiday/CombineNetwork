//
//  API.swift
//
//  Created by Rashaad Ramdeen on 4/23/21.
//

import Foundation
import Combine

public struct CN {
    public static var sessionBuilder: SessionBuilder = DefaultSessionBuilder(timeout: 30)

    public static var validHttpStatusCodes: ClosedRange<Int> { 200...399 }
    
    /**
     In some cases you may want to disable the unauthorizedPassThroughSubject from firing
     */
    public static var enableUnauthorizedPassThroughSubject = false

    /**
     Allows you to perform a final action before fully failing 100% (i.e. all retry attempts to recovery has failed)
     */
    public static var unauthorizedPassThroughSubject: PassthroughSubject<NetworkError, Never>?
    
    public static func fetch(
        requestBuilder: RequestBuilder,
        retries: Int = 2,
        receiveSubscription: ((Subscription) -> Void)? = nil) -> AnyPublisher<URLSession.DataTaskPublisher.Output, NetworkError> {
        return
            URLSession.dataTaskPublisher(urlsession: sessionBuilder.session, requestBuilder: requestBuilder)
            .tryMap { output in
                /// Verify that we got an HTTP Response and its status code is within the valid range, otherwise throw a NetworkError with status code
                if let httpResponse = output.response as? HTTPURLResponse, !validHttpStatusCodes.contains(httpResponse.statusCode) {
                    throw NetworkError.map(httpResponse.statusCode, data: output.data, response: output.response)
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
                case .unauthorized:
                    /// enableUnauthorizedPassThroughSubject is on therefore send the error via unauthorizedPassThroughSubject
                    unauthorizedPassThroughSubject?.send(networkError)
                case .error4xx(let code, _, _):
                    if code == 401 {
                        unauthorizedPassThroughSubject?.send(networkError)
                    }
                default:
                    break
                }
                
                throw networkError
            }
            .mapError { e in NetworkError.handleError(error: e) }
            .eraseToAnyPublisher()
    }

    public static func fetch<T: Decodable>(
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
}


