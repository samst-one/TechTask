import Foundation

enum TransactionSectionViewModelAdapter {

    static func adapt(_ overview: Overview,  minorUnitsAdapter: MinorUnitsAdapter, dateFormatter: DateFormatter) -> [TransactionSectionViewModel] {
        let transactions = overview.transactions
        let groupedTransactions = Dictionary(grouping: transactions, by: { Calendar.current.startOfDay(for: $0.transactionTime) })
        let sortedKeys = groupedTransactions.keys.sorted(by: > )
        let sections = sortedKeys.map { date in
            var cells: [TransactionCellViewModel] = []
            var total: Int = 0
            groupedTransactions[date]?.forEach { transaction in
                cells.append(TransactionCellViewModelAdapter.adapt(transaction,
                                                                   minorUnitsAdapter: minorUnitsAdapter,
                                                                   dateFormatter: dateFormatter))
                switch transaction.direction {
                    case .inbound:
                        total -= transaction.sourceAmount.minorUnits
                    case .outbound:
                        total += transaction.sourceAmount.minorUnits
                    case .unknown:
                        break
                }
            }
            let totalString = minorUnitsAdapter.adapt(Balance(currency: overview.currency, minorUnits: abs(total)))
            let formattedTotalString = "\(total > 0 ? "+" : "")\(totalString)"

            return TransactionSectionViewModel(date: dateFormatter.dayMonthWeekday(date: date),
                                               totalAmount: formattedTotalString, cells: cells)
        }
        return sections
    }

}
