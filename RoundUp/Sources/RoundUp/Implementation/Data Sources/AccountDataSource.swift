import Auth

protocol AccountDataSource {
    var account: Account { get async throws }
}

class DefaultAccountDataSource: AccountDataSource {

    private let accountController: Auth.AccountController

    init(accountController: Auth.AccountController) {
        self.accountController = accountController
    }

    var account: Account {
        get async throws {
            do {
                let account = try await accountController.get()
                return Account(accountUid: account.accountUid,
                               categoryId: account.defaultCategory,
                               name: account.name,
                               currency: account.currency)
            } catch let error {
                throw error
            }
        }
    }
}
