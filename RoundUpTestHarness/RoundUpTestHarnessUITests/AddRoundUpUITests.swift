import XCTest
import LocalServer

final class AddRoundUpUITests: XCTestCase {

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

    func testWhenViewLoads_AndUserTapsAddRound_ThenRoundUpAddedViewIsPresented() throws {
        if let path = Bundle(for: type(of: self)).path(forResource: "savings_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/account_uid/savings-goals",
                                     dataToReturn: data))
        }
        if let path = Bundle(for: type(of: self)).path(forResource: "success_example", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/account_uid/savings-goals/51391134-0d1b-4a5c-8a21-c32567744440/add-money/:param",
                                     dataToReturn: data))
        }
        app.launch()
        app.buttons["Round Up"].tap()
        if app.alerts["Success"].buttons["Okay"].waitForExistence(timeout: 10) {
            app.alerts["Success"].buttons["Okay"].tap()
            XCTAssertTrue(app.staticTexts["Did Round Up"].waitForExistence(timeout: 5))
        } else {
            XCTFail("Expected success alert")
        }
    }
}
