import Foundation

struct APIAccount: Codable {
    let accountUid: String
    let accountType: APIAccountType
    let defaultCategory: String
    let currency: String
    let createdAt: String
    let name: String
}
