enum RepoAccountTypeAdapter {

    static func adapt(_ accountType: AccountType) -> RepoAccountType {
        return switch accountType {
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
    }
}
