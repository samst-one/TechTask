import XCTest
@testable import AddSavingsGoal

final class AddSavingsGoalTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness()
    }

    func testWhenGoalIsValidatedWithoutANameOrGoal_ThenValidationFails() async {
        await sut.presenter.didTapAddGoal(goal: nil, value: nil)
        let error = await sut.view.errorToPresent

        XCTAssertEqual(error as? ValidationErrors, ValidationErrors.validationFailure)
    }

    func testWhenGoalIsValidatedWithANameAndAString_ThenViewPresentsError() async {
        await sut.presenter.didTapAddGoal(goal: "a goal", value: "will_fail")
        let error = await sut.view.errorToPresent

        XCTAssertEqual(error as? ValidationErrors, ValidationErrors.validationFailure)
    }

    func testWhenGoalIsValidatedWithANameAndADecimalString_ThenViewPresentsError() async {
        await sut.presenter.didTapAddGoal(goal: "a goal", value: "4.50")
        let error = await sut.view.errorToPresent

        XCTAssertEqual(error as? ValidationErrors, ValidationErrors.validationFailure)
    }

    func testWhenGoalIsValidatedWithAnEmptyName_ThenViewPresentsError() async {
        await sut.presenter.didTapAddGoal(goal: "", value: nil)
        let error = await sut.view.errorToPresent

        XCTAssertEqual(error as? ValidationErrors, ValidationErrors.validationFailure)
    }

    func testWhenGoalIsValidatedWithANameAndANumericString_AndGoalAddedSucccesfully_ThenRouterIsNotified() async {
        await sut.presenter.didTapAddGoal(goal: "a goal", value: "46754")

        XCTAssertEqual(sut.router.didAddSavingsGoalCalled, 1)
    }

    func testWhenGoalIsValidatedWithANameButNoGoal_AndGoalAddedSucccesfully_ThenRouterIsNotified() async {
        await sut.presenter.didTapAddGoal(goal: "a goal", value: nil)
        
        XCTAssertEqual(sut.router.didAddSavingsGoalCalled, 1)
    }

    func testWhenValidGoalIsAdded_AndAccountDataSourceEncoutersError_ThenViewPresentsError() async {
        sut.accountDataSource.shouldThrow = true
        await sut.presenter.didTapAddGoal(goal: "a goal", value: nil)
        let error = await sut.view.errorToPresent

        XCTAssertEqual(error as? DummyError, DummyError.accountError)
    }

    func testWhenValidGoalIsAdded_AndSavingsDataSourceEncoutersError_ThenViewPresentsError() async {
        sut.savingsDataSource.shouldThrow = true
        await sut.presenter.didTapAddGoal(goal: "a goal", value: nil)
        let error = await sut.view.errorToPresent

        XCTAssertEqual(error as? DummyError, DummyError.savingsError)
    }
}
