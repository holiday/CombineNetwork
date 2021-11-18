//
//  API.swift
//  aarons
//
//  Created by Rashaad Ramdeen on 4/23/21.
//  Copyright © 2021 Aaron's, LLC. All rights reserved.
//

import Foundation
import Combine

struct API {
    public static var sessionBuilder: SessionBuilder = DefaultSessionBuilder()
    
    public static var validHttpStatusCodes: ClosedRange<Int> { 200...399 }
    
    /**
     In some cases you may want to disable the unauthorizedPassThroughSubject from firing
     */
    public static var enableUnauthorizedPassThroughSubject = false
    
    /**
     Allows you to perform a final action before fully failing 100% (i.e. all retry attempts to recovery has failed)
     */
    public static var unauthorizedPassThroughSubject: PassthroughSubject<NetworkError, Never>?
    
    static var tokenExpiredOrMissing: Bool {
        return false
    }
    
    static func fetch(requestBuilder: RequestBuilder, retries: Int = 2, receiveSubscription: ((Subscription) -> Void)? = nil) -> AnyPublisher<URLSession.DataTaskPublisher.Output, NetworkError> {
        return
            URLSession.dataTaskPublisher(urlsession: API.sessionBuilder.session, requestBuilder: requestBuilder)
            .tryMap { output in
                // This should account for things like 304 or 302 which are not considered failures however it will not affect things since we dont support those responses
                // Change the range to include up to 399 as a possible solution
                if let httpResponse = output.response as? HTTPURLResponse, !API.validHttpStatusCodes.contains(httpResponse.statusCode) {
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
                
                /**
                 The only errors we care about are those pertaining to authorization, so far our backend will
                 normally throw a 401 for 99% of the cases and in the rare occasion a 400. There may be others
                 however we will consider those edge cases for now. Getting to this point is already an edge case since
                 OKTA refresh tokens typically last a year.
                 */
                switch networkError {
                case .unauthorized, .error4xx(401):
                    unauthorizedPassThroughSubject?.send(networkError)
                default:
                    break
                }
                
                throw networkError
            }
            .mapError { e in NetworkError.handleError(error: e) }
            .eraseToAnyPublisher()
    }
    
    static func fetchAndDecode<T: Decodable>(requestBuilder: RequestBuilder, retries: Int = 2, decodableType: T.Type) -> AnyPublisher<NetworkResponse<T>, NetworkError> {
        return API.fetch(requestBuilder: requestBuilder, retries: retries)
            .decodeNetworkResponse(decodable: T.self)
            .mapError { e in
                .handleError(error: e)
            }
            .eraseToAnyPublisher()
    }
}
