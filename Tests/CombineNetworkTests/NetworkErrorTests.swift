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
        XCTAssertEqual(.unauthorized, NetworkError.error4xx(401))
        XCTAssertEqual(NetworkError.error4xx(401), .unauthorized)
        XCTAssertEqual(NetworkError.error4xx(401), .error4xx(401))
        XCTAssertEqual(NetworkError.unauthorized, .unauthorized)
        
        XCTAssertEqual(.badRequest, NetworkError.error4xx(400))
        XCTAssertEqual(NetworkError.error4xx(400), .badRequest)
        XCTAssertEqual(NetworkError.error4xx(400), .error4xx(400))
        XCTAssertEqual(NetworkError.badRequest, .badRequest)
        
        XCTAssertEqual(.forbidden, NetworkError.error4xx(403))
        XCTAssertEqual(NetworkError.error4xx(403), .forbidden)
        XCTAssertEqual(NetworkError.error4xx(403), .error4xx(403))
        XCTAssertEqual(NetworkError.forbidden, .forbidden)
        
        XCTAssertEqual(.notFound, NetworkError.error4xx(404))
        XCTAssertEqual(NetworkError.error4xx(404), .notFound)
        XCTAssertEqual(NetworkError.error4xx(404), .error4xx(404))
        XCTAssertEqual(NetworkError.notFound, .notFound)
        
        XCTAssertEqual(NetworkError.decodingCodable, .decodingCodable)
        XCTAssertEqual(NetworkError.decodingJWT, .decodingJWT)
        XCTAssertEqual(NetworkError.encodingCodable, .encodingCodable)
    }

}
