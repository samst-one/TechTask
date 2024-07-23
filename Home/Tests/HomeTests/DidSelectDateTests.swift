import XCTest
@testable import Home

class DidSelectDateTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness(selectedDate: Calendar.autoupdatingCurrent.date(byAdding: .day, value: 2, to: .init(timeIntervalSince1970: 0))!,
                                defaultEndDate: Calendar.autoupdatingCurrent.date(byAdding: .day, value: 12, to: .init(timeIntervalSince1970: 0))!)
    }

    func testWhenUserSelectsDate_ThenTransactionsAreFectched() async {
        await sut.presenter.didSelectDate(date: Calendar.current.date(byAdding: .day, value: 1, to: .init(timeIntervalSince1970: 0))!)

        let expectedHeaderViewModel = MockedData.headerViewModel(with: "dmy formatted  →  dmy formatted")

        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .loaded(viewModel: HomeViewControllerViewModel(sectionViewModels: MockedData.expectedSectionViewModels(),
                                                                                                   headerViewModel: expectedHeaderViewModel))])
    }

}
