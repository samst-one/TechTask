import UIKit
import Networking
import Auth

public enum Factory {

    public static func make(config: Config) -> Controller {
        let minorUnitsAdapter = DefaultMinorUnitsAdapter()
        let auth = Auth.Factory.make(config: Auth.Config(baseUrl: config.baseUrl))
        let networking = Networking.Factory.make(config: Networking.Config(authTokenRetriever: Task { await auth.authTokenController.token },
                                                                           baseUrl: config.baseUrl))
        let savingsDataSource = DefaultSavingsDataSource(savingsController: networking.savingsNetworkingController)
        let accountDataSource = DefaultAccountDataSource(accountController: auth.accountController)
        let loadUseCase = LoadUseCase(savingsDataSource: savingsDataSource, accountDataSource: accountDataSource)
        let presenter = DefaultPresenter(loadUseCase: loadUseCase, minorUnitsAdapter: minorUnitsAdapter)
        let viewController = SavingsViewController(presenter: presenter)
        presenter.set(viewController)
        
        return DefaultSavingsController(view: UINavigationController(rootViewController: viewController),
                                        presenter: presenter)
    }
    
}
