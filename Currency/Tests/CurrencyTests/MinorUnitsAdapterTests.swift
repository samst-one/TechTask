import XCTest
@testable import Currency

final class MinorUnitsAdapterTests: XCTestCase {
    let sut = Factory.make()

    func testMinorUnitsToStringWithGBP() throws {
        XCTAssertEqual("£10.27", sut.adapt(currency: "GBP", minorUnits: 1027))
    }

    func testMinorUnitsToStringWithBHD() throws {
        XCTAssertEqual("BHD 1.027", sut.adapt(currency: "BHD", minorUnits: 1027))
    }

    func testMinorUnitsToStringWithJPY() throws {
        XCTAssertEqual("JP¥1,027", sut.adapt(currency: "JPY", minorUnits: 1027))
    }

    func testMinorUnitsToStringWithInvalidCountryCode() throws {
        let adapter = DefaultMinorUnitsAdapter(formatter: MockFormatter())
        XCTAssertEqual("N/A", adapter.adapt(currency: "abc", minorUnits: 1027))
    }

    func testAdaptionToMinorUnitsWithGBP() {
        XCTAssertEqual(10000, sut.adapt(currency: "GBP", value: 100))
    }

    func testAdaptionToMinorUnitsWithBHD() {
        XCTAssertEqual(100000, sut.adapt(currency: "BHD", value: 100))
    }

    func testAdaptionToMinorUnitsWithJPY() {
        XCTAssertEqual(100, sut.adapt(currency: "JPY", value: 100))
    }
}

class MockFormatter: Currency.Formatter {
    func minimumFractionDigits(for currency: String) -> Int {
        return 2
    }
    
    func string(from number: NSNumber, currency: String) -> String? {
        return nil
    }
}
