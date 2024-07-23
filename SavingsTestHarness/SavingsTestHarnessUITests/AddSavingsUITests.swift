import XCTest
import LocalServer

final class AddSavingsUITests: XCTestCase {

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

    func testWhenViewLoads_AndUserTapsAddSavings_ThenAddSavingsViewIsPresented() throws {
        if let path = Bundle(for: type(of: self)).path(forResource: "savings_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/account_uid/savings-goal",
                                     dataToReturn: data))
        }

        app.launch()
        app.buttons["add"].tap()
        XCTAssertTrue(app.staticTexts["Add Savings"].exists)
    }
}
