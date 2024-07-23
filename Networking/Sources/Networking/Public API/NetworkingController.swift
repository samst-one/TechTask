public protocol NetworkingController {
    var savingsNetworkingController: SavingsNetworkingController { get }
    var accountNetworkingController: AccountNetworkingController { get }
    var transactionsNetworkingController: TransactionsNetworkingController { get }
}
