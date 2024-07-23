import XCTest
@testable import Networking

final class TransactionsTests: XCTestCase {

    let sut = TestHarness()

    func testWhenSavingsAreRequested_AndRequestIsSuccessful_ThenSavingsAreReturnedCorrectly() async throws {
        sut.networkingSession.setJsonFilePath(path: "transactions")
        let transactions = try await sut.controller.transactionsNetworkingController.get(with: "account_id",
                                                                                         categoryId: "category_id",
                                                                                         startDate: .init(timeIntervalSince1970: 0),
                                                                                         endDate: .init(timeIntervalSince1970: 90000))

        XCTAssertEqual(transactions, [FeedItem(amount: Balance(currency: "GBP", 
                                                               minorUnits: 123456), 
                                               sourceAmount: Balance(currency: "GBP",
                                                                     minorUnits: 123456),
                                               direction: .inbound,
                                               transactionTime: .init(timeIntervalSince1970: 0),
                                               status: .unknown,
                                               counterPartyName: "Tesco",
                                               spendingCategory: .unknown),
                                      FeedItem(amount: Balance(currency: "GBP",
                                                               minorUnits: 123456),
                                               sourceAmount: Balance(currency: "GBP",
                                                                     minorUnits: 123456),
                                               direction: .outbound,
                                               transactionTime: .init(timeIntervalSince1970: 0),
                                               status: .settled,
                                               counterPartyName: "Tesco",
                                               spendingCategory: .income),
                                      FeedItem(amount: Balance(currency: "GBP",
                                                               minorUnits: 123456),
                                               sourceAmount: Balance(currency: "GBP",
                                                                     minorUnits: 123456),
                                               direction: .unknown,
                                               transactionTime: .init(timeIntervalSince1970: 0),
                                               status: .settled,
                                               counterPartyName: "Tesco",
                                               spendingCategory: .savings),
                                      FeedItem(amount: Balance(currency: "GBP",
                                                               minorUnits: 123456),
                                               sourceAmount: Balance(currency: "GBP",
                                                                     minorUnits: 123456),
                                               direction: .unknown,
                                               transactionTime: .init(timeIntervalSince1970: 0),
                                               status: .settled,
                                               counterPartyName: "Tesco",
                                               spendingCategory: .payments)])

    }
}
