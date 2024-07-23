import Foundation

public protocol TransactionsNetworkingController {
    func get(with accountId: String,
             categoryId: String,
             startDate: Date,
             endDate: Date) async throws -> [FeedItem]
}
