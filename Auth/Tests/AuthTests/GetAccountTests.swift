import XCTest
@testable import Auth

final class GetAccountTests: XCTestCase {

    let sut = TestHarness()

    func testWhenAccountIsStoredInRepo_ThenRepoAccountIsReturned() async throws {
        await sut.repo.set(RepoAccount(accountUid: "account_uuid",
                                       accountType: .primary,
                                       defaultCategory: "default_category",
                                       currency: "gbp",
                                       name: "name"))

        let account = try await sut.controller.accountController.get()
        XCTAssertEqual(account, Account(accountUid: "account_uuid",
                                        accountType: .primary,
                                        defaultCategory: "default_category",
                                        currency: "gbp",
                                        name: "name"))
    }

    func testWhenNoAccountIsStoredInRepo_ThenAccountDataSourceAccountIsReturned() async throws {
        let account = try await sut.controller.accountController.get()
        XCTAssertEqual(account, Account(accountUid: "new_account_uuid",
                                        accountType: .primary,
                                        defaultCategory: "new_default_category",
                                        currency: "new_currency",
                                        name: "new_name"))
    }

    func testWhenNoAccountIsStoredInRepo_AndAccountDataSourceContainsTwoPrimaryAcccounts_ThenFirstIsReturned() async throws {
        sut.accountDataSource.accountsToReturn = [Account(accountUid: "uuid 1",
                                                          accountType: .primary,
                                                          defaultCategory: "default_category 1",
                                                          currency: "currency 1",
                                                          name: "name 1"),
                                                  Account(accountUid: "uuid 2",
                                                          accountType: .primary,
                                                          defaultCategory: "default_category 2",
                                                          currency: "currency 2",
                                                          name: "name 2")]

        let account = try await sut.controller.accountController.get()

        XCTAssertEqual(account, Account(accountUid: "uuid 1",
                                        accountType: .primary,
                                        defaultCategory: "default_category 1",
                                        currency: "currency 1",
                                        name: "name 1"))
    }

    func testWhenNoAccountIsStoredInRepo_AndAccountDataSourceContainsNoPrimaryAcccounts_ThenErrorIsReturned() async throws {
        sut.accountDataSource.accountsToReturn = [Account(accountUid: "uuid 1",
                                                          accountType: .fixedTermDeposit,
                                                          defaultCategory: "default_category 1",
                                                          currency: "currency 1",
                                                          name: "name 1")]
        do {
            let _ = try await sut.controller.accountController.get()
            XCTFail("Expecting error")
        } catch let error {
            XCTAssertEqual(error as? AccountError, .accountNotFound)
        }
    }

    func testWhenNoAccountIsStoredInRepo_AndAccountDataSourceThrows_ThenErrorIsReturned() async throws {
        sut.accountDataSource.shouldThrow = true

        do {
            let _ = try await sut.controller.accountController.get()
            XCTFail("Expecting error")
        } catch let error {
            XCTAssertEqual(error as? DummyError, .accountError)
        }
    }
}
