import Foundation

enum SavingsViewModelAdapter {

    static func adapt(_ savings: [SavingGoal], minorUnitsAdapter: MinorUnitsAdapter) -> [SavingsViewModel] {
        savings.map { adapt($0, minorUnitsAdapter: minorUnitsAdapter) }
    }

    static func adapt(_ savings: SavingGoal, minorUnitsAdapter: MinorUnitsAdapter) -> SavingsViewModel {
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
        var voiceOver = "Saving goal for a \(savings.name). Current balance is \(total)."
        if let target = savings.target {
            voiceOver += " Target goal is \(minorUnitsAdapter.adapt(Balance(currency: target.currency, minorUnits: target.minorUnits)))"
        }
        return SavingsViewModel(title: savings.name,
                                subtitle: subtitle,
                                progress: percentage,
                                hideProgressBar: savings.target == nil,
                                totalInAccount: total,
                                voiceOver: voiceOver)
    }
}

