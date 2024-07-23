import XCTest
@testable import Networking

class RequestBuilderTests: XCTestCase {

    func testWhenInitialisedWithBadUrl_ThenInitThrows() {
        do {
            let _ = try RequestBuilder(baseUrl: "http://malformed-base-url.com:-80/")
            XCTFail("Expected throw")
        } catch let error {
            XCTAssertEqual(error as! NetworkError, .malformedUrl)
        }
    }
}
