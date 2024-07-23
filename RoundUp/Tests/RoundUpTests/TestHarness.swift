@testable import RoundUp
import UIKit

class TestHarness {


    let presenter: DefaultPresenter
    let controller: DefaultController
    let savingsDataSource: MockSavingsDataSource
    let accountDataSource: MockAccountDataSource
    let view: SpyView
    let router: SpyRouter

    @MainActor
    init() {
        view = SpyView()
        let balance = Balance(currency: "GBP",
                              minorUnits: 4500)
        savingsDataSource = MockSavingsDataSource()
        accountDataSource = MockAccountDataSource()
        let repo = Repo()
        let loadUseCase = LoadUseCase(savingsDataSource: savingsDataSource,
                                      accountDataSource: accountDataSource,
                                      repo: repo,
                                      balance: balance)
        let selectSavingsGoalUseCase = SelectedSavingsGoalUseCase(repo: repo)
        let addRoundUpUseCase = AddRoundUpUseCase(savingsDataSource: savingsDataSource,
                                                  accountDataSource: accountDataSource,
                                                  repo: repo,
                                                  balance: balance,
                                                  uuidProvider: MockUUIDProvider())
        presenter = DefaultPresenter(loadUseCase: loadUseCase,
                                     selectedSavingsGoalsUseCase: selectSavingsGoalUseCase,
                                     addRoundUpUseCase: addRoundUpUseCase,
                                     minorUnitsAdapter: MockMinorUnitsAdapter())
        presenter.set(view)
        router = SpyRouter()
        controller = DefaultController(view: UIViewController(),
                                       presenter: presenter)
        controller.set(router)
    }
}

class SpyRouter: Router {
    var didRoundUpCalledCount = 0
    func didRoundUp() {
        didRoundUpCalledCount += 1
    }
    
    func didDismiss() {

    }
}

class SpyView: Viewable {
    
    var viewStateSequence: [ViewState] = []
    
    func didUpdate(_ viewState: RoundUp.ViewState) {
        viewStateSequence.append(viewState)
    }

    var selectedSavingsGoal: AccountOverviewViewModel?
    func didUpdate(_ savingsGoal: RoundUp.AccountOverviewViewModel) {
        selectedSavingsGoal = savingsGoal
    }
}

class MockMinorUnitsAdapter: RoundUp.MinorUnitsAdapter {
    func adapt(_ balance: RoundUp.Balance) -> String {
        return "Adapter hit"
    }
}

class MockUUIDProvider: UUIDProvider {
    var uuid: String {
        "uuid_provided"
    }
}

enum DummyError: Error, LocalizedError, Equatable {
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
