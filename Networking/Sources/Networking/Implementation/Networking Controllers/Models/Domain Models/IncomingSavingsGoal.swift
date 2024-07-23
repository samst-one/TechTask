import Foundation

public struct IncomingSavingsGoal {

    public let id: String
    public let name: String
    public let currency: String
    public let goal: Int?

    public init(id: String,
                name: String,
                currency: String,
                goal: Int?) {
        self.id = id
        self.name = name
        self.currency = currency
        self.goal = goal
    }
}
