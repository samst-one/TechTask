enum ViewState {
    case roundUpAdded
    case roundUpBeingAdded
    case zeroState
    case loading
    case loaded(viewModel: RoundUpViewControllerViewModel)
    case error(error: Error)
}
