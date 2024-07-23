import Foundation
import UIKit
import Auth
import Networking

public enum Factory {

    public static func make(amountToRound: Balance, config: Config) -> Controller {
        let repo = Repo()
        let auth = Auth.Factory.make(config: Auth.Config(baseUrl: config.baseUrl))
        let networking = Networking.Factory.make(config: Networking.Config(authTokenRetriever: Task { await auth.authTokenController.token },
                                                                           baseUrl: config.baseUrl))
        let accountDataSource = DefaultAccountDataSource(accountController: auth.accountController)
        let savingsDataSource = DefaultSavingsDataSource(savingsController: networking.savingsNetworkingController)
        let loadUseCase = LoadUseCase(savingsDataSource: savingsDataSource,
                                      accountDataSource: accountDataSource,
                                      repo: repo,
                                      balance: amountToRound)
        let selectedSavingsGoalUseCase = SelectedSavingsGoalUseCase(repo: repo)
        let addRoundUpUseCase = AddRoundUpUseCase(savingsDataSource: savingsDataSource,
                                                  accountDataSource: accountDataSource,
                                                  repo: repo,
                                                  balance: amountToRound, 
                                                  uuidProvider: DefaultUUIDProvider())
        let minorUnitAdapter = DefaultMinorUnitsAdapter()
        let presenter = DefaultPresenter(loadUseCase: loadUseCase,
                                         selectedSavingsGoalsUseCase: selectedSavingsGoalUseCase,
                                         addRoundUpUseCase: addRoundUpUseCase,
                                         minorUnitsAdapter: minorUnitAdapter)
        let viewController = RoundUpViewController(presenter: presenter)
        presenter.set(viewController)

        return DefaultController(view: UINavigationController(rootViewController: viewController), presenter: presenter)
    }
}
