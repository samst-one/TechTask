import UIKit
import UI

@MainActor
protocol Viewable: AnyObject {
    func didUpdate(_ viewState: ViewState)
}

class SavingsViewController: UIViewController {

    private let presenter: Presenter
    private let collectionView: UICollectionView
    private let collectionViewLayout: UICollectionViewFlowLayout
    private let zeroStateLabel = UILabel()
    private var savings: [SavingsViewModel] = []
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(presenter: Presenter) {
        self.presenter = presenter
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Savings Groups"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupActivityIndicator()
        setupAddButton()
        setupTableView()
        Task {
            await presenter.didLoad()
        }
    }

    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        zeroStateLabel.text = "There are no savings goals. Add a goal using the button above."
        zeroStateLabel.textAlignment = .center
        zeroStateLabel.textColor = .secondaryLabel
        zeroStateLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroStateLabel.lineBreakMode = .byWordWrapping
        zeroStateLabel.numberOfLines = 0
        zeroStateLabel.accessibilityIdentifier = "Zero State Label"
        view.addSubview(zeroStateLabel)

        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(140)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, repeatingSubitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10

        let layout = UICollectionViewCompositionalLayout(section: section)
           collectionView.collectionViewLayout = layout

        collectionView.dataSource = self
        collectionView.register(SavingsCell.self, forCellWithReuseIdentifier: "SavingsCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl // iOS 10+

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            zeroStateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UI.Dimensions.medium),
            zeroStateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UI.Dimensions.medium),
            zeroStateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            zeroStateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didPullToRefresh(_ sender: Any) {
        Task {
            await presenter.didRefresh()
        }
    }

    private func setupAddButton() {
        let addButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "plus"), target: self, action: #selector(addPressed))

        navigationItem.rightBarButtonItem = addButton
    }

    @objc
    func addPressed() {
        Task {
            await presenter.didTapAddButton()
        }
    }
}

extension SavingsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavingsCell", for: indexPath) as? SavingsCell {
            cell.refresh(with: savings[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

}

extension SavingsViewController: Viewable {

    func didUpdate(_ viewState: ViewState) {
        switch viewState {
            case .error(let error):
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay",
                                              style: .default,
                                              handler: nil))
                present(alert,
                        animated: true,
                        completion: nil)
            case .loading:
                activityIndicator.startAnimating()
                break
            case .zeroState:
                zeroStateLabel.sizeToFit()
                zeroStateLabel.isHidden = false
                collectionView.isHidden = true
                activityIndicator.stopAnimating()
                break
            case .loaded(let savings):
                self.savings = savings
                collectionView.reloadData()
                refreshControl.endRefreshing()
                activityIndicator.stopAnimating()
                collectionView.isHidden = false
        }
    }

}
