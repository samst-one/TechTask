@testable import Home
import UIKit

class TestHarness {

    let presenter: DefaultPresenter
    let view: SpyView
    public let transactionDataSource = MockTransactionDataSource()
    let accountDataSource = MockAccountDataSource()
    let repo = Repo()
    let router = SpyRouter()
    var selectedDate: Date
    var defaultEndDate: Date

    let controller: DefaultController

    @MainActor
    init(selectedDate: Date, defaultEndDate: Date) {
        self.selectedDate = selectedDate
        self.defaultEndDate = defaultEndDate
        let loadUseCase = LoadUseCase(accountDataSource: accountDataSource,
                                      transactionsDataSource: transactionDataSource,
                                      repo: repo,
                                      defaultEndDate: { defaultEndDate })
        let roundUpUseCase = RoundUpUseCase(repo: repo,
                                            transactionsDataSource: transactionDataSource,
                                            accountDataSource: accountDataSource)
        let minorUnitsAdapter = MockMinorUnitsAdapter()
        presenter = DefaultPresenter(loadUseCase: loadUseCase,
                                     selectedDate: selectedDate,
                                     roundUpUseCase: roundUpUseCase,
                                     minorUnitsAdapter: minorUnitsAdapter,
                                     dateFormatter: MockDateFormatter())
        view = SpyView()
        presenter.set(view)

        controller = DefaultController(presenter: presenter, view: UIViewController())
    }
}

class MockDateFormatter: Home.DateFormatter {
    func hourMinute(date: Date) -> String {
        return "hm formatted"
    }
    
    func dayMonthYear(date: Date) -> String {
        return "dmy formatted"
    }
    
    func dayMonthWeekday(date: Date) -> String {
        return "dmw formatted"
    }
}

class SpyRouter: Router {
    var balance: Balance?
    func didPressRoundUp(balance: Home.Balance) {
        self.balance = balance
    }
}

class SpyView: Viewable {
    var viewStateSequence: [Home.ViewState] = []

    func didUpdate(_ viewState: Home.ViewState) {
        viewStateSequence.append(viewState)
    }
}

class MockMinorUnitsAdapter: MinorUnitsAdapter {
    func adapt(_ balance: Home.Balance) -> String {
        return "Balance"
    }
}

enum DummyError: Error, LocalizedError {
    case transactionError
    case accountError

    var errorDescription: String? {
        switch self {
            case .transactionError:
                "Transaction error"
            case .accountError:
                "Account error"
        }
    }
}
