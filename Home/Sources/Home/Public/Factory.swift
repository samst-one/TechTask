import Foundation
import UIKit
import Networking
import Auth

public enum Factory {

    public static func make(config: Config) -> Controller {
        let repo = Repo()
        let minorUnitsAdapter = DefaultMinorUnitsAdapter()
        let auth = Auth.Factory.make(config: Auth.Config(baseUrl: config.baseUrl))
        let networking = Networking.Factory.make(config: Networking.Config(authTokenRetriever: Task { await auth.authTokenController.token },
                                                                           baseUrl: config.baseUrl))
        let accountDataSource = DefaultAccountDataSource(accountController: auth.accountController)
        let transactionsDataSource = DefaultTransactionDataSource(transactionsController: networking.transactionsNetworkingController)
        let loadUseCase = LoadUseCase(accountDataSource: accountDataSource,
                                      transactionsDataSource: transactionsDataSource,
                                      repo: repo,
                                      defaultEndDate: { .now })
        let roundUpUseCase = RoundUpUseCase(repo: repo, transactionsDataSource: transactionsDataSource, accountDataSource: accountDataSource)
        let presenter = DefaultPresenter(loadUseCase: loadUseCase,
                                         selectedDate: Date(),
                                         roundUpUseCase: roundUpUseCase,
                                         minorUnitsAdapter: minorUnitsAdapter,
                                         dateFormatter: DefaultDateFormatter())
        let viewController = HomeViewController(presenter: presenter)
        presenter.set(viewController)
        let navigationViewController = UINavigationController(rootViewController: viewController)

        return DefaultController(presenter: presenter, view: navigationViewController)
    }

}
