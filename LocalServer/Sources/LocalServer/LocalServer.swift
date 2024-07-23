import Swifter
import Foundation

public enum Factory {

    public static func make() -> LocalServerController {
        return DefaultLocalServerController(server: HttpServer())
    }

}

class DefaultLocalServerController: LocalServerController {

    private let server: HttpServer

    init(server: HttpServer) {
        self.server = server
    }

    func start() {
        try? server.start(15411)
    }

    func stop() {
        server.stop()
    }

    func add(_ endpoint: EndPoint) {
        server[endpoint.path] = { request in
                .ok(.data(endpoint.dataToReturn))
        }
    }
}

public enum HttpMethod {
    case get
    case post
}

public struct EndPoint {
    public let path: String
    public let dataToReturn: Data
    public let method: HttpMethod

    public init(path: String, dataToReturn: Data, method: HttpMethod = .get) {
        self.path = path
        self.dataToReturn = dataToReturn
        self.method = method
    }
}

public protocol LocalServerController {
    func start()
    func stop()
    func add(_ endpoint: EndPoint)
}
