@testable import RoundUp

extension ViewState: Equatable {

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case (.zeroState, .zeroState):
                return true
            case (.loading, .loading):
                return true
            case (.loaded(let lhsViewModel), .loaded(let rhsViewModel)):
                return lhsViewModel == rhsViewModel
            case (.roundUpAdded, .roundUpAdded):
                return true
            case (.roundUpBeingAdded, .roundUpBeingAdded):
                return true
            case (.error(let lhsError), .error(let rhsError)):
                if let lhsError = lhsError as? DummyError,
                    let rhsError = rhsError as? DummyError {
                    return lhsError == rhsError
                }
                if let lhsError = lhsError as? SelectingGoalError,
                    let rhsError = rhsError as? SelectingGoalError {
                    return lhsError == rhsError
                }
                if let lhsError = lhsError as? AddRoundUpError,
                    let rhsError = rhsError as? AddRoundUpError {
                    return lhsError == rhsError
                }
                return false
            default:
                return false
        }
    }
}

extension Balance: Equatable {
    public static func == (lhs: Balance, rhs: Balance) -> Bool {
        lhs.minorUnits == rhs.minorUnits &&
        lhs.currency == rhs.currency
    }
}

extension RoundUpViewControllerViewModel: Equatable {
    public static func == (lhs: RoundUp.RoundUpViewControllerViewModel, rhs: RoundUp.RoundUpViewControllerViewModel) -> Bool {
        lhs.selectedSavingsGoal == rhs.selectedSavingsGoal &&
        lhs.savingsGoals == rhs.savingsGoals &&
        lhs.roundUpOverview == rhs.roundUpOverview
    }
}

extension AccountOverviewViewModel: Equatable {
    public static func == (lhs: AccountOverviewViewModel, rhs: AccountOverviewViewModel) -> Bool {
        lhs.hideProgressBar == rhs.hideProgressBar &&
        lhs.title == rhs.title &&
        lhs.progress == rhs.progress &&
        lhs.subtitle == rhs.subtitle &&
        lhs.totalInAccount == rhs.totalInAccount
    }
}
