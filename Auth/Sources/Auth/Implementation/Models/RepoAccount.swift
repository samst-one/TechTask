struct RepoAccount: Codable {
    let accountUid: String
    let accountType: RepoAccountType
    let defaultCategory: String
    let currency: String
    let name: String
}
