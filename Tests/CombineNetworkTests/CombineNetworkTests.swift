import XCTest
@testable import CombineNetwork

final class CombineNetworkTests: XCTestCase {
    
    struct CustomRequest: RequestBuilder {
        var url: URL = URL(string: "http://example.com")!
    }
    
    func test_RequestBuilder() {
        XCTAssertNotNil(CustomRequest().url)
    }
}
