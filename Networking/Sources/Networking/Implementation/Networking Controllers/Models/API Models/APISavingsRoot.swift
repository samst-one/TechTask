import Foundation

struct APISavingsRoot: Codable {
    let savingsGoalList: [APISavingsGoal]

    enum CodingKeys: String, CodingKey {
        case savingsGoalList = "savingsGoalList"
    }
}
