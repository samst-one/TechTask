import Foundation

struct Transaction {
    let amount: Balance
    let sourceAmount: Balance
    let direction: Direction
}

enum Direction {
    case inbound
    case outbound
}
