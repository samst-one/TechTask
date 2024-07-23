import XCTest
@testable import Networking

final class AccountTests: XCTestCase {

    func testWhenAccountsAreRequested_AndRequestIsSuccessful_ThenAccountsAreReturnedCorrectly() async throws {
        let sut = TestHarness()
        sut.networkingSession.setJsonFilePath(path: "accounts")
        let accounts = try await sut.controller.accountNetworkingController.get()
        XCTAssertEqual(accounts, [Account(accountUid: "51395678-d6ec-430d-9b3c-a887d90289c1",
                                          accountType: .primary,
                                          defaultCategory: "513954fa-e2ad-447e-95fc-8613a5cdce92",
                                          currency: "GBP",
                                          createdAt: "2024-06-28T19:05:02.815Z",
                                          name: "Personal"),
                                  Account(accountUid: "51395678-d6ec-430d-9b3c-a887d90289c1",
                                          accountType: .additional,
                                          defaultCategory: "513954fa-e2ad-447e-95fc-8613a5cdce92",
                                          currency: "GBP",
                                          createdAt: "2024-06-28T19:05:02.815Z",
                                          name: "Personal"),
                                  Account(accountUid: "51395678-d6ec-430d-9b3c-a887d90289c1",
                                          accountType: .loan,
                                          defaultCategory: "513954fa-e2ad-447e-95fc-8613a5cdce92",
                                          currency: "GBP",
                                          createdAt: "2024-06-28T19:05:02.815Z",
                                          name: "Personal"),
                                  Account(accountUid: "51395678-d6ec-430d-9b3c-a887d90289c1",
                                          accountType: .fixedTermDeposit,
                                          defaultCategory: "513954fa-e2ad-447e-95fc-8613a5cdce92",
                                          currency: "GBP",
                                          createdAt: "2024-06-28T19:05:02.815Z",
                                          name: "Personal"),
                                  Account(accountUid: "51395678-d6ec-430d-9b3c-a887d90289c1",
                                          accountType: .unknown,
                                          defaultCategory: "513954fa-e2ad-447e-95fc-8613a5cdce92",
                                          currency: "GBP",
                                          createdAt: "2024-06-28T19:05:02.815Z",
                                          name: "Personal")])

    }

}
