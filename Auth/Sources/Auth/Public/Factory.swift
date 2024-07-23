import Networking

public enum Factory {

    public static func make(config: Config) -> AuthController {
        let authTokenController = DefaultAuthTokenController()
        let networking = Networking.Factory.make(config: Networking.Config(authTokenRetriever: Task { await authTokenController.token },
                                                                           baseUrl: config.baseUrl))
        let dataSource = DefaultAccountDataSource(accountController: networking.accountNetworkingController)
        let repo = DefaultRepo()
        let getAccountUseCase = GetAccountUseCase(accountDataSource: dataSource,
                                                  repo: repo)
        let refreshAccountUseCase = RefreshAccountUseCase(accountDataSource: dataSource,
                                                          repo: repo)

        let accountController = DefaultAccountController(accountUseCase: getAccountUseCase,
                                                         refreshAccountUseCase: refreshAccountUseCase)

        return DefaultAuthController(accountController: accountController, authTokenController: authTokenController)
    }

}
