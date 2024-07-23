import XCTest
@testable import RoundUp

final class AddRoundUpTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness()
    }

    func testWhenViewIsLoaded_AndUserTapsRoundUp_ThenViewIsUpdated() async {
        await sut.presenter.didLoad()
        await sut.presenter.didTapRoundUpButton()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence,
                       [.loading,
                        .loaded(viewModel: RoundUpViewControllerViewModel(savingsGoals: MockData.expectedSavingsGoals,
                                                                          roundUpOverview: MockData.expectedAccountOverview,
                                                                          selectedSavingsGoal: 0)),
                        ViewState.roundUpBeingAdded,
                        ViewState.roundUpAdded])
    }

    func testWhenUserTapsAddRoundUp_AndAccountDataSourceThrowsError_ThenViewIsUpdated() async {
        await sut.presenter.didLoad()
        sut.accountDataSource.shouldThrow = true
        await sut.presenter.didTapRoundUpButton()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence,
                       [.loading,
                        .loaded(viewModel: RoundUpViewControllerViewModel(savingsGoals: MockData.expectedSavingsGoals,
                                                                          roundUpOverview: MockData.expectedAccountOverview,
                                                                          selectedSavingsGoal: 0)),
                        .roundUpBeingAdded,
                        .error(error: RoundUpTests.DummyError.accountError)])
    }

    func testWhenUserTapsAddRoundUp_AndSavingsDataSourceThrowsError_ThenViewIsUpdated() async {
        sut.savingsDataSource.shouldThrowWhilstAdding = true
        await sut.presenter.didLoad()
        await sut.presenter.didTapRoundUpButton()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence,
                       [.loading,
                        .loaded(viewModel: RoundUpViewControllerViewModel(savingsGoals: MockData.expectedSavingsGoals,
                                                                          roundUpOverview: MockData.expectedAccountOverview,
                                                                          selectedSavingsGoal: 0)),
                        .roundUpBeingAdded,
                        .error(error: DummyError.savingsError)])
    }

    func testWhenUserTapsAdd_ThenCorrectDataIsPassedToSavingsDataSource() async {
        await sut.presenter.didLoad()
        await sut.presenter.didTapRoundUpButton()

        XCTAssertEqual(sut.savingsDataSource.accountId, "account_uid")
        XCTAssertEqual(sut.savingsDataSource.savingsGoalUuid, "id 1")
        XCTAssertEqual(sut.savingsDataSource.transferUuid, "uuid_provided")
        XCTAssertEqual(sut.savingsDataSource.balance, Balance(currency: "GBP", minorUnits: 4500))
    }

    func testWhenViewIsntLoaded_AndUserTapsRoundUp_ThenViewIsUpdated() async {
        await sut.presenter.didTapRoundUpButton()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence,
                       [ViewState.roundUpBeingAdded, 
                        ViewState.error(error: AddRoundUpError.noGoalSelected)])
    }

    func testWhenUserSuccessfullyAddsRoundUp_AndDismissesSuccessAlert_ThenRouterIsNotified() async {
        await sut.presenter.didDissmisSuccessPopup()
        let didRoundUpCalledCount = await sut.router.didRoundUpCalledCount
        XCTAssertEqual(didRoundUpCalledCount, 1)
    }
}


enum MockData {
    static var expectedAccountOverview: AccountOverviewViewModel {
        AccountOverviewViewModel(title: "name",
                                 subtitle: nil,
                                 progress: 0.0,
                                 hideProgressBar: true,
                                 totalInAccount: "Adapter hit")
    }
    static var expectedSavingsGoals: [AccountOverviewViewModel] {
        [AccountOverviewViewModel(title: "goal 1",
                                  subtitle: nil,
                                  progress: 0.0,
                                  hideProgressBar: true,
                                  totalInAccount: "Adapter hit"),
         AccountOverviewViewModel(title: "goal 2",
                                  subtitle: "Target: Adapter hit",
                                  progress: 0.5,
                                  hideProgressBar: false,
                                  totalInAccount: "Adapter hit")]
    }
}
