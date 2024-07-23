import Foundation

protocol Presenter {
    func didPressRoundUp() async
    func didLoad() async
    func didSelectDate(date: Date) async
}

class DefaultPresenter: Presenter {

    private let loadUseCase: LoadUseCase
    private weak var view: Viewable?
    private var router: Router?
    private let roundUpUseCase: RoundUpUseCase
    private var selectedDate: Date
    private let minorUnitsAdapter: MinorUnitsAdapter
    private let dateFormatter: DateFormatter

    init(loadUseCase: LoadUseCase,
         selectedDate: Date,
         roundUpUseCase: RoundUpUseCase,
         minorUnitsAdapter: MinorUnitsAdapter,
         dateFormatter: DateFormatter) {
        self.loadUseCase = loadUseCase
        self.selectedDate = selectedDate
        self.roundUpUseCase = roundUpUseCase
        self.minorUnitsAdapter = minorUnitsAdapter
        self.dateFormatter = dateFormatter
    }

    func set(_ view: Viewable) {
        self.view = view
    }

    func set(_ router: Router) {
        self.router = router
    }

    func didPressRoundUp() async {
        do {
            let roundUpAmount = try await roundUpUseCase.roundUp()
            await router?.didPressRoundUp(balance: roundUpAmount)
        } catch let error {
            await view?.didUpdate(.error(error: error))
        }
    }

    func didLoad() async {
        await load()
    }

    func didSelectDate(date: Date) async {
        selectedDate = date
        await load()
    }

    private func load() async {
        await view?.didUpdate(.loading)
        do {
            let overview = try await loadUseCase.load(from: selectedDate)
            if !overview.transactions.isEmpty {
                let roundUpAmount = try await roundUpUseCase.roundUp()
                let sectionViewModels = TransactionSectionViewModelAdapter.adapt(overview, 
                                                                                 minorUnitsAdapter: minorUnitsAdapter,
                                                                                 dateFormatter: dateFormatter)
                await view?.didUpdate(.loaded(viewModel: HomeViewControllerViewModel(sectionViewModels: sectionViewModels,
                                                                                     headerViewModel: HeaderViewModelAdapter.adapt(overview,
                                                                                                                                   roundUpAmount: roundUpAmount,
                                                                                                                                   minorUnitsAdapter: minorUnitsAdapter,
                                                                                                                                   dateFormatter: dateFormatter))))
            } else {
                let zeroStateDescription: String
                if Calendar.current.isDate(overview.startDate, inSameDayAs: overview.endDate) {
                    zeroStateDescription = "\(overview.startDate.formatted(.dateTime.day().month().year()))"
                } else {
                    zeroStateDescription = "\(overview.startDate.formatted(.dateTime.day().month().year()))  →  \(overview.endDate.formatted(.dateTime.day().month().year()))"
                }
                await view?.didUpdate(.zeroState(description: "Cannot find any transactions between the selected date range: \(zeroStateDescription)"))
            }
        } catch let error {
            await view?.didUpdate(.error(error: error))
        }
    }
}
