import XCTest
import LocalServer

final class PickDateUITests: XCTestCase {

    let localServer = LocalServer.Factory.make()
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchArguments = ["testing"]
        localServer.start()
    }

    override func tearDown() {
        super.tearDown()
        localServer.stop()
    }

    func testWhenNewDateIsSelected_ThenViewIsUpdated() {
        if let path = Bundle(for: type(of: self)).path(forResource: "accounts_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "accounts",
                                     dataToReturn: data))
        }

        if let path = Bundle(for: type(of: self)).path(forResource: "transaction_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "feed/account/account_uid/category/default_category/transactions-between",
                                     dataToReturn: data))
        }
        app.launch()

        let datePickers = XCUIApplication().datePickers.element

        datePickers.tap()

        while app.buttons["Month"].value as? String != "January 2024" {
            app.buttons["Previous Month"].tap()
        }
        app.datePickers.buttons.element(boundBy: 4).tap()
        app.buttons["PopoverDismissRegion"].tap()

        XCTAssertTrue(app.staticTexts["1 Jan 2024  →  8 Jan 2024"].exists)
    }
}
