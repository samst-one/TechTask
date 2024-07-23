import Foundation

public enum Factory {

    public static func make(config: Config) -> NetworkingController {
        let session = DefaultNetworkingSession()
        
        let accountNetworkingController = DefaultAccountNetworkingController(baseUrl: "\(config.baseUrl)accounts",
                                                                             authTokenRetriever: config.authTokenRetriever,
                                                                             networkingSession: session)
        let transactionsNetworkingController = DefaultTransactionsNetworkingController(baseUrl: "\(config.baseUrl)feed",
                                                                                       authTokenRetriever: config.authTokenRetriever,
                                                                                       networkingSession: session)
        let savingsNetworkingController = DefaultSavingsNetworkingController(baseUrl: "\(config.baseUrl)account",
                                                                             authTokenRetriever: config.authTokenRetriever,
                                                                             networkingSession: session)

        return DefaultNetworkingController(accountNetworkingController: accountNetworkingController,
                                           savingsNetworkingController: savingsNetworkingController,
                                           transactionsNetworkingController: transactionsNetworkingController)
    }
}
