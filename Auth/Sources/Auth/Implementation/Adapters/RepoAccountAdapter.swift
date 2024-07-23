import Foundation

enum RepoAccountAdapter {
    static func adapt(_ account: RepoAccount) -> Account {
        let accountType: AccountType = switch account.accountType {
        case .additional:
                .additional
        case .fixedTermDeposit:
                .fixedTermDeposit
        case .loan:
                .loan
        case .primary:
                .primary
        case .unknown:
                .unknown
        }
        return Account(accountUid: account.accountUid,
                       accountType: accountType,
                       defaultCategory: account.defaultCategory,
                       currency: account.currency,
                       name: account.name)
    }
}
