import Networking

protocol SavingsDataSource {
    func add(with goalName: String, value: Int?, account: Account) async throws
}

class DefaultSavingsDataSource: SavingsDataSource {

    private let savingsController: SavingsNetworkingController

    init(savingsController: SavingsNetworkingController) {
        self.savingsController = savingsController
    }

    func add(with goalName: String, value: Int?, account: Account) async throws {
        do {
            let savingsGoal = IncomingSavingsGoal(id: goalName,
                                                  name: goalName,
                                                  currency: account.currency,
                                                  goal: value)
            try await savingsController.add(savingsGoal: savingsGoal, accountId: account.accountUid)
        } catch let error {
            throw error
        }
    }
}
