import Foundation

protocol Formatter {
    func minimumFractionDigits(for currency: String) -> Int
    func string(from number: NSNumber, currency: String) -> String?
}

struct DefaultFormatter: Formatter {
    func string(from number: NSNumber, currency: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = currency.uppercased()

        return currencyFormatter.string(from: number)
    }

    func minimumFractionDigits(for currency: String) -> Int {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = currency.uppercased()

        return currencyFormatter.minimumFractionDigits
    }
}
