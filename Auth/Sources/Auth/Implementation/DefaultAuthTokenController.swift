struct DefaultAuthTokenController: AuthTokenController {

    var token: String {
        get async {
            "Bearer test_token"
        }
    }
}
