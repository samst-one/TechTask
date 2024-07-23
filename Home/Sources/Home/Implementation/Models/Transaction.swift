import Foundation

struct Transaction {
    let amount: Balance
    let sourceAmount: Balance
    let direction: Direction
    let transactionTime: Date
    let counterPartyName: String
    let spendingCategory: SpendingCategory
}

enum Direction {
    case inbound
    case outbound
    case unknown
}

enum SpendingCategory {
    case income
    case payments
    case savings
    case unknown
}
