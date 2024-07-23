class DefaultAccountController: AccountController {
    private let accountUseCase: GetAccountUseCase
    private let refreshAccountUseCase: RefreshAccountUseCase

    init(accountUseCase: GetAccountUseCase,
         refreshAccountUseCase: RefreshAccountUseCase) {
        self.accountUseCase = accountUseCase
        self.refreshAccountUseCase = refreshAccountUseCase
    }

    func get() async throws -> Account {
        try await accountUseCase.get()
    }

    func refresh() async throws {
        try await refreshAccountUseCase.refresh()
    }
}
