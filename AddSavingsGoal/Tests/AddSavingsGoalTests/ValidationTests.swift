import XCTest
@testable import AddSavingsGoal

final class ValidationTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness()
    }

    func testWhenGoalIsValidatedWithoutANameOrGoal_ThenValidationFails() async {
        await sut.presenter.didUpdateGoal(goal: nil, value: nil)
        let addButtonEnabled = await sut.view.addButtonEnabled

        XCTAssertFalse(addButtonEnabled)
    }

    func testWhenGoalIsValidatedWithANameButNoGoal_ThenValidationPasses() async {
        await sut.presenter.didUpdateGoal(goal: "a goal", value: nil)
        let addButtonEnabled = await sut.view.addButtonEnabled

        XCTAssertTrue(addButtonEnabled)
    }

    func testWhenGoalIsValidatedWithANameButAndANumericString_ThenValidationPassed() async {
        await sut.presenter.didUpdateGoal(goal: "a goal", value: "46754")
        let addButtonEnabled = await sut.view.addButtonEnabled

        XCTAssertTrue(addButtonEnabled)
    }

    func testWhenGoalIsValidatedWithANameButAndAInvalidString_ThenValidationPassed() async {
        await sut.presenter.didUpdateGoal(goal: "a goal", value: "will_fail")
        let addButtonEnabled = await sut.view.addButtonEnabled

        XCTAssertFalse(addButtonEnabled)
    }

    func testWhenGoalIsValidatedWithANameButAndADecimalString_ThenValidationPassed() async {
        await sut.presenter.didUpdateGoal(goal: "a goal", value: "4.50")
        let addButtonEnabled = await sut.view.addButtonEnabled

        XCTAssertFalse(addButtonEnabled)
    }
}
