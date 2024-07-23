import XCTest
@testable import RoundUp

final class LoadTests: XCTestCase {
    
    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness()
    }

    func testWhenViewLoads_ThenViewStateIsUpdated() async {
        await sut.presenter.didLoad()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence,
                       [.loading,
                        .loaded(viewModel: RoundUpViewControllerViewModel(savingsGoals: MockData.expectedSavingsGoals,
                                                                          roundUpOverview: MockData.expectedAccountOverview,
                                                                          selectedSavingsGoal: 0))])
    }

    func testWhenViewLoads_AndThereAreNoSavingsGoals_ThenViewStateIsUpdated() async {
        sut.savingsDataSource.returnEmptyArray = true
        await sut.presenter.didLoad()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence,
                       [.loading,
                        .zeroState])
    }

    func testWhenViewLoads_AndSavingsDataSourceThrows_ThenViewStateIsUpdated() async {
        sut.savingsDataSource.shouldThrow = true
        await sut.presenter.didLoad()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence,
                       [.loading,
                        .error(error: DummyError.savingsError)])
    }

    func testWhenViewLoads_AndAccountDataSourceThrows_ThenViewStateIsUpdated() async {
        sut.accountDataSource.shouldThrow = true
        await sut.presenter.didLoad()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence,
                       [.loading,
                        .error(error: DummyError.accountError)])
    }
}
