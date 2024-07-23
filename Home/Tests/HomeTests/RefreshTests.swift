import XCTest
@testable import Home

class RefreshTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness(selectedDate: Calendar.current.date(byAdding: .day, value: 2, to: .init(timeIntervalSince1970: 0))!,
                                defaultEndDate: Calendar.current.date(byAdding: .day, value: 12, to: .init(timeIntervalSince1970: 0))!)
    }

    func testWhenRefreshIsCalledExternally_ThenTransactionsAreFectched() async {
        await sut.controller.refresh()
        let expectedHeaderViewModel = MockedData.headerViewModel(with: "dmy formatted  →  dmy formatted")

        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .loaded(viewModel: HomeViewControllerViewModel(sectionViewModels: MockedData.expectedSectionViewModels(),
                                                                                                   headerViewModel: expectedHeaderViewModel))])
    }

}
