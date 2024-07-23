import Foundation

class DefaultSavingsNetworkingController: SavingsNetworkingController {

    private let networkingSession: NetworkingSession
    private let baseUrl: String
    private let authTokenRetriever: Task<String, Never>

    init(baseUrl: String,
         authTokenRetriever: Task<String, Never>,
         networkingSession: NetworkingSession) {
        self.networkingSession = networkingSession
        self.baseUrl = baseUrl
        self.authTokenRetriever = authTokenRetriever
    }

    func add(balance: Balance,
             to savingsGoalUuid: String,
             accountId: String,
             transferUuid: String) async throws {
        let request = try RequestBuilder(baseUrl: baseUrl)
            .addPath(path: "/\(accountId)/savings-goals/\(savingsGoalUuid)/add-money/\(transferUuid)")
            .addToken(token: await authTokenRetriever.value)
            .addBody(body: APIAddToSavingsBody(amount: APIBalance(currency: balance.currency,
                                                                  minorUnits: balance.minorUnits)))
            .addHttpMethod(method: "PUT")
            .build()
        let _: APIPostStatus = try await RequestSender(networkingSession: networkingSession).send(from: request)
    }

    func add(savingsGoal: IncomingSavingsGoal, accountId: String) async throws {
        let request = try RequestBuilder(baseUrl: baseUrl)
            .addPath(path: "/\(accountId)/savings-goal")
            .addToken(token: await authTokenRetriever.value)
            .addBody(body: APISavingsGoalBody(name: savingsGoal.name,
                                              currency: savingsGoal.currency,
                                              target: APIBalance(currency: savingsGoal.currency,
                                                                 minorUnits: savingsGoal.goal ?? 0),
                                              base64EncodedPhoto: nil))
            .addHttpMethod(method: "PUT")
            .build()
        let _: APIPostStatus = try await RequestSender(networkingSession: networkingSession).send(from: request)
    }

    func get(accountId: String) async throws -> [SavingsGoal] {
        let request = try RequestBuilder(baseUrl: baseUrl)
            .addPath(path: "/\(accountId)/savings-goals")
            .addToken(token: await authTokenRetriever.value)
            .addHttpMethod(method: "GET")
            .build()
        let root: APISavingsRoot = try await RequestSender(networkingSession: networkingSession).send(from: request)
        return APISavingsGoalAdapterToSavingsGoalAdapter.adapt(root.savingsGoalList)
    }
}

enum APISavingsGoalAdapterToSavingsGoalAdapter {

    static func adapt(_ savings: [APISavingsGoal]) -> [SavingsGoal] {
        return savings.map { savings in
            let target: Balance?
            if let apiTarget = savings.target {
                target = Balance(currency: apiTarget.currency,
                                 minorUnits: apiTarget.minorUnits)
            } else {
                target = nil
            }

            return SavingsGoal(savingsGoalUid: savings.savingsGoalUid,
                               name: savings.name,
                               target: target,
                               totalSaved: Balance(currency: savings.totalSaved.currency,
                                                   minorUnits: savings.totalSaved.minorUnits),
                               savedPercentage: savings.savedPercentage,
                               state: savings.state == .active ? .active : .unknown)
        }
    }
}
