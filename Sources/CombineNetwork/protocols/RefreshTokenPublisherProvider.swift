//
//  File.swift
//  
//
//  Created by Rashaad Ramdeen on 5/27/22.
//

import Foundation
import Combine

/**
 This protocol is needed for Unit Testing purposes mainly and to
 decople or dependency inject the Publisher that will ultimately make the
 request to refresh token. We are now able to inject a custom provider for testing purposes
 */
public protocol RefreshTokenPublisherProvider {
    var token: String { get }
    var tokenIsValid: Bool { get }
    func refreshTokenPublisher() -> AnyPublisher<URLSession.DataTaskPublisher.Output, NetworkError>
}
