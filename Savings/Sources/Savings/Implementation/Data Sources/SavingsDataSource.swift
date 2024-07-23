import Networking

protocol SavingsDataSource {
    func get(accountId: String) async throws -> [SavingGoal]
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
}
