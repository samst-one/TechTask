import Foundation

actor RefreshAccountUseCase {

    private let accountDataSource: AccountDataSource
    private var repo: Repo

    init(accountDataSource: AccountDataSource, repo: Repo) {
        self.accountDataSource = accountDataSource
        self.repo = repo
    }

    func refresh() async throws  {
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
            } else {
                throw AccountError.accountNotFound
            }
        } catch let error {
            throw error
        }
    }
}

