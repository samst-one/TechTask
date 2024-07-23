import UIKit
import AddSavingsGoal
import Savings

class SavingsRouter: Savings.Router {

    private let rootViewController: UIViewController
    private let savingsController: Savings.Controller
    private let baseUrl: String

    init(rootViewController: UIViewController,
         savingsController: Savings.Controller,
         baseUrl: String) {
        self.rootViewController = rootViewController
        self.savingsController = savingsController
        self.baseUrl = baseUrl
    }

    func didTapAddButton() {
        let addSavingsGoal = AddSavingsGoal.Factory.make(config: Config(baseUrl: baseUrl))
        let viewController = addSavingsGoal.view
        addSavingsGoal.set(AddSavingsGoalRouter(addSavingsViewController: viewController,
                                                savingsController: savingsController))
        rootViewController.present(UINavigationController(rootViewController: viewController), animated: true)
    }
}
