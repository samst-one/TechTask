import UIKit
import AddSavingsGoal
import Auth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let baseUrl = "http://localhost:15411/"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let isTesting =  ProcessInfo.processInfo.arguments.contains("testing")
        let addSavingsGoal = AddSavingsGoal.Factory.make(config: Config(baseUrl: isTesting ? "http://localhost:15411/" : baseUrl))
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let rootVc = UIViewController()
        Task {
            try await Auth.Factory.make(config: Config(baseUrl: isTesting ? "http://localhost:15411/" : baseUrl)).accountController.refresh()
            let addSavingsGoalViewController = addSavingsGoal.view
            addSavingsGoal.set(MockRouter(rootViewController: addSavingsGoalViewController))
            window.rootViewController?.present(addSavingsGoalViewController, animated: true)
        }
        window.rootViewController = rootVc

        window.makeKeyAndVisible()
    }
}

class MockRouter: Router {

    private let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    func didAddSavingsGoal() {
        rootViewController.present(MockViewController(),
                                   animated: true)
    }
}

class MockViewController: UIViewController {

    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemGroupedBackground
        setupLabel()
    }

    private func setupLabel() {
        label.text = "Did Add Savings Goal"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
