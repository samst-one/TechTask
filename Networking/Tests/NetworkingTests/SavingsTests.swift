import XCTest
@testable import Networking

final class SavingsTests: XCTestCase {

    let sut = TestHarness()

    func testWhenSavingsAreRequested_AndRequestIsSuccessful_ThenSavingsAreReturnedCorrectly() async throws {
        sut.networkingSession.setJsonFilePath(path: "savings_goals")
        let savings = try await sut.controller.savingsNetworkingController.get(accountId: "account_id")
        XCTAssertEqual(savings, [SavingsGoal(savingsGoalUid: "51391134-0d1b-4a5c-8a21-c32567744440",
                                             name: "A pet",
                                             target: Balance(currency: "GBP",
                                                             minorUnits: 200),
                                             totalSaved: Balance(currency: "GBP",
                                                                 minorUnits: 10274),
                                             savedPercentage: 5137,
                                             state: .active),
                                 SavingsGoal(savingsGoalUid: "51391134-0d1b-4a5c-8a21-c32567744440",
                                             name: "A pet",
                                             target: nil,
                                             totalSaved: Balance(currency: "GBP",
                                                                 minorUnits: 10274),
                                             savedPercentage: nil,
                                             state: .unknown)])

    }

    func testWhenSavingsAreRequested_ThenCorrectUrlIsUsedForTheRequest() async throws {
        sut.networkingSession.setJsonFilePath(path: "savings_goals")
        let _ = try await sut.controller.savingsNetworkingController.get(accountId: "account_id")
        XCTAssertEqual(sut.networkingSession.urlRequest?.url, URL(string: "https://notarealurl.com/account_id/savings-goals"))
    }

    func testWhenAddingASavingsGoalWithTarget_ThenCorrectRequestIsSent() async throws {
        sut.networkingSession.setJsonFilePath(path: "success")

        let savingsGoal = IncomingSavingsGoal(id: "id",
                                              name: "new savings goal",
                                              currency: "GBP",
                                              goal: 300)

        let expectedBody = APISavingsGoalBody(name: "new savings goal", 
                                              currency: "GBP",
                                              target: APIBalance(currency: "GBP",
                                                                 minorUnits: 300),
                                              base64EncodedPhoto: nil)
        try await sut.controller.savingsNetworkingController.add(savingsGoal: savingsGoal,
                                                                 accountId: "acount_id")

        XCTAssertEqual(sut.networkingSession.urlRequest?.url, URL(string: "https://notarealurl.com/acount_id/savings-goal")!)
        XCTAssertEqual(sut.networkingSession.urlRequest?.httpMethod, "PUT")
        XCTAssertEqual(try JSONDecoder().decode(APISavingsGoalBody.self, from: sut.networkingSession.urlRequest!.httpBody!), expectedBody)
    }

    func testWhenAddingASavingsGoalWithoutTarget_ThenCorrectRequestIsSent() async throws {
        sut.networkingSession.setJsonFilePath(path: "success")

        let savingsGoal = IncomingSavingsGoal(id: "id",
                                              name: "new savings goal",
                                              currency: "GBP",
                                              goal: nil)

        let expectedBody = APISavingsGoalBody(name: "new savings goal",
                                              currency: "GBP",
                                              target: APIBalance(currency: "GBP",
                                                                 minorUnits: 0),
                                              base64EncodedPhoto: nil)
        try await sut.controller.savingsNetworkingController.add(savingsGoal: savingsGoal,
                                                                 accountId: "acount_id")

        XCTAssertEqual(sut.networkingSession.urlRequest?.url, URL(string: "https://notarealurl.com/acount_id/savings-goal")!)
        XCTAssertEqual(sut.networkingSession.urlRequest?.httpMethod, "PUT")
        XCTAssertEqual(try JSONDecoder().decode(APISavingsGoalBody.self, from: sut.networkingSession.urlRequest!.httpBody!), expectedBody)
    }

    func testWhenAddingMoneyToAnExistingGoal_ThenCorrectRequestIsSent() async throws {
        sut.networkingSession.setJsonFilePath(path: "success")

        let expectedBody = APIAddToSavingsBody(amount: APIBalance(currency: "GBP", minorUnits: 450))

        try await sut.controller.savingsNetworkingController.add(balance: Balance(currency: "GBP",
                                                                                  minorUnits: 450),
                                                                 to: "savings_goal_uid:",
                                                                 accountId: "acount_id",
                                                                 transferUuid: "transfer_uid")

        XCTAssertEqual(sut.networkingSession.urlRequest?.url, URL(string: "https://notarealurl.com/acount_id/savings-goals/savings_goal_uid:/add-money/transfer_uid")!)
        XCTAssertEqual(sut.networkingSession.urlRequest?.httpMethod, "PUT")
        XCTAssertEqual(try JSONDecoder().decode(APIAddToSavingsBody.self, from: sut.networkingSession.urlRequest!.httpBody!), expectedBody)
    }
}


