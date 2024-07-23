import XCTest
@testable import AddSavingsGoal

final class KeyboardInteractionTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness()
    }

    func testWhenKeyboardIsHidden_AndKeyboardIsShown_ThenViewIsNotified() async {
        sut.presenter.keyboardHidden()
        await sut.presenter.keyboardWillShow(sizeValue: CGRect(x: 0, y: 0, width: 100, height: 129),
                                             durationValue: 200.0)

        let keyboardHeight = await sut.view.keyboardHeight
        let animationDuration = await sut.view.animationDuration

        XCTAssertEqual(keyboardHeight, 129)
        XCTAssertEqual(animationDuration, 200.0)
    }

    func testWhenKeyboardIsHidden_AndKeyboardIsShownWithIncorrectValues_ThenViewIsntNotified() async {
        sut.presenter.keyboardHidden()
        await sut.presenter.keyboardWillShow(sizeValue: "A string wont work",
                                             durationValue: "A string wont work")

        let keyboardHeight = await sut.view.keyboardHeight
        let animationDuration = await sut.view.animationDuration

        XCTAssertNil(keyboardHeight)
        XCTAssertNil(animationDuration)
    }

    func testWhenKeyboardIsShown_AndKeyboardAttemptsToShowAgain_ThenViewIsntNotified() async {
        sut.presenter.keyboardShown()
        await sut.presenter.keyboardWillShow(sizeValue: CGRect(x: 0, y: 0, width: 100, height: 129),
                                             durationValue: 200.0)
        let keyboardHeight = await sut.view.keyboardHeight
        let animationDuration = await sut.view.animationDuration

        XCTAssertNil(keyboardHeight)
        XCTAssertNil(animationDuration)
    }

    func testWhenKeyboardIsHidden_AndKeyboardAttemptsToHideAgain_ThenViewIsntNotified() async {
        sut.presenter.keyboardHidden()
        await sut.presenter.keyboardWillHide(sizeValue: CGRect(x: 0, y: 0, width: 100, height: 129),
                                             durationValue: 200.0)
        let keyboardHeight = await sut.view.keyboardHeight
        let animationDuration = await sut.view.animationDuration

        XCTAssertNil(keyboardHeight)
        XCTAssertNil(animationDuration)
    }

    func testWhenKeyboardIsVisible_AndKeyboardIsShownWithIncorrectValue_ThenViewIsntNotified() async {
        sut.presenter.keyboardShown()
        await sut.presenter.keyboardWillHide(sizeValue: "A string wont work",
                                             durationValue: "A string wont work")
        let keyboardHeight = await sut.view.keyboardHeight
        let animationDuration = await sut.view.animationDuration

        XCTAssertNil(keyboardHeight)
        XCTAssertNil(animationDuration)
    }

    func testWhenKeyboardIsVisible_AndKeyboardIsHidden_ThenViewIsNotified() async {
        sut.presenter.keyboardShown()
        await sut.presenter.keyboardWillHide(sizeValue: CGRect(x: 0, y: 0, width: 100, height: 229),
                                             durationValue: 300.0)

        let keyboardHeight = await sut.view.keyboardHeight
        let animationDuration = await sut.view.animationDuration

        XCTAssertEqual(keyboardHeight, 229)
        XCTAssertEqual(animationDuration, 300.0)
    }
}
