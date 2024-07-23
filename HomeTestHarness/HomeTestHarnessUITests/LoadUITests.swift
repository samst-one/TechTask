import XCTest
import LocalServer

final class LoadUITests: XCTestCase {

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

    func testWhenViewLoads_AndRequestsSucceed_ThenViewIsShownCorrectly() throws {
        if let path = Bundle(for: type(of: self)).path(forResource: "transaction_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "feed/account/account_uid/category/default_category/transactions-between",
                                     dataToReturn: data))
        }

        app.launch()

        XCTAssertTrue(app.staticTexts["-£4,938.24"].exists)
        XCTAssertTrue(app.buttons["Round Up"].staticTexts["(£1.76)"].exists)
        XCTAssertEqual(app.cells.count, 6)
    }

    func testWhenNoTransactionsAreAvailable_ThenZeroStateIsShown() {
        if let path = Bundle(for: type(of: self)).path(forResource: "empty_transactions", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "feed/account/account_uid/category/default_category/transactions-between",
                                     dataToReturn: data))
        }

        app.launch()

        XCTAssertTrue(app.staticTexts["Zero State Label"].exists)
    }
}
