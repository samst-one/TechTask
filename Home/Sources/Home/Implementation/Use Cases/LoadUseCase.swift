import Foundation

enum LoadingError: Error, LocalizedError {

    case startDateGreaterThanEnd

    var errorDescription: String? {
        switch self {
            case .startDateGreaterThanEnd:
                return "Start date cannot be greater than today."
        }
    }
}

class LoadUseCase {

    private let accountDataSource: AccountDataSource
    private let transactionsDataSource: TransactionDataSource
    private let repo: Repo
    private let defaultEndDate: () -> (Date)
    init(accountDataSource: AccountDataSource,
         transactionsDataSource: TransactionDataSource,
         repo: Repo,
         defaultEndDate: @escaping () -> (Date)) {
        self.accountDataSource = accountDataSource
        self.transactionsDataSource = transactionsDataSource
        self.repo = repo
        self.defaultEndDate = defaultEndDate
    }


    func load(from date: Date) async throws -> Overview {
        let account = try await accountDataSource.get()
        let startDate = Calendar.current.startOfDay(for: date)
        var endDate: Date = defaultEndDate()
        if let date = Calendar.current.date(byAdding: .day, value: 7, to: startDate) {
            if date < endDate {
                endDate = date
            }
        }

        if endDate < startDate {
            throw LoadingError.startDateGreaterThanEnd
        }

        let overview = Overview(accountUid: account.accountUid,
                                defaultCategory: account.defaultCategory,
                                currency: account.currency,
                                name: account.name,
                                transactions: try await transactionsDataSource.get(with: account.accountUid,
                                                                                   categoryId: account.defaultCategory,
                                                                                   startDate: startDate,
                                                                                   endDate: endDate),
                                startDate: startDate,
                                endDate: endDate)
        await repo.set(overview)
        return overview
    }
}
