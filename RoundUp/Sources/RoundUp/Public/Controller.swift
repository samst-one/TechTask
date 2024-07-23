import UIKit

public protocol Controller {
    func set(_ router: Router)
    var view: UIViewController { get }
}
