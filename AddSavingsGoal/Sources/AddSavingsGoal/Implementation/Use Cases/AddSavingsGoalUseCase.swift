import Foundation

class AddSavingsGoalUseCase {

    private let accountDataSource: AccountDataSource
    private let savingsDataSource: SavingsDataSource
    private let minorUnitsAdapter: MinorUnitsAdapter

    init(accountDataSource: AccountDataSource,
         savingsDataSource: SavingsDataSource,
         minorUnitsAdapter: MinorUnitsAdapter) {
        self.accountDataSource = accountDataSource
        self.savingsDataSource = savingsDataSource
        self.minorUnitsAdapter = minorUnitsAdapter
    }

    func add(goal: String, value: Int?) async throws {
        let account = try await accountDataSource.account
        var minorUnitsValue = value
        if let value = value {
            minorUnitsValue = (minorUnitsAdapter.adapt(currency: account.currency, value: value) as NSDecimalNumber).intValue
        }
        try await savingsDataSource.add(with: goal, value: minorUnitsValue, account: account)
    }
}
