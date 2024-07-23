@testable import Auth
import Foundation

class TestHarness {

    let controller: DefaultAuthController
    let accountDataSource = MockAccountDataSource()
    let repo = SpyRepo()

    init() {
        let getAccountUseCase = GetAccountUseCase(accountDataSource: accountDataSource, repo: repo)
        let refreshAccountUseCase = RefreshAccountUseCase(accountDataSource: accountDataSource, repo: repo)
        let accountController = DefaultAccountController(accountUseCase: getAccountUseCase, refreshAccountUseCase: refreshAccountUseCase)
        let authTokenController = MockAuthTokenController()
        
        self.controller = DefaultAuthController(accountController: accountController, authTokenController: authTokenController)
    }

}

class MockAuthTokenController: AuthTokenController {
    var token: String {
        return "token"
    }
}

enum DummyError: Error, Equatable {
    case accountError
}

class MockAccountDataSource: AccountDataSource {
    var accountsToReturn: [Account]?
    var shouldThrow = false
    var account: [Account]? {
        get async throws {
            if shouldThrow {
                throw DummyError.accountError
            }
            if accountsToReturn != nil {
                return accountsToReturn
            }
            return [Account(accountUid: "new_account_uuid",
                            accountType: .primary,
                            defaultCategory: "new_default_category",
                            currency: "new_currency",
                            name: "new_name")]
        }
    }
}

actor SpyRepo: Repo {
    var account: Auth.RepoAccount?

    func getAccount() async -> Auth.RepoAccount? {
        account
    }
    
    func set(_ account: Auth.RepoAccount) async {
        self.account = account
    }
}

extension Account: Equatable {
    public static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.accountUid == rhs.accountUid &&
        lhs.currency == rhs.currency &&
        lhs.defaultCategory == rhs.defaultCategory &&
        lhs.name == rhs.name &&
        lhs.accountType == rhs.accountType
    }
}

extension RepoAccount: Equatable {
    public static func == (lhs: RepoAccount, rhs: RepoAccount) -> Bool {
        lhs.accountUid == rhs.accountUid &&
        lhs.currency == rhs.currency &&
        lhs.defaultCategory == rhs.defaultCategory &&
        lhs.name == rhs.name &&
        lhs.accountType == rhs.accountType
    }
}
