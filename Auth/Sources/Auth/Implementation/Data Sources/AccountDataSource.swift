import Networking

protocol AccountDataSource {
    var account: [Auth.Account]? { get async throws }
}

class DefaultAccountDataSource: AccountDataSource {

    private let accountController: AccountNetworkingController

    init(accountController: AccountNetworkingController) {
        self.accountController = accountController
    }

    var account: [Account]? {
        get async throws {
            do {
                if let accounts = try await accountController.get() {
                    return accounts.map { account in
                        let type: Auth.AccountType = switch account.accountType {
                        case .primary:
                                .primary
                        case .additional:
                                .additional
                        case .fixedTermDeposit:
                                .fixedTermDeposit
                        case .loan:
                                .loan
                        case .unknown:
                                .unknown
                        }
                        return Auth.Account(accountUid: account.accountUid,
                                            accountType: type,
                                            defaultCategory: account.defaultCategory,
                                            currency: account.currency,
                                            name: account.name) }
                }
                return nil
            } catch let error {
                throw error
            }
        }
    }
}
