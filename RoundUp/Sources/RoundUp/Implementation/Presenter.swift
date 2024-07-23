protocol Presenter {
    func didLoad() async
    func didSelectSavingsGoal(at index: Int) async
    func didTapRoundUpButton() async
    func didDissmisSuccessPopup() async
}

class DefaultPresenter: Presenter {

    private var router: Router?
    private let loadUseCase: LoadUseCase
    private let selectedSavingsGoalsUseCase: SelectedSavingsGoalUseCase
    private let addRoundUpUseCase: AddRoundUpUseCase
    private let minorUnitsAdapter: MinorUnitsAdapter
    private weak var view: Viewable?

    init(loadUseCase: LoadUseCase,
         selectedSavingsGoalsUseCase: SelectedSavingsGoalUseCase,
         addRoundUpUseCase: AddRoundUpUseCase,
         minorUnitsAdapter: MinorUnitsAdapter) {
        self.loadUseCase = loadUseCase
        self.selectedSavingsGoalsUseCase = selectedSavingsGoalsUseCase
        self.addRoundUpUseCase = addRoundUpUseCase
        self.minorUnitsAdapter = minorUnitsAdapter
    }

    func set(_ router: Router) {
        self.router = router
    }

    func set(_ view: Viewable) {
        self.view = view
    }

    func didTapRoundUpButton() async {
        await view?.didUpdate(.roundUpBeingAdded)
        do {
            try await addRoundUpUseCase.add()
            await view?.didUpdate(.roundUpAdded)
        } catch let error {
            await view?.didUpdate(.error(error: error))
        }
    }

    func didDissmisSuccessPopup() async {
        await router?.didRoundUp()
    }

    func didSelectSavingsGoal(at index: Int) async {
        do {
            let newSavingsGoal = try selectedSavingsGoalsUseCase.get(at: index)
            let newSavingsGoalViewModel = AccountOverviewViewModelAdapter.adapt(newSavingsGoal, minorUnitsAdapter: minorUnitsAdapter)
            await view?.didUpdate(newSavingsGoalViewModel)
        } catch let error {
            await view?.didUpdate(.error(error: error))
        }
    }

    func didLoad() async {
        await view?.didUpdate(.loading)
        do {
            let overview = try await loadUseCase.load()
            if overview.savingsGoals.isEmpty {
                await view?.didUpdate(.zeroState)
            } else {
                let savingsViewModels = AccountOverviewViewModelAdapter.adapt(overview.savingsGoals, minorUnitsAdapter: minorUnitsAdapter)
                let roundUpOverviewViewModel = AccountOverviewViewModelAdapter.adapt(overview, minorUnitsAdapter: minorUnitsAdapter)

                await view?.didUpdate(.loaded(viewModel: RoundUpViewControllerViewModel(savingsGoals: savingsViewModels,
                                                                                        roundUpOverview: roundUpOverviewViewModel,
                                                                                        selectedSavingsGoal: 0)))
            }
        } catch let error {
            await view?.didUpdate(.error(error: error))
        }
    }
}
