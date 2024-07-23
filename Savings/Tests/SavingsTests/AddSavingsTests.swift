import XCTest
@testable import Savings

final class AddSavingsTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness()
    }

    func testWhenAddButtonIsTapped_ThenRouterIsNotified() async {
        await sut.presenter.didTapAddButton()
        XCTAssertEqual(sut.router.didTapAddButtonCalled, 1)
    }
}
