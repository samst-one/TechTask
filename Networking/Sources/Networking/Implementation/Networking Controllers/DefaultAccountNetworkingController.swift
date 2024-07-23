import Foundation

class DefaultAccountNetworkingController: AccountNetworkingController {

    private let networkingSession: NetworkingSession
    private let baseUrl: String
    private let authTokenRetriever: Task<String, Never>

    init(baseUrl: String,
         authTokenRetriever: Task<String, Never>,
         networkingSession: NetworkingSession) {
        self.networkingSession = networkingSession
        self.baseUrl = baseUrl
        self.authTokenRetriever = authTokenRetriever
    }

    func get() async throws -> [Account]? {
        let request = try RequestBuilder(baseUrl: baseUrl)
            .addToken(token: await authTokenRetriever.value)
            .addHttpMethod(method: "GET")
            .build()
        let root: APIAccountRoot = try await RequestSender(networkingSession: networkingSession).send(from: request)
        return APIAccountAdapterToAccountAdapter.adapt(root.accounts)
    }
}

enum APIAccountAdapterToAccountAdapter {
    static func adapt(_ accounts: [APIAccount]) -> [Account] {
        return accounts.map { account in
            let type: AccountType = switch account.accountType {
            case .primary:
                    .primary
            case .additional:
                    .additional
            case .fixedTermDeposit:
                    .fixedTermDeposit
            case .loan:
                    .loan
            case .unknown:
                    .unknown
            }
            return Account(accountUid: account.accountUid,
                           accountType: type,
                           defaultCategory: account.defaultCategory,
                           currency: account.currency,
                           createdAt: account.createdAt,
                           name: account.name) }
    }
}
