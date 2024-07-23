import UIKit
import Home
import RoundUp

class RoundUpRouter: RoundUp.Router {
    private let homeController: Home.Controller
    private weak var roundUpViewController: UIViewController?

    init(homeController: Home.Controller, roundUpViewController: UIViewController) {
        self.homeController = homeController
        self.roundUpViewController = roundUpViewController
    }

    func didRoundUp() {
        roundUpViewController?.dismiss(animated: true,
                                      completion: nil)
        Task {
            await homeController.refresh()
        }
    }
}
