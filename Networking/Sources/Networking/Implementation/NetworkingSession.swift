import Foundation

protocol NetworkingSession {
    func request(from urlRequest: URLRequest) async throws -> (Data, Int)
}

class DefaultNetworkingSession: NetworkingSession {

    func request(from urlRequest: URLRequest) async throws -> (Data, Int) {
        guard let response = try await URLSession.shared.data(for: urlRequest) as? (Data, HTTPURLResponse) else {
            throw NetworkError.errorOccured
        }

        return (response.0, response.1.statusCode)
    }
    
}
