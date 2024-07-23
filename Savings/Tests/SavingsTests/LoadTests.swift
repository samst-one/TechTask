import XCTest
@testable import Savings

final class LoadTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness()
    }

    func testWhenViewIsLoaded_ThenCorrectDataIsPassedToTheView() async {
        await sut.presenter.didLoad()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence, [.loading,
                                           .loaded(savings: MockData.expectedSavingsViewModel)])
    }

    func testWhenViewIsLoaded_AndNoSavingsAreReturned_ThenZeroStateIsPassedToTheView() async {
        sut.savingsDataSource.returnEmptyArray = true
        await sut.presenter.didLoad()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence, [.loading,
                                           .zeroState])
    }

    func testWhenViewIsLoaded_AndAccountDataSourceThrows_ThenCorrectErrorIsPassedToTheView() async {
        sut.accountDataSource.shouldThrow = true
        await sut.presenter.didLoad()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence, [.loading,
                                           .error(error: DummyError.accountError)])
    }

    func testWhenViewIsLoaded_AndSavingsDataSourceThrows_ThenCorrectErrorIsPassedToTheView() async {
        sut.savingsDataSource.shouldThrow = true
        await sut.presenter.didLoad()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence, [.loading,
                                           .error(error: DummyError.savingsError)])
    }
}
