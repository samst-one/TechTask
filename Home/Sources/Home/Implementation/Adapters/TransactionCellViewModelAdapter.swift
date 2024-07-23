import Foundation

enum TransactionCellViewModelAdapter {

    static func adapt(_ transaction: Transaction,
                      minorUnitsAdapter: MinorUnitsAdapter,
                      dateFormatter: DateFormatter) -> TransactionCellViewModel {
        let theme: SpendingCategoryTheme = switch transaction.spendingCategory {
        case .income:
            IncomeSpendingCategoryTheme(transaction: transaction, 
                                        minorUnitsAdapter: minorUnitsAdapter,
                                        dateFormatter: dateFormatter)
        case .payments:
            PaymentsSpendingCategoryTheme(transaction: transaction,
                                          minorUnitsAdapter: minorUnitsAdapter,
                                          dateFormatter: dateFormatter)
         case .savings:
            SavingsSpendingCategoryTheme(transaction: transaction, 
                                         minorUnitsAdapter: minorUnitsAdapter,
                                         dateFormatter: dateFormatter)
        case .unknown:
            UnknownSpendingCategoryTheme(transaction: transaction,
                                         minorUnitsAdapter: minorUnitsAdapter,
                                         dateFormatter: dateFormatter)
        }

        return TransactionCellViewModel(title: transaction.counterPartyName,
                                        price: theme.price,
                                        subtitle: theme.subtitle,
                                        image: theme.spendingCategoryImage,
                                        imageTint: theme.spendingCategoryImageTint,
                                        priceTint: theme.spendingCategoryTextTint)
    }
}
