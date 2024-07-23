import Foundation

enum HeaderViewModelAdapter {

    static func adapt(_ overview: Overview, roundUpAmount: Balance, minorUnitsAdapter: MinorUnitsAdapter, dateFormatter: DateFormatter) -> HeaderViewModel {
        let totalOfAllTransactions: Int = overview.transactions.reduce(into: 0) { totalTransaction, transaction in
            switch transaction.direction {
                case .inbound:
                    totalTransaction += transaction.amount.minorUnits
                case .outbound:
                    totalTransaction -= transaction.amount.minorUnits
                case .unknown:
                    break
            }
        }
        let decimalCurrency = minorUnitsAdapter.adapt(Balance(currency: overview.currency,
                                                              minorUnits: totalOfAllTransactions))
        let dateDetails: String
        if Calendar.current.isDate(overview.startDate, inSameDayAs: overview.endDate) {
            dateDetails = dateFormatter.dayMonthYear(date: overview.startDate)
        } else {
            dateDetails = "\(dateFormatter.dayMonthYear(date: overview.startDate))  →  \(dateFormatter.dayMonthYear(date: overview.endDate))"
        }

        let roundUpAmountString = "(\(minorUnitsAdapter.adapt(roundUpAmount)))"

        return HeaderViewModel(name: overview.name,
                               availableBalance: decimalCurrency,
                               accountName: overview.name,
                               dateDetails: dateDetails,
                               roundUpAmount: roundUpAmountString,
                               roundUpButtonIsEnabled: roundUpAmount.minorUnits != 0)
    }

}
