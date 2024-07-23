@testable import Home
import XCTest

class RoundUpTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness(selectedDate: Calendar.current.date(byAdding: .day, value: 2, to: .init(timeIntervalSince1970: 0))!,
                                defaultEndDate: Calendar.current.date(byAdding: .day, value: 12, to: .init(timeIntervalSince1970: 0))!)
    }

    func testWhenUserPressesRoundUp_ThenRouterIsNotifiedWithCorrectBalance() async {
        let router = SpyRouter()
        sut.controller.set(router)
        await sut.presenter.didLoad()
        await sut.presenter.didPressRoundUp()

        XCTAssertEqual(router.balance, Balance(currency: "currency", minorUnits: 178))
    }

    func testWhenUserPressesRoundUp_AndViewHasntLoaded_ThenErrorIsPresented() async {
        await sut.presenter.didPressRoundUp()

        XCTAssertEqual(sut.view.viewStateSequence, [.error(error: RoundUpError.failedToRoundUp)])
    }

}
