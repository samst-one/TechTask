import Foundation

public protocol MinorUnitsAdapter {
    func adapt(currency: String, minorUnits: Int) -> String
    func adapt(currency: String, value: Int) -> Decimal
}

struct DefaultMinorUnitsAdapter: MinorUnitsAdapter {

    private let formatter: Formatter

    init(formatter: Formatter) {
        self.formatter = formatter
    }

    func adapt(currency: String, minorUnits: Int) -> String {
        return formatter.string(from: Decimal(minorUnits) / pow(10, formatter.minimumFractionDigits(for: currency)) as NSNumber,
                                currency: currency) ?? "N/A"
    }


    func adapt(currency: String, value: Int) -> Decimal {
        return Decimal(value) * pow(10, formatter.minimumFractionDigits(for: currency))
    }
}
