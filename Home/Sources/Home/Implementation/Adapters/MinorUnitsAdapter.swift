import Currency

protocol MinorUnitsAdapter {
    func adapt(_ balance: Balance) -> String
}

struct DefaultMinorUnitsAdapter: MinorUnitsAdapter {
    private let adapter = Currency.Factory.make()

    func adapt(_ balance: Balance) -> String {
        adapter.adapt(currency: balance.currency, minorUnits: balance.minorUnits)
    }
}

