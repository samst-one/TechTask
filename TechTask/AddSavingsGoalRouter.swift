import AddSavingsGoal
import Savings
import UIKit

class AddSavingsGoalRouter: AddSavingsGoal.Router {

    private weak var addSavingsViewController: UIViewController?
    private let savingsController: Savings.Controller

    init(addSavingsViewController: UIViewController,
         savingsController: Savings.Controller) {
        self.addSavingsViewController = addSavingsViewController
        self.savingsController = savingsController
    }

    func didAddSavingsGoal() {
        addSavingsViewController?.dismiss(animated: true)
        Task {
            await savingsController.didAddSavings()
        }
    }

    func didDismiss() {
        addSavingsViewController?.dismiss(animated: true)
    }
}
