import Foundation

public struct FeedItem {
    public let amount: Balance
    public let sourceAmount: Balance
    public let direction: Direction
    public let transactionTime: Date
    public let status: Status
    public let counterPartyName: String
    public let spendingCategory: SpendingCategory
}

public enum Status {
    case settled
    case unknown
}

public enum Direction {
    case inbound
    case outbound
    case unknown
}

public enum SpendingCategory {
    case income
    case payments
    case savings
    case unknown
}
