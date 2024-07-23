import Foundation
public protocol Router {
    @MainActor
    func didPressRoundUp(balance: Balance)
}
