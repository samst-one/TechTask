import Foundation

enum AccountOverviewViewModelAdapter {

    static func adapt(_ overview: Overview, minorUnitsAdapter: MinorUnitsAdapter) -> AccountOverviewViewModel {
        let total = minorUnitsAdapter.adapt(Balance(currency: overview.roundUpAmount.currency,
                                                              minorUnits: overview.roundUpAmount.minorUnits))

        return AccountOverviewViewModel(title: overview.name, 
                                        subtitle: nil,
                                        progress: 0,
                                        hideProgressBar: true,
                                        totalInAccount: total)
    }

    static func adapt(_ savings: [SavingGoal], minorUnitsAdapter: MinorUnitsAdapter) -> [AccountOverviewViewModel] {
        savings.map { adapt($0, minorUnitsAdapter: minorUnitsAdapter) }
    }

    static func adapt(_ savings: SavingGoal, minorUnitsAdapter: MinorUnitsAdapter) -> AccountOverviewViewModel {
        let total = minorUnitsAdapter.adapt(Balance(currency: savings.currency,
                                                              minorUnits: savings.balance.minorUnits))
        let subtitle: String?
        if let target = savings.target {
            subtitle = "Target: \(minorUnitsAdapter.adapt(Balance(currency: target.currency, minorUnits: target.minorUnits)))"
        } else {
            subtitle = nil
        }
        let percentage: Float
        if let savedPercentage = savings.savedPercentage {
            percentage = Float(savedPercentage) / 100
        } else {
            percentage = 0
        }
        return AccountOverviewViewModel(title: savings.name,
                                        subtitle: subtitle,
                                        progress: percentage,
                                        hideProgressBar: savings.target == nil,
                                        totalInAccount: total)
    }
}
