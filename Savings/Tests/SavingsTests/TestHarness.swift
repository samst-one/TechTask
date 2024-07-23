@testable import Savings
import UIKit

class TestHarness {

    let presenter: DefaultPresenter
    let controller: DefaultSavingsController
    let accountDataSource: MockAccountDataSource
    let savingsDataSource: MockSavingsDataSource
    let view: SpyView
    let router: SpyRouter

    @MainActor
    init() {
        router = SpyRouter()
        view = SpyView()
        accountDataSource = MockAccountDataSource()
        savingsDataSource = MockSavingsDataSource()
        let loadUseCase = LoadUseCase(savingsDataSource: savingsDataSource, accountDataSource: accountDataSource)
        presenter = DefaultPresenter(loadUseCase: loadUseCase, minorUnitsAdapter: MockMinorUnitsAdapter())
        presenter.set(view)
        controller = DefaultSavingsController(view: UIViewController(), presenter: presenter)
        controller.set(router)
    }
}

extension ViewState: Equatable {

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case (.zeroState, .zeroState):
                return true
            case (.loading, .loading):
                return true
            case (.loaded(let lhsViewModel), .loaded(let rhsViewModel)):
                return lhsViewModel == rhsViewModel
            case (.error(let lhsError), .error(let rhsError)):
                if let lhsError = lhsError as? DummyError, let rhsError = rhsError as? DummyError {
                    return lhsError == rhsError
                }
                return false
            default:
                return false
        }
    }
}

extension SavingsViewModel: Equatable {
    public static func == (lhs: SavingsViewModel, rhs: SavingsViewModel) -> Bool {
        lhs.hideProgressBar == rhs.hideProgressBar &&
        lhs.title == rhs.title &&
        lhs.progress == rhs.progress &&
        lhs.subtitle == rhs.subtitle &&
        lhs.totalInAccount == rhs.totalInAccount &&
        lhs.voiceOver == rhs.voiceOver
    }
}

class SpyRouter: Router {
    var didTapAddButtonCalled = 0

    func didTapAddButton() {
        didTapAddButtonCalled += 1
    }
}

class SpyView: Viewable {
    var viewStateSequence: [Savings.ViewState] = []

    func didUpdate(_ viewState: Savings.ViewState) {
        viewStateSequence.append(viewState)
    }
}

class MockMinorUnitsAdapter: MinorUnitsAdapter {
    func adapt(_ balance: Balance) -> String {
        return "adapted"
    }
}

class MockSavingsDataSource: SavingsDataSource {

    var returnEmptyArray = false
    var shouldThrow = false
    var savingsToReturn: [SavingGoal]?
    
    func get(accountId: String) async throws -> [Savings.SavingGoal] {
        if let savingsToReturn = savingsToReturn {
            return savingsToReturn
        }
        if shouldThrow {
            throw DummyError.savingsError
        }
        if returnEmptyArray {
            return []
        }
        return [SavingGoal(id: "id 1",
                           name: "goal 1",
                           currency: "GBP",
                           target: nil,
                           balance: Balance(currency: "GBP",
                                            minorUnits: 4000),
                           savedPercentage: nil),
                SavingGoal(id: "id 2",
                           name: "goal 2",
                           currency: "GBP",
                           target: Balance(currency: "GBP",
                                           minorUnits: 2000),
                           balance: Balance(currency: "GBP",
                                            minorUnits: 4000),
                           savedPercentage: 50)]
    }
}

class MockAccountDataSource: AccountDataSource {
    var shouldThrow = false

    var accountUuid: String {
        get async throws {
            if shouldThrow {
                throw DummyError.accountError
            }
            return "account_uuid"
        }
    }
}

enum DummyError: Error {
    case savingsError
    case accountError
}
