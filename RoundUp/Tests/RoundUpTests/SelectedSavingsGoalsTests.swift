import XCTest
@testable import RoundUp

final class SelectedSavingsGoalsTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness()
    }

    func testWhenViewHasLoaded_AndGoalIsSelected_ThenViewIsUpdated() async {
        await sut.presenter.didLoad()
        await sut.presenter.didSelectSavingsGoal(at: 1)

        let selectedSavingsGoal = await sut.view.selectedSavingsGoal

        XCTAssertEqual(selectedSavingsGoal, AccountOverviewViewModel(title: "goal 2",
                                                                              subtitle: "Target: Adapter hit",
                                                                              progress: 0.5,
                                                                              hideProgressBar: false,
                                                                              totalInAccount: "Adapter hit"))
    }

    func testWhenViewHasntLoaded_AndGoalIsSelected_ThenViewIsUpdated() async {
        await sut.presenter.didSelectSavingsGoal(at: 1)

        let selectedSavingsGoal = await sut.view.selectedSavingsGoal
        let viewStateSequence = await sut.view.viewStateSequence

        XCTAssertNil(selectedSavingsGoal)
        XCTAssertEqual(viewStateSequence, [.error(error: SelectingGoalError.goalOutOfBounds)])
    }

}
