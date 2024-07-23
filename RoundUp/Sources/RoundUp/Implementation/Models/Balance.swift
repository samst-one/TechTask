public struct Balance {
    public let currency: String
    public let minorUnits: Int

    public init(currency: String, minorUnits: Int) {
        self.currency = currency
        self.minorUnits = minorUnits
    }
}
