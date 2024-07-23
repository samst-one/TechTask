import Foundation

struct RequestSender {

    private let networkingSession: NetworkingSession

    init(networkingSession: NetworkingSession) {
        self.networkingSession = networkingSession
    }

    func send<T: Codable>(from urlRequest: URLRequest) async throws -> T {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        do {
            let (json, statusCode) = try await networkingSession.request(from: urlRequest)
            switch statusCode {
                case 200:
                    return try jsonDecoder.decode(T.self, from: json)
                case 401:
                    throw NetworkError.unauthorized
                case 403:
                    throw NetworkError.invalidAuth
                default:
                    throw NetworkError.errorOccured
            }
        } catch let error {
            throw error
        }
    }
}
