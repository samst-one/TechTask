import UIKit
import Home
import Savings
import AddSavingsGoal
import RoundUp
import UI
import Auth
import LocalServer

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let localServer = LocalServer.Factory.make()
    var window: UIWindow?
    let baseUrl = "http://localhost:15411/"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let home = Home.Factory.make(config: Config(baseUrl: baseUrl))
        let savings = Savings.Factory.make(config: Config(baseUrl: baseUrl))

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.tintColor = Colours.navy
        let savingsViewController = savings.view
        let homeViewController = home.view
        
        setupLocalServer()

        let accountController = Auth.Factory.make(config: Auth.Config(baseUrl: baseUrl)).accountController
        let rootViewController = RootViewController()
        Task {
            do {
                try await accountController.refresh()
                let tabBarController = UITabBarController()
                homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
                savingsViewController.tabBarItem = UITabBarItem(title: "Savings Groups", image: UIImage(systemName: "rectangle.3.group"), tag: 1)

                savings.set(SavingsRouter(rootViewController: savingsViewController, savingsController: savings, baseUrl: baseUrl))
                home.set(HomeRouter(rootViewController: homeViewController, homeController: home, 
                                    baseUrl: baseUrl))

                tabBarController.viewControllers = [homeViewController, savingsViewController]

                window.rootViewController = tabBarController
            } catch let error {
                print(error)
                rootViewController.showError()
            }
        }
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    private func setupLocalServer() {
        let accountUuid = "51395678-d6ec-430d-9b3c-a887d90289c1"
        if let path = Bundle(for: type(of: self)).path(forResource: "accounts", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "accounts",
                                     dataToReturn: data))
        }

        if let path = Bundle(for: type(of: self)).path(forResource: "transactions", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "feed/account/\(accountUuid)/category/513954fa-e2ad-447e-95fc-8613a5cdce92/transactions-between",
                                     dataToReturn: data))
        }

        if let path = Bundle(for: type(of: self)).path(forResource: "savings_goals", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/\(accountUuid)/savings-goals",
                                     dataToReturn: data))
        }

        if let path = Bundle(for: type(of: self)).path(forResource: "success", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/\(accountUuid)/savings-goals/51391134-0d1b-4a5c-8a21-c32567744440/add-money/:param",
                                     dataToReturn: data))
        }

        if let path = Bundle(for: type(of: self)).path(forResource: "success", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            localServer.add(EndPoint(path: "account/\(accountUuid)/savings-goal",
                                     dataToReturn: data))
        }

        localServer.start()
    }
}

