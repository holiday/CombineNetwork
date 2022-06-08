//
//  JSONParameterEncoderTests.swift
//  
//
//  Created by Rashaad Ramdeen on 5/20/22.
//

import XCTest
@testable import CombineNetwork

class JSONDataEncoderTests: XCTestCase {
    let jsonEncoder = JSONDataEncoder(options: [.sortedKeys])
    
    func test_json_encoder1() throws {
        let data = try jsonEncoder.encode(parameters: [
            "1": 1,
            "2": "two",
            "3": [1,2,3]
        ])
        
        let jsonString = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertEqual(jsonString, "{\"1\":1,\"2\":\"two\",\"3\":[1,2,3]}")
    }
    
    func test_json_encoder2() throws {
        let data = try jsonEncoder.encode(parameters: [
            "1": true,
            "2": 2,
            "3": [1,"2", false],
            "4": ["1": "one", "2": "two", "3": [1,2,3]]
        ])
        
        let jsonString = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertEqual(jsonString, "{\"1\":true,\"2\":2,\"3\":[1,\"2\",false],\"4\":{\"1\":\"one\",\"2\":\"two\",\"3\":[1,2,3]}}")
    }
}
