@testable import Home
import Foundation

extension Balance: Equatable {
    public static func == (lhs: Balance, rhs: Balance) -> Bool {
        lhs.minorUnits == rhs.minorUnits &&
        lhs.currency == rhs.currency
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
                if let lhsError = lhsError as? LoadingError, let rhsError = rhsError as? LoadingError {
                    return lhsError == rhsError
                }
                if let lhsError = lhsError as? RoundUpError, let rhsError = rhsError as? RoundUpError {
                    return lhsError == rhsError
                }
                return false
            default:
                return false
        }
    }
}

extension HomeViewControllerViewModel: Equatable {
    public static func == (lhs: HomeViewControllerViewModel, rhs: HomeViewControllerViewModel) -> Bool {
        lhs.headerViewModel == rhs.headerViewModel &&
        lhs.sectionViewModels == rhs.sectionViewModels
    }
}

extension TransactionSectionViewModel: Equatable {
    public static func == (lhs: TransactionSectionViewModel, rhs: TransactionSectionViewModel) -> Bool {
        lhs.cells == rhs.cells &&
        lhs.date == rhs.date &&
        lhs.totalAmount == rhs.totalAmount
    }
}

extension TransactionCellViewModel: Equatable {
    public static func == (lhs: TransactionCellViewModel, rhs: TransactionCellViewModel) -> Bool {
        lhs.image == rhs.image &&
        lhs.imageTint == rhs.imageTint &&
        lhs.price == rhs.price &&
        lhs.priceTint == rhs.priceTint &&
        lhs.subtitle == rhs.subtitle &&
        lhs.title == rhs.title
    }
}

extension HeaderViewModel: Equatable {
    public static func == (lhs: HeaderViewModel, rhs: HeaderViewModel) -> Bool {
        lhs.accountName == rhs.accountName &&
        lhs.availableBalance == rhs.availableBalance &&
        lhs.dateDetails == rhs.dateDetails &&
        lhs.roundUpAmount == rhs.roundUpAmount &&
        lhs.name == rhs.name
    }
}
