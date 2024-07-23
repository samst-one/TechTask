@testable import Home
import Foundation

class MockAccountDataSource: AccountDataSource {
    var shouldThrow: Bool = false

    func get() async throws -> Home.Account {
        if shouldThrow {
            throw DummyError.accountError
        }
        return Home.Account(accountUid: "accountUid",
                            defaultCategory: "default-category",
                            currency: "currency",
                            name: "name")
    }
}
