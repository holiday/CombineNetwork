//
//  NetworkErrorTests.swift
//  
//
//  Created by Rashaad Ramdeen on 6/8/22.
//

import XCTest
@testable import CombineNetwork

class NetworkErrorTests: XCTestCase {

    func test_network_errors() throws {
        XCTAssertEqual(NetworkError.error4xx(401, data: Data(), response: URLResponse()), .unauthorized(data: Data(), response: URLResponse()))
        XCTAssertEqual(NetworkError.error4xx(401, data: Data(), response: URLResponse()), .error4xx(401, data: Data(), response: URLResponse()))
        XCTAssertEqual(NetworkError.unauthorized(data: Data(), response: URLResponse()), .unauthorized(data: Data(), response: URLResponse()))
        XCTAssertEqual(.unauthorized(data: Data(), response: URLResponse()), NetworkError.error4xx(401, data: Data(), response: URLResponse()))

        XCTAssertEqual(NetworkError.error4xx(400, data: Data(), response: URLResponse()), .badRequest(data: Data(), response: URLResponse()))
        XCTAssertEqual(NetworkError.error4xx(400, data: Data(), response: URLResponse()), .error4xx(400, data: Data(), response: URLResponse()))
        XCTAssertEqual(NetworkError.badRequest(data: Data(), response: URLResponse()), .badRequest(data: Data(), response: URLResponse()))
        XCTAssertEqual(.badRequest(data: Data(), response: URLResponse()), NetworkError.error4xx(400, data: Data(), response: URLResponse()))
        
        XCTAssertEqual(NetworkError.error4xx(403, data: Data(), response: URLResponse()), .forbidden(data: Data(), response: URLResponse()))
        XCTAssertEqual(NetworkError.error4xx(403, data: Data(), response: URLResponse()), .error4xx(403, data: Data(), response: URLResponse()))
        XCTAssertEqual(NetworkError.forbidden(data: Data(), response: URLResponse()), .forbidden(data: Data(), response: URLResponse()))
        XCTAssertEqual(.forbidden(data: Data(), response: URLResponse()), NetworkError.error4xx(403, data: Data(), response: URLResponse()))
        
        XCTAssertEqual(NetworkError.error4xx(404, data: Data(), response: URLResponse()), .notFound(data: Data(), response: URLResponse()))
        XCTAssertEqual(NetworkError.error4xx(404, data: Data(), response: URLResponse()), .error4xx(404, data: Data(), response: URLResponse()))
        XCTAssertEqual(NetworkError.notFound(data: Data(), response: URLResponse()), .notFound(data: Data(), response: URLResponse()))
        XCTAssertEqual(.notFound(data: Data(), response: URLResponse()), NetworkError.error4xx(404, data: Data(), response: URLResponse()))
    }

}
