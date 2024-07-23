@testable import Networking
import Foundation

class TestHarness {

    let controller: DefaultNetworkingController
    let networkingSession = MockNetworkingSession()
    let baseUrl = "https://notarealurl.com"
    init() {
        let authRetriever = Task {
            return "Auth"
        }

        let accountNetworkingController = DefaultAccountNetworkingController(baseUrl: baseUrl,
                                                                             authTokenRetriever: authRetriever,
                                                                             networkingSession: networkingSession)
        let savingsNetworkingController = DefaultSavingsNetworkingController(baseUrl: baseUrl,
                                                                             authTokenRetriever: authRetriever,
                                                                             networkingSession: networkingSession)
        let transactionsNetworkingController = DefaultTransactionsNetworkingController(baseUrl: baseUrl,
                                                                                       authTokenRetriever: authRetriever,
                                                                                       networkingSession: networkingSession)
        controller = DefaultNetworkingController(accountNetworkingController: accountNetworkingController,
                                                 savingsNetworkingController: savingsNetworkingController,
                                                 transactionsNetworkingController: transactionsNetworkingController)
    }
}

extension FeedItem: Equatable {
    public static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.amount == rhs.amount &&
        lhs.sourceAmount == rhs.sourceAmount &&
        lhs.counterPartyName == rhs.counterPartyName &&
        lhs.transactionTime == rhs.transactionTime &&
        lhs.direction == rhs.direction &&
        lhs.spendingCategory == rhs.spendingCategory &&
        lhs.status == rhs.status
    }
}

extension APIAddToSavingsBody: Equatable {
    public static func == (lhs: APIAddToSavingsBody, rhs: APIAddToSavingsBody) -> Bool {
        lhs.amount == rhs.amount
    }
}

extension SavingsGoal: Equatable {
    public static func == (lhs: Networking.SavingsGoal, rhs: Networking.SavingsGoal) -> Bool {
        lhs.totalSaved == rhs.totalSaved &&
        lhs.name == rhs.name &&
        lhs.savedPercentage == rhs.savedPercentage &&
        lhs.savingsGoalUid == rhs.savingsGoalUid &&
        lhs.target == rhs.target &&
        lhs.state == rhs.state
    }
}

extension Balance: Equatable {
    public static func == (lhs: Balance, rhs: Balance) -> Bool {
        lhs.minorUnits == rhs.minorUnits &&
        lhs.currency == rhs.currency
    }
}

extension Account: Equatable {
    public static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.accountUid == rhs.accountUid &&
        lhs.currency == rhs.currency &&
        lhs.defaultCategory == rhs.defaultCategory &&
        lhs.name == rhs.name &&
        lhs.accountType == rhs.accountType
    }
}

extension APIBalance: Equatable {
    public static func == (lhs: APIBalance, rhs: APIBalance) -> Bool {
        lhs.currency == rhs.currency &&
        lhs.minorUnits == rhs.minorUnits
    }
}

extension APISavingsGoalBody: Equatable {
    public static func == (lhs: Networking.APISavingsGoalBody, rhs: Networking.APISavingsGoalBody) -> Bool {
        lhs.base64EncodedPhoto == rhs.base64EncodedPhoto &&
        lhs.currency == rhs.currency &&
        lhs.name == rhs.name &&
        lhs.target == rhs.target
    }
}

class MockNetworkingSession: NetworkingSession {
    var dataToReturn: Data?
    var statusToReturn: Int = 200
    func setJsonFilePath(path: String) {
        if let path = Bundle.module.path(forResource: path, ofType: "json") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            dataToReturn = data
        }
    }

    var urlRequest: URLRequest?
    func request(from urlRequest: URLRequest) async throws -> (Data, Int) {
        self.urlRequest = urlRequest
        if let dataToReturn = dataToReturn {
            return (dataToReturn, statusToReturn)
        }
        return (Data(), statusToReturn)
    }
}

enum MockNetworkingSessionError: Error {
    case error
}
