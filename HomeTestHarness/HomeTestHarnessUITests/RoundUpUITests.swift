import XCTest
import LocalServer

final class RoundUpUITests: XCTestCase {

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

    func testWhenViewLoads_AndUserTapsRoundUp_ThenRoundUpViewIsPresented() throws {
        if let path = Bundle(for: type(of: self)).path(forResource: "transaction_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "feed/account/account_uid/category/default_category/transactions-between",
                                     dataToReturn: data))
        }

        app.launch()
        app.buttons["Round Up"].tap()
        XCTAssertTrue(app.staticTexts["Balance: 176"].exists)
    }
}
