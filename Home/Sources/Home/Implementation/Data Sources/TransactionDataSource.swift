import Networking
import Foundation

protocol TransactionDataSource {
    func get(with accountId: String, categoryId: String, startDate: Date, endDate: Date) async throws -> [Transaction]
}

class DefaultTransactionDataSource: TransactionDataSource {

    private let transactionsController: TransactionsNetworkingController

    init(transactionsController: TransactionsNetworkingController) {
        self.transactionsController = transactionsController
    }
    
    func get(with accountId: String, categoryId: String, startDate: Date, endDate: Date) async throws -> [Transaction] {
        let feedItems = try await transactionsController.get(with: accountId,
                                                             categoryId: categoryId,
                                                             startDate: startDate,
                                                             endDate: endDate) 
        return NetworkingFeedItemAdapterToFeedItemAdapter.adapt(feedItems)
    }
}

enum NetworkingFeedItemAdapterToFeedItemAdapter {
    static func adapt(_ feedItems: [Networking.FeedItem]) -> [Home.Transaction] {
        return feedItems.map { feedItem in
            let direction: Direction = switch feedItem.direction {
            case .inbound:
                    .inbound
            case .outbound:
                    .outbound
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

            return Transaction(amount: Balance(currency: feedItem.amount.currency,
                                               minorUnits: feedItem.amount.minorUnits),
                               sourceAmount: Balance(currency: feedItem.sourceAmount.currency,
                                                     minorUnits: feedItem.sourceAmount.minorUnits),
                               direction: direction,
                               transactionTime: feedItem.transactionTime,
                               counterPartyName: feedItem.counterPartyName,
                               spendingCategory: spendingCategory)
        }
    }
}
