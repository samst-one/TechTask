struct APIBalanceRoot: Codable {
    let clearedBalance: APIBalance
    let effectiveBalance: APIBalance
    let pendingTransactions: APIBalance
    let acceptedOverdraft: APIBalance
    let amount: APIBalance
    let totalClearedBalance: APIBalance
    let totalEffectiveBalance: APIBalance
}
