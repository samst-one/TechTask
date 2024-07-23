import Foundation

class RoundUpUseCase {

    private let repo: Repo
    private let transactionsDataSource: TransactionDataSource
    private let accountDataSource: AccountDataSource

    init(repo: Repo,
         transactionsDataSource: TransactionDataSource,
         accountDataSource: AccountDataSource) {
        self.repo = repo
        self.transactionsDataSource = transactionsDataSource
        self.accountDataSource = accountDataSource
    }

    func roundUp() async throws -> Balance {
        guard let overview = await repo.currentOverview else {
            throw RoundUpError.failedToRoundUp
        }
        let account = try await accountDataSource.get()
        let transactions = try await transactionsDataSource.get(with: account.accountUid,
                                                                categoryId: account.defaultCategory,
                                                                startDate: overview.startDate,
                                                                endDate: overview.endDate)

        let roundUp: Int = transactions.reduce(into: 0) { partialResult, transaction in
            switch transaction.direction {
                case .inbound, .unknown:
                    break
                case .outbound:
                    if transaction.spendingCategory == .savings {
                        break
                    }
                    let value = transaction.amount.minorUnits
                    partialResult += roundToNearestHundred(value) - value
            }
        }
        return Balance(currency: overview.currency,
                       minorUnits: roundUp)
    }

    private func roundToNearestHundred(_ value: Int) -> Int {
        let remainder = value % 100
        if remainder == 0 {
            return value
        }

        return value + 100 - remainder
    }
}


enum RoundUpError: Error, LocalizedError {
    case failedToRoundUp

    var errorDescription: String? {
        switch self {
            case .failedToRoundUp:
                "Failed to round up transactions."
        }
    }
}
