public protocol AccountNetworkingController {
    func get() async throws -> [Account]?
}
