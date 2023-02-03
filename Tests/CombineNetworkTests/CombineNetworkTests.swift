import XCTest
@testable import CombineNetwork

final class CombineNetworkTests: XCTestCase {
    
    struct TestObject: Encodable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
        }
    }
    
    struct CustomRequest: RequestBuilder {
        var url: URL = URL(string: "http://example.com")!
        
        var shouldPublish401: Bool {
            return false
        }
        
        func encodeParameters(urlRequest: inout URLRequest) throws {
            urlRequest.httpBody = try JSONObjectEncoder<[TestObject]>(readingOptions: [], writingOptions: []).encode(parameters: [TestObject(name: "Joe"), TestObject(name: "John")])
        }
    }
    
    func test_RequestBuilder() throws {
        let request = CustomRequest()
        XCTAssertNotNil(request.url)
        
        let jsonData = try JSONObjectEncoder<[TestObject]>(readingOptions: [], writingOptions: []).encode(parameters: [
            TestObject(name: "Joe"), TestObject(name: "John")
        ])
        let jsonString = String(data: jsonData, encoding: .utf8)
        let urlRequestJsonString = String(data: request.urlRequest.httpBody!, encoding: .utf8)
        XCTAssertEqual(jsonString, urlRequestJsonString)
    }
}
