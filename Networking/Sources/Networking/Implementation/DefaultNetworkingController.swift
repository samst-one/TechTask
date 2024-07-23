class DefaultNetworkingController: NetworkingController {
    let accountNetworkingController: AccountNetworkingController
    let savingsNetworkingController: SavingsNetworkingController
    let transactionsNetworkingController: TransactionsNetworkingController

    init(accountNetworkingController: AccountNetworkingController, 
         savingsNetworkingController: SavingsNetworkingController,
         transactionsNetworkingController: TransactionsNetworkingController) {
        self.accountNetworkingController = accountNetworkingController
        self.savingsNetworkingController = savingsNetworkingController
        self.transactionsNetworkingController = transactionsNetworkingController
    }
}
