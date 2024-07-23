import Auth

protocol AccountDataSource {
    func get() async throws -> Home.Account
}

class DefaultAccountDataSource: AccountDataSource {

    private let accountController: Auth.AccountController

    init(accountController: Auth.AccountController) {
        self.accountController = accountController
    }

    func get() async throws -> Home.Account {
        do {
            let account = try await accountController.get()
            return Home.Account(accountUid: account.accountUid,
                                defaultCategory: account.defaultCategory,
                                currency: account.currency,
                                name: account.name)
        } catch let error {
            throw error
        }
    }
}
