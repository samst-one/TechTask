class LoadUseCase {

    private let savingsDataSource: SavingsDataSource
    private let accountDataSource: AccountDataSource

    init(savingsDataSource: SavingsDataSource,
         accountDataSource: AccountDataSource) {
        self.savingsDataSource = savingsDataSource
        self.accountDataSource = accountDataSource
    }

    func load() async throws -> [SavingGoal] {
        let accountUuid = try await accountDataSource.accountUuid
        return try await savingsDataSource.get(accountId: accountUuid)
    }
}
