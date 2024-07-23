import UIKit
import UI

protocol SpendingCategoryTheme {
    var subtitle: String { get }
    var price: String { get }
    var spendingCategoryImage: String { get }
    var spendingCategoryImageTint: UIColor { get }
    var spendingCategoryTextTint: UIColor { get }
}

struct PaymentsSpendingCategoryTheme: SpendingCategoryTheme {
    var price: String
    var subtitle: String
    var spendingCategoryImage: String
    var spendingCategoryImageTint: UIColor
    var spendingCategoryTextTint: UIColor

    init(transaction: Transaction, minorUnitsAdapter: MinorUnitsAdapter, dateFormatter: DateFormatter) {
        price = minorUnitsAdapter.adapt(transaction.amount)
        spendingCategoryImage = "arrow.right.square.fill"
        spendingCategoryImageTint = UI.Colours.orange
        spendingCategoryTextTint = UIColor.label
        subtitle = "\(dateFormatter.hourMinute(date: transaction.transactionTime)) \("Payments")"
    }
}

struct IncomeSpendingCategoryTheme: SpendingCategoryTheme {
    var price: String
    var subtitle: String
    var spendingCategoryImage: String
    var spendingCategoryImageTint: UIColor
    var spendingCategoryTextTint: UIColor

    init(transaction: Transaction, minorUnitsAdapter: MinorUnitsAdapter, dateFormatter: DateFormatter) {
        price = "+\(minorUnitsAdapter.adapt(transaction.amount))"
        spendingCategoryImage = "arrow.left.square.fill"
        spendingCategoryImageTint = UI.Colours.teal
        spendingCategoryTextTint = UI.Colours.blue
        subtitle = "\(dateFormatter.hourMinute(date: transaction.transactionTime)) \("Income")"
    }
}

struct SavingsSpendingCategoryTheme: SpendingCategoryTheme {
    var price: String
    var subtitle: String
    var spendingCategoryImage: String
    var spendingCategoryImageTint: UIColor
    var spendingCategoryTextTint: UIColor

    init(transaction: Transaction, minorUnitsAdapter: MinorUnitsAdapter, dateFormatter: DateFormatter) {
        price = minorUnitsAdapter.adapt(transaction.amount)
        spendingCategoryImage = "arrow.up.square.fill"
        spendingCategoryImageTint = UI.Colours.purple
        spendingCategoryTextTint = UIColor.label
        subtitle = "\(dateFormatter.hourMinute(date: transaction.transactionTime)) \("Savings")"
    }
}

struct UnknownSpendingCategoryTheme: SpendingCategoryTheme {
    var price: String
    var subtitle: String
    var spendingCategoryImage: String
    var spendingCategoryImageTint: UIColor
    var spendingCategoryTextTint: UIColor

    init(transaction: Transaction, minorUnitsAdapter: MinorUnitsAdapter, dateFormatter: DateFormatter) {
        price = "N/A"
        spendingCategoryImage = "questionmark.square.fill"
        spendingCategoryImageTint = UI.Colours.sand
        spendingCategoryTextTint = UIColor.red
        subtitle = "\(dateFormatter.hourMinute(date: transaction.transactionTime)) \("Unknown")"
    }
}
