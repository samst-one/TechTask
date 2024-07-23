import Foundation

protocol Repo: AnyActor {
    func getAccount() async -> RepoAccount?
    func set(_ account: RepoAccount) async
}

actor DefaultRepo: Repo {
    private let defaults = UserDefaults.standard

    func getAccount() async -> RepoAccount? {
        if let savedAccount = defaults.object(forKey: "Account") as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(RepoAccount.self, from: savedAccount)
        }
        return nil
    }

    func set(_ account: RepoAccount) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(account) {
            defaults.set(encoded, forKey: "Account")
        }
    }
}
