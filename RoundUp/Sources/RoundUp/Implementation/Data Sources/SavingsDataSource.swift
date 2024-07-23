import Networking

protocol SavingsDataSource {
    func get(accountId: String) async throws -> [SavingGoal]
    func add(balance: Balance,
             to savingsGoalUuid: String,
             accountId: String,
             transferUuid: String) async throws
}

class DefaultSavingsDataSource: SavingsDataSource {

    private let savingsController: Networking.SavingsNetworkingController

    init(savingsController: Networking.SavingsNetworkingController) {
        self.savingsController = savingsController
    }

    func get(accountId: String) async throws -> [SavingGoal] {
        let savings = try await savingsController.get(accountId: accountId)

        return savings.map { savingsGoal in
            SavingGoal(id: savingsGoal.savingsGoalUid,
                       name: savingsGoal.name,
                       currency: savingsGoal.totalSaved.currency,
                       target: {
                if let target = savingsGoal.target {
                    return Balance(currency: target.currency, minorUnits: target.minorUnits)
                }
                return nil
            }(),
                       balance: Balance(currency: savingsGoal.totalSaved.currency,
                                        minorUnits: savingsGoal.totalSaved.minorUnits),
                       savedPercentage: savingsGoal.savedPercentage)
        }
    }

    func add(balance: Balance,
             to savingsGoalUuid: String,
             accountId: String,
             transferUuid: String) async throws {
        try await savingsController.add(balance: Networking.Balance(currency: balance.currency,
                                                                    minorUnits: balance.minorUnits),
                                        to: savingsGoalUuid,
                                        accountId: accountId,
                                        transferUuid: transferUuid)
    }
}
