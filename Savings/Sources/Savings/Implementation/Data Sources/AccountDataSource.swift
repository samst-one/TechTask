import Auth

protocol AccountDataSource {
    var accountUuid: String { get async throws }
}

class DefaultAccountDataSource: AccountDataSource {

    private let accountController: Auth.AccountController

    init(accountController: Auth.AccountController) {
        self.accountController = accountController
    }

    var accountUuid: String {
        get async throws {
            do {
                let account = try await accountController.get()
                return account.accountUid
            } catch let error {
                throw error
            }
        }
    }

}
