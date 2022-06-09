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
public enum NetworkError: Error {
    case error4xx(_ code: Int, data: Data, response: URLResponse)
    case error5xx(_ code: Int, data: Data, response: URLResponse)
    case urlError(_ urlError: URLError)
    case encodingCodable
    case decodingCodable
    case decodingJWT
    case serializingJSONObject
    case badRequest(data: Data, response: URLResponse)
    case unauthorized(data: Data, response: URLResponse)
    case forbidden(data: Data, response: URLResponse)
    case notFound(data: Data, response: URLResponse)
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
    
    public static func map(_ statusCode: Int, data: Data, response: URLResponse) -> NetworkError {
        switch statusCode {
        case 400: return .badRequest(data: data, response: response)
        case 401: return .unauthorized(data: data, response: response)
        case 403: return .forbidden(data: data, response: response)
        case 404: return .notFound(data: data, response: response)
        case 402, 405...499: return .error4xx(statusCode, data: data, response: response)
        case 500...599: return .error5xx(statusCode, data: data, response: response)
        default:
            return .unknown
        }
    }
    
    public func decode<T: Decodable>(_ type: T.Type) -> T? {
        switch self {
        case .error4xx(_, let data, _),
                .error5xx(_, let data, _),
                .badRequest(let data, _),
                .unauthorized(let data, _),
                .forbidden(let data, _),
                .notFound(let data, _):
            return try? JSONDecoder().decode(T.self, from: data)
        default:
            break
        }
        
        return nil
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.error4xx(let code1, data: let data1, response: let response1), .error4xx(let code2, data: let data2, response: let response2)),
            (.error5xx(let code1, data: let data1, response: let response1), .error5xx(let code2, data: let data2, response: let response2)):
            return code1 == code2 && data1.base64EncodedData() == data2.base64EncodedData() && response1.url == response2.url
            
        // unauthorized == .error4xx(401) equality checks
        case (.error4xx(let code, data: let data1, response: let response1), .unauthorized(data: let data2, response: let response2)),
            (.unauthorized(data: let data2, response: let response2), .error4xx(let code, data: let data1, response: let response1)):
            return code == 401 && data1.base64EncodedData() == data2.base64EncodedData() && response1.url == response2.url
        case (.unauthorized(data: let data1, response: let response1), .unauthorized(data: let data2, response: let response2)):
            return data1.base64EncodedData() == data2.base64EncodedData() && response1.url == response2.url
        
        // badRequest == .error4xx(400) equality checks
        case (.error4xx(let code, data: let data1, response: let response1), .badRequest(data: let data2, response: let response2)),
            (.badRequest(data: let data2, response: let response2), .error4xx(let code, data: let data1, response: let response1)):
            return code == 400 && data1.base64EncodedData() == data2.base64EncodedData() && response1.url == response2.url
        case (.badRequest(data: let data1, response: let response1), .badRequest(data: let data2, response: let response2)):
            return data1.base64EncodedData() == data2.base64EncodedData() && response1.url == response2.url
            
        // forbidden == .error4xx(403) equality checks
        case (.error4xx(let code, data: let data1, response: let response1), .forbidden(data: let data2, response: let response2)),
            (.forbidden(data: let data2, response: let response2), .error4xx(let code, data: let data1, response: let response1)):
            return code == 403 && data1.base64EncodedData() == data2.base64EncodedData() && response1.url == response2.url
        case (.forbidden(data: let data1, response: let response1), .forbidden(data: let data2, response: let response2)):
            return data1.base64EncodedData() == data2.base64EncodedData() && response1.url == response2.url
            
        // notFound == .error4xx(404) equality checks
        case (.error4xx(let code, data: let data1, response: let response1), .notFound(data: let data2, response: let response2)),
            (.notFound(data: let data2, response: let response2), .error4xx(let code, data: let data1, response: let response1)):
            return code == 404 && data1.base64EncodedData() == data2.base64EncodedData() && response1.url == response2.url
        case (.notFound(data: let data1, response: let response1), .notFound(data: let data2, response: let response2)):
            return data1.base64EncodedData() == data2.base64EncodedData() && response1.url == response2.url
        default:
            return false
        }
    }
}
