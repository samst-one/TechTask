import XCTest
@testable import Auth

final class RefreshTests: XCTestCase {

    let sut = TestHarness()

    func testWhenAccountDataIsRefreshed_AndDataContainsPrimaryAccount_ThenPrimaryAccountIsStoredInRepo() async throws {
        try await sut.controller.accountController.refresh()

        let account = await sut.repo.getAccount()

        XCTAssertEqual(account, RepoAccount(accountUid: "new_account_uuid",
                                            accountType: .primary,
                                            defaultCategory: "new_default_category",
                                            currency: "new_currency",
                                            name: "new_name"))
    }

    func testWhenAccountDataIsRefreshed_AndDataContainsTwoPrimaryAccounts_ThenFirstPrimaryAccountIsStoredInRepo() async throws {
        sut.accountDataSource.accountsToReturn = [Account(accountUid: "uuid 1",
                                                          accountType: .primary,
                                                          defaultCategory: "default_category 1",
                                                          currency: "currency 1",
                                                          name: "name 1"),
                                                  Account(accountUid: "uuid 2",
                                                          accountType: .primary,
                                                          defaultCategory: "default_category 2",
                                                          currency: "currency 2",
                                                          name: "name 2"),]
        try await sut.controller.accountController.refresh()

        let account = await sut.repo.getAccount()

        XCTAssertEqual(account, RepoAccount(accountUid: "uuid 1",
                                            accountType: .primary,
                                            defaultCategory: "default_category 1",
                                            currency: "currency 1",
                                            name: "name 1"))
    }

    func testWhenAccountDataIsRefreshed_AndDataContainsNoPrimaryAccounts_ThenErrorIsThrown() async throws {
        sut.accountDataSource.accountsToReturn = [Account(accountUid: "uuid 1",
                                                          accountType: .loan,
                                                          defaultCategory: "default_category 1",
                                                          currency: "currency 1",
                                                          name: "name 1"),
                                                  Account(accountUid: "uuid 2",
                                                          accountType: .fixedTermDeposit,
                                                          defaultCategory: "default_category 2",
                                                          currency: "currency 2",
                                                          name: "name 2"),]
        do {
            try await sut.controller.accountController.refresh()
            XCTFail("Expected a throw")
        } catch let error {
            let account = await sut.repo.getAccount()

            XCTAssertNil(account)
            XCTAssertEqual(error as? AccountError, AccountError.accountNotFound)
        }

    }

}
