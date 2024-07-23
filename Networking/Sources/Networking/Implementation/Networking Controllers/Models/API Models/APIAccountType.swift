import Foundation

enum APIAccountType: String, Codable {
    case primary = "PRIMARY"
    case additional = "ADDITIONAL"
    case loan = "LOAN"
    case fixedTermDeposit = "FIXED_TERM_DEPOSIT"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = .init(rawValue: rawValue) ?? .unknown
    }
}
