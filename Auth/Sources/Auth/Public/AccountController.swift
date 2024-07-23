public protocol AccountController {
    func get() async throws -> Account
    func refresh() async throws
}
