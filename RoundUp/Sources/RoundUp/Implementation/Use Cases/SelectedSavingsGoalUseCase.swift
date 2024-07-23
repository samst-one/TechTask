import Foundation
class SelectedSavingsGoalUseCase {

    private let repo: Repo

    init(repo: Repo) {
        self.repo = repo
    }

    func get(at index: Int) throws -> SavingGoal {
        if 0 <= index && index < repo.savingsGoals.count {
            let savingsGoal = repo.savingsGoals[index]
            repo.selectedSavingsGoal = savingsGoal
            return savingsGoal
        } else {
            throw SelectingGoalError.goalOutOfBounds
        }
    }
}

enum SelectingGoalError: Error, LocalizedError {
    case goalOutOfBounds

    var errorDescription: String? {
        switch self {
            case .goalOutOfBounds:
                return "Goal doesn't exist."
        }
    }

}
