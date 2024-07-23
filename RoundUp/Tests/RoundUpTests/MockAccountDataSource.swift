@testable import RoundUp

class MockAccountDataSource: AccountDataSource {
    var shouldThrow = false

    var account: RoundUp.Account {
        get async throws {
            if shouldThrow {
                throw DummyError.accountError
            }
            return Account(accountUid: "account_uid",
                           categoryId: "category_id",
                           name: "name",
                           currency: "GBP")
        }
    }
}
