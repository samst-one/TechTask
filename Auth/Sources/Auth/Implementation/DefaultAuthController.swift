class DefaultAuthController: AuthController {

    let accountController: AccountController
    let authTokenController: AuthTokenController

    init(accountController: AccountController, authTokenController: AuthTokenController) {
        self.accountController = accountController
        self.authTokenController = authTokenController
    }
}
