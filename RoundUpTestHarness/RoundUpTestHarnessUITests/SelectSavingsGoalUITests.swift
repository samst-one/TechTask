import XCTest
import LocalServer

final class SelectSavingsGoalUITests: XCTestCase {

    var localServer: LocalServerController!
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        app.launchArguments = ["testing"]
        localServer = LocalServer.Factory.make()
        continueAfterFailure = false
        localServer.start()
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

    func testWhenUserSelectsSavingsGoal_ThenCorrectDataIsDisplayed() throws {
        if let path = Bundle(for: type(of: self)).path(forResource: "savings_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/account_uid/savings-goals",
                                     dataToReturn: data))
        }

        app.launch()

        app.descendants(matching: .any)["Savings Goal View"].tap()
        XCTAssertEqual(app.pickerWheels.otherElements.count, 2)
    }

}
