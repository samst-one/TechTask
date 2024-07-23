import XCTest
@testable import Networking

class RequestSenderTests: XCTestCase {
    let networkSession = MockNetworkingSession()

    func testWhenStatusIs401_ThenCorrectErrorIsThrown() async {
        networkSession.statusToReturn = 401
        do {
            let _: String = try await RequestSender(networkingSession: networkSession).send(from: URLRequest(url: URL(string: "http://invalid.com")!))
            XCTFail("Expected error")
        } catch let error {
            XCTAssertEqual(error as! NetworkError, .unauthorized)
        }
    }

    func testWhenStatusIs403_ThenCorrectErrorIsThrown() async {
        networkSession.statusToReturn = 403
        do {
            let _: String = try await RequestSender(networkingSession: networkSession).send(from: URLRequest(url: URL(string: "http://invalid.com")!))
            XCTFail("Expected error")
        } catch let error {
            XCTAssertEqual(error as! NetworkError, .invalidAuth)
        }
    }

    func testWhenStatusIsUnknown_ThenCorrectErrorIsThrown() async {
        networkSession.statusToReturn = 600
        do {
            let _: String = try await RequestSender(networkingSession: networkSession).send(from: URLRequest(url: URL(string: "http://invalid.com")!))
            XCTFail("Expected error")
        } catch let error {
            XCTAssertEqual(error as! NetworkError, .errorOccured)
        }
    }
}
