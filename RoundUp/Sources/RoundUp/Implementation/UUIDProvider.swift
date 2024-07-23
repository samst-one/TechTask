import Foundation

protocol UUIDProvider {
    var uuid: String { get }
}

struct DefaultUUIDProvider: UUIDProvider {
    var uuid: String {
        UUID().uuidString
    }
}
