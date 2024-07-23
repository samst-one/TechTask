import UIKit
import UI

protocol Viewable: AnyObject {
    @MainActor
    func didUpdate(_ viewState: ViewState)
}

class HomeViewController: UIViewController {

    private let tableView = UITableView()
    private let presenter: Presenter
    private let headerView = HeaderView()
    private var sections: [TransactionSectionViewModel] = []
    private let datePicker = UIDatePicker()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let datePickerStackView = UIStackView()
    private let zeroStateLabel = UILabel()

    init(presenter: Presenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    
        Task {
            await presenter.didLoad()
        }
        setupTableView()
        setupDatePicker()
        setupActivityIndicator()
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

    @objc func preferredContentSizeChanged(_ notification: Notification) {
        layoutTableViewHeader()
    }

    private func setupDatePicker() {
        datePickerStackView.axis = .horizontal
        datePickerStackView.spacing = 5

        let label = UILabel()
        label.text = "Week Commencing:"
        label.textColor = .secondaryLabel
        datePickerStackView.addArrangedSubview(label)

        datePicker.datePickerMode = .date
        datePicker.maximumDate = .now
        datePickerStackView.addArrangedSubview(datePicker)
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)

        navigationItem.titleView = datePickerStackView
    }

    @objc
    func handleDatePicker() {
        Task {
            await presenter.didSelectDate(date: datePicker.date)
        }
    }

    private func setupTableView() {
        zeroStateLabel.text = "There are no transactions between the selected dates."
        zeroStateLabel.textAlignment = .center
        zeroStateLabel.textColor = .secondaryLabel
        zeroStateLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroStateLabel.lineBreakMode = .byWordWrapping
        zeroStateLabel.numberOfLines = 0
        zeroStateLabel.accessibilityIdentifier = "Zero State Label"
        view.addSubview(zeroStateLabel)

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.tableHeaderView = headerView
        headerView.didTapRoundUp = { [weak self] in
            Task {
                await self?.presenter.didPressRoundUp()
            }
        }
        layoutTableViewHeader()
        tableView.register(TransactionSectionView.self, forHeaderFooterViewReuseIdentifier: "TransactionSectionView")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            zeroStateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UI.Dimensions.medium),
            zeroStateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UI.Dimensions.medium),
            zeroStateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            zeroStateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func layoutTableViewHeader() {
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TransactionSectionView") as? TransactionSectionView else {
            return nil
        }
        view.refresh(with: sections[section])
        return view
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell {
            cell.refresh(with: sections[indexPath.section].cells[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
}

extension HomeViewController: Viewable {

    @MainActor
    func didUpdate(_ viewState: ViewState) {
        switch viewState {
            case .zeroState(let description):
                zeroStateLabel.sizeToFit()
                zeroStateLabel.text = description
                zeroStateLabel.isHidden = false
                tableView.isHidden = true
                activityIndicator.stopAnimating()
            case .loading:
                zeroStateLabel.isHidden = true
                tableView.isHidden = true
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            case .loaded(let viewModel):
                zeroStateLabel.isHidden = true
                tableView.alpha = 0
                tableView.isHidden = false
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.tableView.alpha = 1
                })
                activityIndicator.stopAnimating()
                headerView.update(viewModel.headerViewModel)
                sections = viewModel.sectionViewModels
                tableView.reloadData()
                layoutTableViewHeader()
            case .error(let error):
                zeroStateLabel.isHidden = true
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay",
                                              style: .default,
                                              handler: nil))
                present(alert,
                        animated: true,
                        completion: nil)
                break

        }
    }

}
