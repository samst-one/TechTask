import Currency
import Foundation

protocol MinorUnitsAdapter {
    func adapt(currency: String, value: Int) -> Decimal
}

struct DefaultMinorUnitsAdapter: MinorUnitsAdapter {
    private let adapter = Currency.Factory.make()

    func adapt(currency: String, value: Int) -> Decimal {
        adapter.adapt(currency: currency, value: value)
    }
}
