import Foundation

struct APISavingsGoal: Codable {
    let savingsGoalUid: String
    let name: String
    let target: APIBalance?
    let totalSaved: APIBalance
    let savedPercentage: Int?
    let state: APISavingsGoalState

    enum CodingKeys: String, CodingKey {
        case savingsGoalUid = "savingsGoalUid"
        case name = "name"
        case target = "target"
        case totalSaved = "totalSaved"
        case savedPercentage = "savedPercentage"
        case state = "state"
    }
}
