import Foundation

protocol Presenter {
    func didUpdateGoal(goal: String?, value: String?) async
    func keyboardWillShow(sizeValue: Any?, durationValue: Any?) async
    func keyboardWillHide(sizeValue: Any?, durationValue: Any?) async
    func keyboardShown()
    func didTapAddGoal(goal: String?, value: String?) async
    func keyboardHidden()
}

class DefaultPresenter: Presenter {
    
    private let validateGoalUseCase: ValidateGoalUseCase
    private let addGoalUseCase: AddSavingsGoalUseCase
    private weak var view: Viewable?
    private var router: Router?
    private var keyboardVisible: Bool = false

    init(validateGoalUseCase: ValidateGoalUseCase,
         addGoalUseCase: AddSavingsGoalUseCase) {
        self.validateGoalUseCase = validateGoalUseCase
        self.addGoalUseCase = addGoalUseCase
    }

    func set(_ view: Viewable) {
        self.view = view
    }

    func set(_ router: Router) {
        self.router = router
    }

    func didUpdateGoal(goal: String?, value: String?) async {
        await view?.set(validateGoalUseCase.validate(goal: goal, value: value))
    }

    func keyboardShown() {
        keyboardVisible = true
    }

    func keyboardHidden() {
        keyboardVisible = false
    }

    func keyboardWillShow(sizeValue: Any?, durationValue: Any?) async {
        if keyboardVisible {
            return
        }
        guard let keyboardSize = sizeValue as? CGRect,
              let animationDuration = durationValue as? Double else {
            return
        }
        let keyboardHeight = keyboardSize.height
        await view?.keyboardShownForHeight(keyboardHeight, animationDuration: animationDuration)
    }
    
    func keyboardWillHide(sizeValue: Any?, durationValue: Any?) async {
        if !keyboardVisible {
            return
        }
        guard let keyboardSize = sizeValue as? CGRect,
              let animationDuration = durationValue as? Double else {
            return
        }
        let keyboardHeight = keyboardSize.height
        await view?.keyboardHiddenForHeight(keyboardHeight, animationDuration: animationDuration)
    }

    func didTapAddGoal(goal: String?, value: String?) async {
        guard let goal = goal else {
            await view?.present(ValidationErrors.validationFailure)
            return
        }
        if validateGoalUseCase.validate(goal: goal, value: value) {
            do {
                try await addGoalUseCase.add(goal: goal, value: Int(value ?? ""))
                await router?.didAddSavingsGoal()
            } catch let error {
                await view?.present(error)
            }
        } else {
            await view?.present(ValidationErrors.validationFailure)
        }
    }

}
