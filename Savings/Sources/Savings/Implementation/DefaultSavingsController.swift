import UIKit

class DefaultSavingsController: Controller {
    internal let view: UIViewController
    private let presenter: DefaultPresenter

    init(view: UIViewController, presenter: DefaultPresenter) {
        self.view = view
        self.presenter = presenter
    }

    func set(_ router: Router) {
        presenter.set(router)
    }

    func didAddSavings() async {
        await presenter.didRefresh()
    }
}
