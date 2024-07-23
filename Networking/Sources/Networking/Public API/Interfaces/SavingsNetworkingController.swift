public protocol SavingsNetworkingController {
    func add(savingsGoal: IncomingSavingsGoal,
             accountId: String) async throws
    func add(balance: Balance,
             to savingsGoalUuid: String,
             accountId: String,
             transferUuid: String) async throws
    func get(accountId: String) async throws -> [SavingsGoal]
}
