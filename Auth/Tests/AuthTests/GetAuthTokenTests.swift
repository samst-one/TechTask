import XCTest
@testable import Auth

final class GetAuthTokenTests: XCTestCase {

    let sut = TestHarness()

    func testGetAuthToken() async {
        let token = await sut.controller.authTokenController.token
        XCTAssertEqual(token, "token")
    }
}
