import Networking
import Auth
import UIKit

public enum Factory {

    public static func make(config: Config) -> Controller {
        let validateGoalsUseCase = ValidateGoalUseCase()
        let auth = Auth.Factory.make(config: Auth.Config(baseUrl: config.baseUrl))
        let networking = Networking.Factory.make(config: Networking.Config(authTokenRetriever: Task { await auth.authTokenController.token },
                                                                           baseUrl: config.baseUrl))
        let accountDataSource = DefaultAccountDataSource(accountController: auth.accountController)
        let savingsDataSource = DefaultSavingsDataSource(savingsController: networking.savingsNetworkingController)
        let minorUnitsAdapter = DefaultMinorUnitsAdapter()
        let addGoalUseCase = AddSavingsGoalUseCase(accountDataSource: accountDataSource,
                                                   savingsDataSource: savingsDataSource,
                                                   minorUnitsAdapter: minorUnitsAdapter)
        let presenter = DefaultPresenter(validateGoalUseCase: validateGoalsUseCase,
                                         addGoalUseCase: addGoalUseCase)
        let viewController = AddSavingsGoalViewController(presenter: presenter)
        presenter.set(viewController)
        return DefaultController(view: viewController, presenter: presenter)
    }
}
