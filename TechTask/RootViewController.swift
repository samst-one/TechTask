import UIKit
import UI

class RootViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var zeroStateView: UIView = {
        let errorMessage = UILabel()
        errorMessage.text = "An error occured loading account information. Please check your auth token."
        errorMessage.numberOfLines = 0
        errorMessage.textAlignment = .center
        errorMessage.sizeToFit()

        let stackView = UIStackView(arrangedSubviews: [errorMessage])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Dimensions.large
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(zeroStateView)

        zeroStateView.isHidden = true

        NSLayoutConstraint.activate([
            zeroStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            zeroStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            zeroStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zeroStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func showError() {
        zeroStateView.isHidden = false
    }

    func hideError() {
        zeroStateView.isHidden = true
    }
}
