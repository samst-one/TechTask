@testable import Home
import Foundation

class MockTransactionDataSource: TransactionDataSource {

    var shouldThrow: Bool = false
    var returnEmptyArray = false
    var returnOnlyIncome = false

    var startDate: Date?
    var endDate: Date?

    func get(with accountId: String, categoryId: String, startDate: Date, endDate: Date) async throws -> [Home.Transaction] {
        self.startDate = startDate
        self.endDate = endDate
        if shouldThrow {
            throw DummyError.transactionError
        }
        if returnEmptyArray {
            return []
        }
        if returnOnlyIncome {
            return [Transaction(amount: Balance(currency: "gbp", minorUnits: 300),
                               sourceAmount: Balance(currency: "gbp", minorUnits: 300),
                               direction: .inbound,
                               transactionTime: .init(timeIntervalSince1970: 90000),
                               counterPartyName: "counterPartyName",
                               spendingCategory: .income)]
        }
        return [Transaction(amount: Balance(currency: "gbp", minorUnits: 567),
                            sourceAmount: Balance(currency: "gbp", minorUnits: 567),
                            direction: .outbound,
                            transactionTime: .init(timeIntervalSince1970: 1000),
                            counterPartyName: "counterPartyName",
                            spendingCategory: .payments),
                Transaction(amount: Balance(currency: "gbp", minorUnits: 21),
                            sourceAmount: Balance(currency: "gbp", minorUnits: 23),
                            direction: .outbound,
                            transactionTime: .init(timeIntervalSince1970: 1000),
                            counterPartyName: "counterPartyName",
                            spendingCategory: .savings),
                Transaction(amount: Balance(currency: "gbp", minorUnits: 22222),
                            sourceAmount: Balance(currency: "gbp", minorUnits: 22222),
                            direction: .inbound,
                            transactionTime: .init(timeIntervalSince1970: 1000),
                            counterPartyName: "counterPartyName",
                            spendingCategory: .income),
                Transaction(amount: Balance(currency: "gbp", minorUnits: 2435),
                            sourceAmount: Balance(currency: "gbp", minorUnits: 2435),
                            direction: .outbound,
                            transactionTime: .init(timeIntervalSince1970: 1000),
                            counterPartyName: "counterPartyName",
                            spendingCategory: .payments),
                Transaction(amount: Balance(currency: "gbp", minorUnits: 320),
                            sourceAmount: Balance(currency: "gbp", minorUnits: 320),
                            direction: .outbound,
                            transactionTime: .init(timeIntervalSince1970: 1000),
                            counterPartyName: "counterPartyName",
                            spendingCategory: .payments),
                Transaction(amount: Balance(currency: "gbp", minorUnits: 300),
                            sourceAmount: Balance(currency: "gbp", minorUnits: 300),
                            direction: .outbound,
                            transactionTime: .init(timeIntervalSince1970: 1000),
                            counterPartyName: "counterPartyName",
                            spendingCategory: .payments),
                Transaction(amount: Balance(currency: "gbp", minorUnits: 300),
                            sourceAmount: Balance(currency: "gbp", minorUnits: 300),
                            direction: .inbound,
                            transactionTime: .init(timeIntervalSince1970: 90000),
                            counterPartyName: "counterPartyName",
                            spendingCategory: .income),
                Transaction(amount: Balance(currency: "gbp", minorUnits: 200),
                            sourceAmount: Balance(currency: "gbp", minorUnits: 200),
                            direction: .inbound,
                            transactionTime: .init(timeIntervalSince1970: 90000),
                            counterPartyName: "counterPartyName",
                            spendingCategory: .income),
                Transaction(amount: Balance(currency: "gbp", minorUnits: 200),
                            sourceAmount: Balance(currency: "gbp", minorUnits: 200),
                            direction: .unknown,
                            transactionTime: .init(timeIntervalSince1970: 90000),
                            counterPartyName: "counterPartyName",
                            spendingCategory: .unknown),
        ]
    }
}
