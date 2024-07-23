struct HomeViewControllerViewModel {
    let sectionViewModels: [TransactionSectionViewModel]
    let headerViewModel: HeaderViewModel
}

enum ViewState {
    case zeroState(description: String)
    case loading
    case loaded(viewModel: HomeViewControllerViewModel)
    case error(error: Error)
}
