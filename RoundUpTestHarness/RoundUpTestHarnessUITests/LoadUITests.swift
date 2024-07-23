import XCTest
import LocalServer

final class LoadUITests: XCTestCase {

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

    func testWhenViewLoads_AndRequestsSucceed_ThenViewIsShownCorrectly() throws {
        if let path = Bundle(for: type(of: self)).path(forResource: "savings_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/account_uid/savings-goals",
                                     dataToReturn: data))
        }

        app.launch()

        XCTAssertTrue(app.staticTexts["£456.31"].exists)
        XCTAssertTrue(app.staticTexts["£102.74"].exists)
    }

    func testWhenNoSavingsGoalsAreAvailable_ThenZeroStateViewIsShown() {
        if let path = Bundle(for: type(of: self)).path(forResource: "empty_savings", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/account_uid/savings-goals",
                                     dataToReturn: data))
        }

        app.launch()

        XCTAssertTrue(app.staticTexts["Zero State Label"].exists)
    }
}
