import Foundation

struct APISavingsGoalBody: Codable {
    let name: String
    let currency: String
    let target: APIBalance
    let base64EncodedPhoto: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case currency = "currency"
        case target = "target"
        case base64EncodedPhoto = "base64EncodedPhoto"
    }
}
