import XCTest
@testable import Savings

final class RefreshTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness()
    }

    func testWhenViewIsLoaded_AndViewIsRefreshed_ThenDataIsRefreshed() async {
        await sut.presenter.didLoad()

        sut.savingsDataSource.savingsToReturn = [SavingGoal(id: "new_id",
                                                            name: "new_name",
                                                            currency: "new_currency",
                                                            target: Balance(currency: "new_currency",
                                                                            minorUnits: 3493),
                                                            balance: Balance(currency: "new_currency",
                                                                             minorUnits: 23463),
                                                            savedPercentage: 40)]
        await sut.presenter.didRefresh()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence, [.loading,
                                           .loaded(savings: MockData.expectedSavingsViewModel),
                                           .loaded(savings: [SavingsViewModel(title: "new_name",
                                                                              subtitle: "Target: adapted",
                                                                              progress: 0.4,
                                                                              hideProgressBar: false,
                                                                              totalInAccount: "adapted",
                                                                              voiceOver: "Saving goal for a new_name. Current balance is adapted. Target goal is adapted")])])
    }

    func testWhenSavingsAreAddedExternally_ThenViewIsRefreshedWithCorrectData() async {
        await sut.controller.didAddSavings()

        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertEqual(viewStateSequence, [.loaded(savings: MockData.expectedSavingsViewModel)])
    }
}

struct MockData {

    static var expectedSavingsViewModel: [SavingsViewModel] {
        return [SavingsViewModel(title: "goal 1",
                                 subtitle: nil,
                                 progress: 0.0,
                                 hideProgressBar: true,
                                 totalInAccount: "adapted",
                                 voiceOver: "Saving goal for a goal 1. Current balance is adapted."),
                SavingsViewModel(title: "goal 2",
                                 subtitle: "Target: adapted",
                                 progress: 0.5,
                                 hideProgressBar: false,
                                 totalInAccount: "adapted",
                                 voiceOver: "Saving goal for a goal 2. Current balance is adapted. Target goal is adapted")]
    }

}
