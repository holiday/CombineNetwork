//
//  JSONObjectParameterEncoder.swift
//  
//
//  Created by Rashaad Ramdeen on 6/8/22.
//

import XCTest
@testable import CombineNetwork

class JSONObjectEncoderTests: XCTestCase {
    let jsonEncoder = JSONObjectEncoder<TestObject>(readingOptions: [], writingOptions: [])
    
    struct TestObject: Encodable {
        let firstName: String
        let lastName: String
        let age: Int
        let isStudent: Bool
        
        enum CodingKeys: String, CodingKey {
            case firstName
            case lastName
            case age
            case isStudent
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(firstName, forKey: .firstName)
            try container.encode(lastName, forKey: .lastName)
            try container.encode(age, forKey: .age)
            try container.encode(isStudent, forKey: .isStudent)
        }
    }

    func test_encoding() throws {
        let object = TestObject(firstName: "John", lastName: "Doe", age: 1, isStudent: true)
        let data = try jsonEncoder.encode(parameters: object)
        let dict = try XCTUnwrap(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        XCTAssertEqual(dict["firstName"] as! String, "John")
        XCTAssertEqual(dict["lastName"] as! String, "Doe")
        XCTAssertEqual(dict["age"] as! Int, 1)
        XCTAssertEqual(dict["isStudent"] as! Bool, true)
        XCTAssertNil(dict["someRandom"])
    }
}
