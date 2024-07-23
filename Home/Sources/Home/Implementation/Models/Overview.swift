import Foundation

struct Overview {
    let accountUid: String
    let defaultCategory: String
    let currency: String
    let name: String
    let transactions: [Transaction]
    let startDate: Date
    let endDate: Date
}
