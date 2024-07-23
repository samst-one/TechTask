import Foundation

enum ValidationErrors: LocalizedError {
    case validationFailure

    var errorDescription: String? {
        switch self {
            case .validationFailure:
                return "Please fill in the fields above."
        }
    }
}

class ValidateGoalUseCase {

    func validate(goal: String?, value: String?) -> Bool {
        guard let goal = goal else {
            return false
        }
        if goal.isEmpty {
            return false
        }
        if let value = value {
            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: value)) {
                return true
            } else {
                return false
            }
        }
        return true
    }

}
