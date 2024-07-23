import Foundation

protocol Presenter {
    func didLoad() async
    func didTapAddButton() async
    func didRefresh() async
}

class DefaultPresenter: Presenter {

    private var router: Router?
    private let loadUseCase: LoadUseCase
    private weak var view: Viewable?
    private let minorUnitsAdapter: MinorUnitsAdapter

    init(loadUseCase: LoadUseCase,
         minorUnitsAdapter: MinorUnitsAdapter) {
        self.loadUseCase = loadUseCase
        self.minorUnitsAdapter = minorUnitsAdapter
    }

    func set(_ router: Router) {
        self.router = router
    }

    func set(_ view: Viewable) {
        self.view = view
    }

    func didTapAddButton() async {
        await router?.didTapAddButton()
    }

    func didRefresh() async {
        await load()
    }

    func didLoad() async {
        await view?.didUpdate(.loading)
        await load()
    }

    private func load() async {
        do {
            let savingGoals = try await loadUseCase.load()
            if savingGoals.isEmpty {
                await view?.didUpdate(.zeroState)
                return
            }
            let savingsViewModels = SavingsViewModelAdapter.adapt(savingGoals,
                                                                  minorUnitsAdapter: minorUnitsAdapter)
            await view?.didUpdate(.loaded(savings: savingsViewModels))
        } catch let error {
            await view?.didUpdate(.error(error: error))
        }
    }
}
