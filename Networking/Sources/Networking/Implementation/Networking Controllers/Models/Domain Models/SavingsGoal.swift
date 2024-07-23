import Foundation

public struct SavingsGoal {
    public let savingsGoalUid: String
    public let name: String
    public let target: Balance?
    public let totalSaved: Balance
    public let savedPercentage: Int?
    public let state: SavingsGoalState
}
