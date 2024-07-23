import XCTest
import LocalServer

final class ValidationUITests: XCTestCase {

    var localServer: LocalServerController!
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        localServer = LocalServer.Factory.make()
        continueAfterFailure = false
        localServer.start()
        app.launchArguments = ["testing"]
        if let path = Bundle(for: type(of: self)).path(forResource: "accounts_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "accounts",
                                     dataToReturn: data))
        }
    }

    override func tearDown() {
        super.tearDown()
        localServer.stop()
    }

    func testWhenUserEntersInvalidStringForGoalTitle_ThenAddGoalButtonIsntEnabled() throws {
        app.launch()

        let savingsGoalTitle = app.otherElements["Savings Goal Title"].textFields.element
        savingsGoalTitle.tap()
        savingsGoalTitle.typeText("")

        let savingsGoalValue = app.otherElements["Savings Goal Value"].textFields.element
        savingsGoalValue.tap()
        savingsGoalValue.typeText("453")

        XCTAssertFalse(app.buttons["Add Goal"].isEnabled)
    }

    func testWhenUserEntersInvalidStringForGoalTitleAndValue_ThenAddGoalButtonIsntEnabled() throws {
        app.launch()

        let savingsGoalTitle = app.otherElements["Savings Goal Title"].textFields.element
        savingsGoalTitle.tap()
        savingsGoalTitle.typeText("")

        let savingsGoalValue = app.otherElements["Savings Goal Value"].textFields.element
        savingsGoalValue.tap()
        savingsGoalValue.typeText("invalid string")

        XCTAssertFalse(app.buttons["Add Goal"].isEnabled)
    }
}
