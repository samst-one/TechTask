import XCTest
import LocalServer

final class AddSavingsGroupUITests: XCTestCase {

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

    func testWhenViewLoads_AndUserTapsAddGoal_ThenGoalAddedViewIsPresented() throws {
        if let path = Bundle(for: type(of: self)).path(forResource: "success_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/account_uid/savings-goal",
                                     dataToReturn: data))
        }

        app.launch()

        let savingsGoalTitle = app.otherElements["Savings Goal Title"].textFields.element
        savingsGoalTitle.tap()
        savingsGoalTitle.typeText("UI Test")

        let savingsGoalValue = app.otherElements["Savings Goal Value"].textFields.element
        savingsGoalValue.tap()
        savingsGoalValue.typeText("4356")

        app.buttons["Add Goal"].tap()

        XCTAssertTrue(app.staticTexts["Did Add Savings Goal"].waitForExistence(timeout: 5))
    }
}
