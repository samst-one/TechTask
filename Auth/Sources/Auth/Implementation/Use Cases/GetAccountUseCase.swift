import Foundation

class GetAccountUseCase {

    private let accountDataSource: AccountDataSource
    private var repo: Repo

    init(accountDataSource: AccountDataSource, repo: Repo) {
        self.accountDataSource = accountDataSource
        self.repo = repo
    }

    func get() async throws -> Account {
        if let account = await repo.getAccount() {
            return RepoAccountAdapter.adapt(account)
        }
        do {
            let accounts = try await accountDataSource.account

            if let account = accounts?.first(where: { $0.accountType == .primary }) {
                let accountType: RepoAccountType = RepoAccountTypeAdapter.adapt(account.accountType)
                let account = RepoAccount(accountUid: account.accountUid,
                                          accountType: accountType,
                                          defaultCategory: account.defaultCategory,
                                          currency: account.currency,
                                          name: account.name)
                await repo.set(account)
                return RepoAccountAdapter.adapt(account)
            } else {
                throw AccountError.accountNotFound
            }
        } catch let error {
            throw error
        }
    }
}

public enum AccountError: LocalizedError {
    case accountNotFound

    public var errorDescription: String? {
        switch self {
            case .accountNotFound:
                return "No accounts found."
        }
    }
}
