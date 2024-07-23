import Foundation

class LoadUseCase {

    private let savingsDataSource: SavingsDataSource
    private let accountDataSource: AccountDataSource
    private let repo: Repo
    private let balance: Balance

    init(savingsDataSource: SavingsDataSource,
         accountDataSource: AccountDataSource,
         repo: Repo,
         balance: Balance) {
        self.savingsDataSource = savingsDataSource
        self.accountDataSource = accountDataSource
        self.repo = repo
        self.balance = balance
    }

    func load() async throws -> Overview {
        let account = try await accountDataSource.account
        let savingsGoals = try await savingsDataSource.get(accountId: account.accountUid)
        repo.savingsGoals = savingsGoals
        repo.selectedSavingsGoal = savingsGoals.first

        let overview = Overview(name: account.name, 
                                roundUpAmount: balance,
                                savingsGoals: savingsGoals)
        return overview
    }
}
