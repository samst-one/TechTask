@testable import RoundUp

class MockSavingsDataSource: SavingsDataSource {

    var returnEmptyArray = false
    var shouldThrow = false
    func get(accountId: String) async throws -> [RoundUp.SavingGoal] {
        if shouldThrow {
            throw DummyError.savingsError
        }
        if returnEmptyArray {
            return []
        }
        return [SavingGoal(id: "id 1",
                           name: "goal 1",
                           currency: "GBP",
                           target: nil,
                           balance: Balance(currency: "GBP",
                                            minorUnits: 4000),
                           savedPercentage: nil),
                SavingGoal(id: "id 2",
                           name: "goal 2",
                           currency: "GBP",
                           target: Balance(currency: "GBP",
                                           minorUnits: 2000),
                           balance: Balance(currency: "GBP",
                                            minorUnits: 4000),
                           savedPercentage: 50)]
    }

    var balance: Balance?
    var savingsGoalUuid: String?
    var accountId: String?
    var transferUuid: String?
    var shouldThrowWhilstAdding = false
    
    func add(balance: RoundUp.Balance, to savingsGoalUuid: String, accountId: String, transferUuid: String) async throws {
        self.balance = balance
        self.savingsGoalUuid = savingsGoalUuid
        self.accountId = accountId
        self.transferUuid = transferUuid
        if shouldThrowWhilstAdding {
            throw DummyError.savingsError
        }
    }
}

