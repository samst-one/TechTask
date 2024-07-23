import Foundation

class AddRoundUpUseCase {

    private let savingsDataSource: SavingsDataSource
    private let accountDataSource: AccountDataSource
    private let repo: Repo
    private let balance: Balance
    private let uuidProvider: UUIDProvider

    init(savingsDataSource: SavingsDataSource,
         accountDataSource: AccountDataSource,
         repo: Repo,
         balance: Balance,
         uuidProvider: UUIDProvider) {
        self.savingsDataSource = savingsDataSource
        self.accountDataSource = accountDataSource
        self.repo = repo
        self.balance = balance
        self.uuidProvider = uuidProvider
    }
    
    func add() async throws {
        guard let selectedSavingsGoal = repo.selectedSavingsGoal else {
            throw AddRoundUpError.noGoalSelected
        }
        let account = try await accountDataSource.account

        try await savingsDataSource.add(balance: balance,
                                        to: selectedSavingsGoal.id,
                                        accountId: account.accountUid,
                                        transferUuid: uuidProvider.uuid)

    }
}

enum AddRoundUpError: Error, LocalizedError {
    case noGoalSelected

    var errorDescription: String? {
        switch self {
            case .noGoalSelected:
                return "No savings goal is selected."
        }
    }

}
