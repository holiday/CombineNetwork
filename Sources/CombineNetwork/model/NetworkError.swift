//
//  NetworkError.swift
//
//  Created by Rashaad Ramdeen on 11/12/20.
//

import Foundation

/**
 Universal enum for handling NetworkErrors
 */
enum NetworkError: Error, Equatable {
    case error4xx(_ code: Int)
    case error5xx(_ code: Int)
    case urlError(_ urlError: URLError)
    case decodingCodable
    case decodingJWT
    case serializingJSONObject
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case unknown
    
    static func handleError(error: Error) -> NetworkError {
        switch error {
        case is Swift.DecodingError:
            return .decodingCodable
        case let urlError as URLError:
            return .urlError(urlError)
        case let networkError as NetworkError:
            return networkError
        default:
            return .unknown
        }
    }
    
    static func map(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500...599: return .error5xx(statusCode)
        default:
            return .unknown
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.error4xx(let lhsCode), .error4xx(let rhsCode)):
            return lhsCode == rhsCode
        case (.error5xx(let lhsCode), .error5xx(let rhsCode)):
            return lhsCode == rhsCode
        case (.urlError(let lhsError), .urlError(let rhsError)):
            return lhsError.code == rhsError.code
        case (.decodingCodable, .decodingCodable),
             (.decodingJWT, .decodingJWT),
             (.serializingJSONObject, .serializingJSONObject),
             (.badRequest, .badRequest),
             (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
