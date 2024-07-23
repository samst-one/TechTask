import UIKit
import Home
import RoundUp

class HomeRouter: Home.Router {

    private let rootViewController: UIViewController
    private let homeController: Home.Controller
    private let baseUrl: String

    init(rootViewController: UIViewController,
         homeController: Home.Controller,
         baseUrl: String) {
        self.rootViewController = rootViewController
        self.homeController = homeController
        self.baseUrl = baseUrl
    }

    func didPressRoundUp(balance: Home.Balance) {
        let roundUp = RoundUp.Factory.make(amountToRound: RoundUp.Balance(currency: balance.currency,
                                                                          minorUnits: balance.minorUnits), 
                                           config: RoundUp.Config(baseUrl: baseUrl))
        let viewController = roundUp.view
        let router = RoundUpRouter(homeController: homeController, roundUpViewController: viewController)
        roundUp.set(router)
        rootViewController.present(viewController, animated: true)
    }
}
