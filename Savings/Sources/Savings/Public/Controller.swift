import UIKit

public protocol Controller {
    var view: UIViewController { get }
    func set(_ router: Router)
    func didAddSavings() async
}
