import UIKit

class DefaultController: Controller {

    private let presenter: DefaultPresenter
    let view: UIViewController

    init(presenter: DefaultPresenter, view: UIViewController) {
        self.presenter = presenter
        self.view = view
    }

    func set(_ router: Router) {
        presenter.set(router)
    }

    func refresh() async {
        await presenter.didLoad()
    }
}
