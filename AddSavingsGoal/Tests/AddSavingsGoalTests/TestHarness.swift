@testable import AddSavingsGoal
import UIKit

class TestHarness {

    let presenter: DefaultPresenter
    let controller: DefaultController
    let view: SpyView
    let router = SpyRouter()
    let accountDataSource = MockAccountDataSource()
    let savingsDataSource = MockSavingsDataSource()
    
    @MainActor
    init() {
        view = SpyView()
        let validateGoalUseCase = ValidateGoalUseCase()

        let addGoalUseCase = AddSavingsGoalUseCase(accountDataSource: accountDataSource, 
                                                   savingsDataSource: savingsDataSource,
                                                   minorUnitsAdapter: MockMinorUnitsAdapter())
        presenter = DefaultPresenter(validateGoalUseCase: validateGoalUseCase, 
                                     addGoalUseCase: addGoalUseCase)
        controller = DefaultController(view: UIViewController(), 
                                       presenter: presenter)
        presenter.set(view)
        controller.set(router)
    }
}

class SpyRouter: Router {
    var didAddSavingsGoalCalled: Int = 0
    func didAddSavingsGoal() {
        didAddSavingsGoalCalled += 1
    }
}

class SpyView: Viewable {
    var addButtonEnabled = false
    func set(_ addButtonEnabled: Bool) {
        self.addButtonEnabled = addButtonEnabled
    }
    
    var keyboardHeight: CGFloat?
    var animationDuration: CGFloat?

    func keyboardShownForHeight(_ height: CGFloat, animationDuration: Double) {
        keyboardHeight = height
        self.animationDuration = animationDuration
    }
    
    func keyboardHiddenForHeight(_ height: CGFloat, animationDuration: Double) {
        keyboardHeight = height
        self.animationDuration = animationDuration
    }
    
    var errorToPresent: Error?
    func present(_ error: Error) {
        errorToPresent = error
    }
}

class MockAccountDataSource: AccountDataSource {
    var shouldThrow: Bool = false
    var account: AddSavingsGoal.Account {
        get async throws {
            if shouldThrow {
                throw DummyError.accountError
            }
            return Account(accountUid: "account_uuid", currency: "GBP")
        }
    }
}

class MockSavingsDataSource: SavingsDataSource {
    var shouldThrow: Bool = false

    func add(with goalName: String, value: Int?, account: AddSavingsGoal.Account) async throws {
        if shouldThrow {
            throw DummyError.savingsError
        }
    }
}

class MockMinorUnitsAdapter: MinorUnitsAdapter {
    func adapt(currency: String, value: Int) -> Decimal {
        return 10.07
    }
}

enum DummyError: Error, LocalizedError {
    case savingsError
    case accountError

    var errorDescription: String? {
        switch self {
            case .savingsError:
                "Savings error"
            case .accountError:
                "Account error"
        }
    }
}
