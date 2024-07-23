import Foundation

struct APIPostStatus: Codable {
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
}
