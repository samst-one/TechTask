import Foundation
class DefaultTransactionsNetworkingController: TransactionsNetworkingController {

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

    func get(with accountId: String, categoryId: String, startDate: Date, endDate: Date) async throws -> [FeedItem] {
        let request = try RequestBuilder(baseUrl:baseUrl)
            .addPath(path: "/account/\(accountId)/category/\(categoryId)/transactions-between")
            .addQueryItems(items: [URLQueryItem(name: "minTransactionTimestamp", value: startDate.ISO8601Format()),
                                   URLQueryItem(name: "maxTransactionTimestamp", value: endDate.ISO8601Format())])
            .addToken(token: await authTokenRetriever.value)
            .addHttpMethod(method: "GET")
            .build()
        let root: APIFeedItemRoot = try await RequestSender(networkingSession: networkingSession).send(from: request)
        return APIFeedItemAdapterToFeedItemAdapter.adapt(root)
    }
}

enum APIFeedItemAdapterToFeedItemAdapter {
    static func adapt(_ root: APIFeedItemRoot) -> [FeedItem] {
        return root.feedItems.map { feedItem in
            let direction: Direction = switch feedItem.direction {
            case .inbound:
                    .inbound
            case .outbound:
                    .outbound
            case .unknown:
                    .unknown
            }
            
            let status: Status = switch feedItem.status {
            case .settled:
                    .settled
            case .unknown:
                    .unknown
            }

            let spendingCategory: SpendingCategory = switch feedItem.spendingCategory {
            case .income:
                    .income
            case .payments:
                    .payments
            case .savings:
                    .savings
            case .unknown:
                    .unknown
            }

            return FeedItem(amount: Balance(currency: feedItem.amount.currency,
                                            minorUnits: feedItem.amount.minorUnits),
                            sourceAmount: Balance(currency: feedItem.sourceAmount.currency,
                                                  minorUnits: feedItem.sourceAmount.minorUnits),
                            direction: direction,
                            transactionTime: feedItem.transactionTime,
                            status: status,
                            counterPartyName: feedItem.counterPartyName,
                            spendingCategory: spendingCategory)
        }
    }
}
