import UIKit

class DefaultController: Controller {
    let view: UIViewController
    private let presenter: DefaultPresenter

    init(view: UIViewController, presenter: DefaultPresenter) {
        self.view = view
        self.presenter = presenter
    }

    func set(_ router: Router) {
        presenter.set(router)
    }
}
