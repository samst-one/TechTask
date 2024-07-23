public struct Config {
    let authTokenRetriever: Task<String, Never>
    let baseUrl: String

    public init(authTokenRetriever: Task<String, Never>,
                baseUrl: String = "http://localhost:15411/") {
        self.authTokenRetriever = authTokenRetriever
        self.baseUrl = baseUrl
    }
}
