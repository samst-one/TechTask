import Foundation

struct APIFeedItem: Codable {
    let feedItemUid: String
    let categoryUid: String
    let amount: APIBalance
    let sourceAmount: APIBalance
    let direction: APIDirection
    let updatedAt: Date
    let transactionTime: Date
    let settlementTime: Date
    let status: APIStatus
    let transactingApplicationUserUid: String?
    let counterPartyType: String
    let counterPartyUid: String?
    let counterPartyName: String
    let spendingCategory: APISpendingCategory
    let hasAttachment: Bool
    let hasReceipt: Bool
}

struct APIFeedItemRoot: Codable {
    let feedItems: [APIFeedItem]
}

enum APIStatus: String, Codable {
    case settled = "SETTLED"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = .init(rawValue: rawValue) ?? .unknown
    }
}

enum APIDirection: String, Codable {
    case inbound = "IN"
    case outbound = "OUT"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = .init(rawValue: rawValue) ?? .unknown
    }
}

enum APISpendingCategory: String, Codable {
    case income = "INCOME"
    case payments = "PAYMENTS"
    case savings = "SAVING"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = .init(rawValue: rawValue) ?? .unknown
    }
}
