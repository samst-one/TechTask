public enum Factory {

    public static func make() -> MinorUnitsAdapter {
        let formatter = DefaultFormatter()
        return DefaultMinorUnitsAdapter(formatter: formatter)
    }
}
