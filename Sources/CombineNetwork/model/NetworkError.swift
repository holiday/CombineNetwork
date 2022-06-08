//
//  NetworkError.swift
//
//  Created by Rashaad Ramdeen on 11/12/20.
//

import Foundation

enum ParameterEncodableError: Error {
    case encodingRequestParameters(_ error: Error)
}

/**
 Universal enum for handling NetworkErrors
 */
public enum NetworkError: Error, Equatable {
    case error4xx(_ code: Int)
    case error5xx(_ code: Int)
    case urlError(_ urlError: URLError)
    case encodingCodable
    case decodingCodable
    case decodingJWT
    case serializingJSONObject
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case unknown
    
    public static func handleError(error: Error) -> NetworkError {
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
    
    public static func map(_ statusCode: Int) -> NetworkError {
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
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.error4xx(let lhsCode), .error4xx(let rhsCode)):
            return lhsCode == rhsCode
        case (.error5xx(let lhsCode), .error5xx(let rhsCode)):
            return lhsCode == rhsCode
        case (.urlError(let lhsError), .urlError(let rhsError)):
            return lhsError.code == rhsError.code
        case (.encodingCodable, .encodingCodable),
            (.decodingCodable, .decodingCodable),
             (.decodingJWT, .decodingJWT),
             (.serializingJSONObject, .serializingJSONObject),
             (.badRequest, .badRequest),
             (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.unknown, .unknown):
            return true
        case (.badRequest, .error4xx(let code)), (.error4xx(let code), .badRequest):
            return .map(code) == .badRequest
        case (.unauthorized, .error4xx(let code)), (.error4xx(let code), .unauthorized):
            return .map(code) == .unauthorized
        case (.forbidden, .error4xx(let code)), (.error4xx(let code), .forbidden):
            return .map(code) == .forbidden
        case (.notFound, .error4xx(let code)), (.error4xx(let code), .notFound):
            return .map(code) == .notFound
        default:
            return false
        }
    }
}
