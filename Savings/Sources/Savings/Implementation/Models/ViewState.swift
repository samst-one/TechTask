enum ViewState {
    case zeroState
    case loading
    case loaded(savings: [SavingsViewModel])
    case error(error: Error)
}
