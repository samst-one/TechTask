import Foundation

class RequestBuilder {
    private var urlRequest: URLRequest

    init(baseUrl: String) throws {
        guard let url = URL(string: baseUrl) else {
            throw NetworkError.malformedUrl
        }
        urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
    }

    func addQueryItems(items: [URLQueryItem]) throws -> Self {
        var components = URLComponents(string: urlRequest.url?.absoluteString ?? "")
        components?.queryItems = items
        urlRequest.url = components?.url
        return self
    }

    func addPath(path: String) -> RequestBuilder {
        urlRequest.url?.append(path: path)
        return self
    }

    func addToken(token: String) throws -> RequestBuilder {
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        return self
    }

    func addBody(body: Codable) -> RequestBuilder {
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        return self
    }

    func addHttpMethod(method: String) -> RequestBuilder {
        urlRequest.httpMethod = method
        return self
    }

    func build() -> URLRequest {
        return urlRequest
    }
}
