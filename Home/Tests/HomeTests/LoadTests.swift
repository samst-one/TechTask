import XCTest
@testable import Home
import UI

final class HomeTests: XCTestCase {

    var sut: TestHarness!

    override func setUp() async throws {
        sut = await TestHarness(selectedDate: Calendar.current.date(byAdding: .day, value: 2, to: .init(timeIntervalSince1970: 0))!,
                                defaultEndDate: Calendar.current.date(byAdding: .day, value: 12, to: .init(timeIntervalSince1970: 0))!)
    }

    func testWhenViewDidLoadIsCalled_AndDatesAreTheSame_ThenCorrectViewStatesArePassedToTheView() async {
        let sut = await TestHarness(selectedDate: Calendar.current.date(byAdding: .day, value: 3, to: .init(timeIntervalSince1970: 0))!,
                              defaultEndDate: Calendar.current.date(byAdding: .day, value: 3, to: .init(timeIntervalSince1970: 0))!)
        await sut.presenter.didLoad()
        let expectedHeaderViewModel = MockedData.headerViewModel(with: "dmy formatted")

        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .loaded(viewModel: HomeViewControllerViewModel(sectionViewModels: MockedData.expectedSectionViewModels(),
                                                                                                   headerViewModel: expectedHeaderViewModel))])
    }

    func testWhenViewDidLoadIsCalled_AndStartDateIsLessThanAWeekPrior_ThenCorrectViewStatesArePassedToTheView() async {
        let sut = await TestHarness(selectedDate: Calendar.current.date(byAdding: .day, value: 3, to: .init(timeIntervalSince1970: 0))!,
                              defaultEndDate: Calendar.current.date(byAdding: .day, value: 6, to: .init(timeIntervalSince1970: 0))!)
        await sut.presenter.didLoad()
        let expectedHeaderViewModel = MockedData.headerViewModel(with: "dmy formatted  →  dmy formatted")

        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .loaded(viewModel: HomeViewControllerViewModel(sectionViewModels: MockedData.expectedSectionViewModels(),
                                                                                                   headerViewModel: expectedHeaderViewModel))])
    }

    func testWhenViewDidLoadIsCalled_AndStartDateIsGreaterThanAWeekPrior_ThenCorrectViewStatesArePassedToTheView() async {
        let sut = await TestHarness(selectedDate: Calendar.current.date(byAdding: .day, value: 3, to: .init(timeIntervalSince1970: 0))!,
                              defaultEndDate: Calendar.current.date(byAdding: .day, value: 12, to: .init(timeIntervalSince1970: 0))!)
        await sut.presenter.didLoad()
        let expectedHeaderViewModel = MockedData.headerViewModel(with: "dmy formatted  →  dmy formatted")
        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .loaded(viewModel: HomeViewControllerViewModel(sectionViewModels: MockedData.expectedSectionViewModels(),
                                                                                                   headerViewModel: expectedHeaderViewModel))])
    }

    func testWhenViewDidLoadIsCalled_AndStartDateIsAfterEndDate_ThenCorrectErrorStateIsPassedToTheView() async {
        let sut = await TestHarness(selectedDate: Calendar.current.date(byAdding: .day, value: 3, to: .init(timeIntervalSince1970: 0))!,
                              defaultEndDate: Calendar.current.date(byAdding: .day, value: 1, to: .init(timeIntervalSince1970: 0))!)
        await sut.presenter.didLoad()

        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .error(error: LoadingError.startDateGreaterThanEnd)])
    }

    func testWhenViewDidLoadIsCalled_AndTransactionDataSourceErrorOccurs_ThenCorrectViewStateIsPassedToTheView() async {
        sut.transactionDataSource.shouldThrow = true
        await sut.presenter.didLoad()
        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                           .error(error: DummyError.transactionError)])
    }

    func testWhenDidLoadIsCalled_AndThereAreNoTransactionsOnSameDay_ThenCorrectZeroStateIsShown() async {
        let sut = await TestHarness(selectedDate: Calendar.current.date(byAdding: .day, value: 2, to: .init(timeIntervalSince1970: 0))!,
                              defaultEndDate: Calendar.current.date(byAdding: .day, value: 2, to: .init(timeIntervalSince1970: 0))!)
        sut.transactionDataSource.returnEmptyArray = true

        await sut.presenter.didLoad()

        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .zeroState(description: "Cannot find any transactions between the selected date range: 3 Jan 1970")])
    }

    func testWhenDidLoadIsCalled_AndThereAreNoTransactionsOnDateRange_ThenCorrectZeroStateIsShown() async {
        let sut = await TestHarness(selectedDate: Calendar.current.date(byAdding: .day, value: 2, to: .init(timeIntervalSince1970: 0))!,
                              defaultEndDate: Calendar.current.date(byAdding: .day, value: 12, to: .init(timeIntervalSince1970: 0))!)
        sut.transactionDataSource.returnEmptyArray = true

        await sut.presenter.didLoad()

        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .zeroState(description: "Cannot find any transactions between the selected date range: 3 Jan 1970  →  10 Jan 1970")])
    }

    func testWhenViewDidLoadIsCalled_AndAccountDataSourceErrorOccurs_ThenCorrectViewStateIsPassedToTheView() async {
        sut.accountDataSource.shouldThrow = true
        await sut.presenter.didLoad()

        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .error(error: DummyError.accountError)])
    }

    func testWhenDidLoadIsCalled_AndThereNoPaymentTransactionsInDateRange_ThenCorrectHeaderViewModelIsPassedToView() async {
        sut.transactionDataSource.returnOnlyIncome = true

        await sut.presenter.didLoad()

        let expectedCells = [TransactionCellViewModel(title: "counterPartyName",
                                                      price: "+Balance",
                                                      subtitle: "hm formatted Income",
                                                      image: "arrow.left.square.fill",
                                                      imageTint: Colours.teal,
                                                      priceTint: Colours.blue)]

        let expectedSections = [Home.TransactionSectionViewModel(date: "dmw formatted",
                                                                 totalAmount: "Balance",
                                                                 cells: expectedCells)]
        
        XCTAssertEqual(sut.view.viewStateSequence, [.loading,
                                                    .loaded(viewModel: HomeViewControllerViewModel(sectionViewModels: expectedSections,
                                                                                                   headerViewModel: MockedData.headerViewModel(with: "dmy formatted  →  dmy formatted",
                                                                                                                                               roundUpButtonIsEnabled: false)))])
    }


}

enum MockedData {

    static func headerViewModel(with dateRange: String, roundUpAmount: String = "(Balance)", roundUpButtonIsEnabled: Bool = true) -> HeaderViewModel {
        return HeaderViewModel(name: "name",
                               availableBalance: "Balance",
                               accountName: "name",
                               dateDetails: dateRange,
                               roundUpAmount: "(Balance)",
                               roundUpButtonIsEnabled: roundUpButtonIsEnabled)
    }


    static func expectedSectionViewModels() -> [TransactionSectionViewModel] {
        [Home.TransactionSectionViewModel(date: "dmw formatted",
                                          totalAmount: "Balance",
                                          cells: [TransactionCellViewModel(title: "counterPartyName",
                                                                           price: "+Balance",
                                                                           subtitle: "hm formatted Income",
                                                                           image: "arrow.left.square.fill",
                                                                           imageTint: Colours.teal,
                                                                           priceTint: Colours.blue),
                                                  TransactionCellViewModel(title: "counterPartyName",
                                                                           price: "+Balance",
                                                                           subtitle: "hm formatted Income",
                                                                           image: "arrow.left.square.fill",
                                                                           imageTint: Colours.teal,
                                                                           priceTint: Colours.blue),
                                                  TransactionCellViewModel(title: "counterPartyName",
                                                                           price: "N/A",
                                                                           subtitle: "hm formatted Unknown",
                                                                           image: "questionmark.square.fill",
                                                                           imageTint: Colours.sand,
                                                                           priceTint: UIColor.red)]),
         Home.TransactionSectionViewModel(date: "dmw formatted",
                                          totalAmount: "Balance",
                                          cells: [TransactionCellViewModel(title: "counterPartyName",
                                                                           price: "Balance",
                                                                           subtitle: "hm formatted Payments",
                                                                           image: "arrow.right.square.fill",
                                                                           imageTint: Colours.orange,
                                                                           priceTint: UIColor.label),
                                                  TransactionCellViewModel(title: "counterPartyName",
                                                                           price: "Balance",
                                                                           subtitle: "hm formatted Savings",
                                                                           image: "arrow.up.square.fill",
                                                                           imageTint: Colours.purple,
                                                                           priceTint: UIColor.label),
                                                  TransactionCellViewModel(title: "counterPartyName",
                                                                           price: "+Balance",
                                                                           subtitle: "hm formatted Income",
                                                                           image: "arrow.left.square.fill",
                                                                           imageTint: Colours.teal,
                                                                           priceTint: Colours.blue),
                                                  TransactionCellViewModel(title: "counterPartyName",
                                                                           price: "Balance",
                                                                           subtitle: "hm formatted Payments",
                                                                           image: "arrow.right.square.fill",
                                                                           imageTint: Colours.orange,
                                                                           priceTint: UIColor.label),
                                                  TransactionCellViewModel(title: "counterPartyName",
                                                                           price: "Balance",
                                                                           subtitle: "hm formatted Payments",
                                                                           image: "arrow.right.square.fill",
                                                                           imageTint: Colours.orange,
                                                                           priceTint: UIColor.label),
                                                  TransactionCellViewModel(title: "counterPartyName",
                                                                           price: "Balance",
                                                                           subtitle: "hm formatted Payments",
                                                                           image: "arrow.right.square.fill",
                                                                           imageTint: Colours.orange,
                                                                           priceTint: UIColor.label)
                                          ]),
        ]
    }

}
