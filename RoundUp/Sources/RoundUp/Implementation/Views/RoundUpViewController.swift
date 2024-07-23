import UIKit
import UI

@MainActor
protocol Viewable: AnyObject {
    func didUpdate(_ viewState: ViewState)
    func didUpdate(_ savingsGoal: AccountOverviewViewModel)
}

class RoundUpViewController: UIViewController {

    private let zeroStateLabel = UILabel()
    private var buttonBottomAnchor: NSLayoutConstraint?
    private var keyboardVisible = false
    private let presenter: Presenter
    private var addButton = Button()
    private var savingsGoals: [AccountOverviewViewModel] = []
    private let pickerViewTextField = UITextField(frame: .zero)
    private let pickerView = UIPickerView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let savingsGoalView = AccountOverviewView()
    private let roundUpOverviewView = AccountOverviewView()

    init(presenter: Presenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await presenter.didLoad()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false

        title = "Round Up"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupFormView()
        setupActivityIndicator()
        setupZeroState()
    }

    private func setupZeroState() {
        zeroStateLabel.text = "Please add a savings group. This can be done in the 'Savings Groups' screen"
        zeroStateLabel.textAlignment = .center
        zeroStateLabel.textColor = .secondaryLabel
        zeroStateLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroStateLabel.isHidden = true
        zeroStateLabel.lineBreakMode = .byWordWrapping
        zeroStateLabel.numberOfLines = 0
        zeroStateLabel.accessibilityIdentifier = "Zero State Label"
        view.addSubview(zeroStateLabel)

        NSLayoutConstraint.activate([
            zeroStateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UI.Dimensions.medium),
            zeroStateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UI.Dimensions.medium),
            zeroStateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            zeroStateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
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

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupFormView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        constraintScrollView()

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSavingsGoal))
        savingsGoalView.addGestureRecognizer(tap)
        savingsGoalView.set(.light)
        let arrow = UILabel()
        arrow.text = "↓"
        arrow.textColor = .secondaryLabel
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.textAlignment = .center

        savingsGoalView.accessibilityIdentifier = "Savings Goal View"

        let stackView = UIStackView(arrangedSubviews: [roundUpOverviewView, arrow, savingsGoalView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Dimensions.xLarge),
            stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.xLarge),
            stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.xLarge),
        ])

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerViewTextField.inputView = pickerView
        pickerViewTextField.backgroundColor = .red
        pickerViewTextField.inputView = pickerView
        contentView.addSubview(pickerViewTextField)

        addButton.setTitle("Round Up", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addAction(UIAction(handler: { [weak self] _ in
            Task {
                await self?.presenter.didTapRoundUpButton()
            }
        }), for: .touchUpInside)
        view.addSubview(addButton)

        buttonBottomAnchor = addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Dimensions.xLarge)

        if let buttonBottomAnchor = buttonBottomAnchor {
            NSLayoutConstraint.activate([
                addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.xLarge),
                addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.xLarge),
                buttonBottomAnchor,
            ])
        }
    }

    @objc
    func didTapSavingsGoal() {
        pickerViewTextField.becomeFirstResponder()
    }

    func constraintScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])

        let contentViewCenterY = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        contentViewCenterY.priority = .defaultLow

        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentViewCenterY
        ])
    }
}

extension RoundUpViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        savingsGoals.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        savingsGoals[row].title
    }
}

extension RoundUpViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Task {
            await presenter.didSelectSavingsGoal(at: row)
        }
    }
}

extension RoundUpViewController: Viewable {

    func didUpdate(_ viewState: ViewState) {
        switch viewState {
            case .zeroState:
                addButton.isHidden = true
                zeroStateLabel.isHidden = false
                zeroStateLabel.sizeToFit()
                scrollView.isHidden = true
                activityIndicator.stopAnimating()
                break
            case .loading:
                activityIndicator.startAnimating()
                scrollView.isHidden = true
                addButton.isHidden = true
                break
            case .loaded(let viewModel):
                addButton.isHidden = false
                scrollView.isUserInteractionEnabled = true
                activityIndicator.stopAnimating()
                savingsGoals = viewModel.savingsGoals
                pickerView.reloadAllComponents()
                scrollView.isHidden = false
                let selectedSavingsGoal = viewModel.savingsGoals[viewModel.selectedSavingsGoal]
                savingsGoalView.update(UI.AccountOverviewViewModel(title: selectedSavingsGoal.title,
                                                                   subtitle: selectedSavingsGoal.subtitle,
                                                                   progress: selectedSavingsGoal.progress,
                                                                   hideProgressBar: selectedSavingsGoal.hideProgressBar,
                                                                   totalInAccount: selectedSavingsGoal.totalInAccount))
                let roundUpOverview = viewModel.roundUpOverview
                roundUpOverviewView.update(UI.AccountOverviewViewModel(title: roundUpOverview.title,
                                                                       subtitle: roundUpOverview.subtitle,
                                                                       progress: roundUpOverview.progress,
                                                                       hideProgressBar: roundUpOverview.hideProgressBar,
                                                                       totalInAccount: roundUpOverview.totalInAccount))
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
                break
            case .roundUpAdded:
                scrollView.isUserInteractionEnabled = true
                addButton.isEnabled = true
                addButton.configuration?.showsActivityIndicator = false
                addButton.configuration?.showsActivityIndicator = false
                let alert = UIAlertController(title: "Success",
                                              message: "Successfully added round up.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay",
                                              style: .default,
                                              handler: { [weak self] _ in
                    Task {
                        await self?.presenter.didDissmisSuccessPopup()
                    }
                }))
                present(alert,
                        animated: true,
                        completion: nil)
            case .roundUpBeingAdded:
                scrollView.isUserInteractionEnabled = false
                addButton.isEnabled = false
                addButton.configuration?.showsActivityIndicator = true
        }
    }

    func didUpdate(_ savingsGoal: AccountOverviewViewModel) {
        savingsGoalView.update(UI.AccountOverviewViewModel(title: savingsGoal.title,
                                                           subtitle: savingsGoal.subtitle,
                                                           progress: savingsGoal.progress,
                                                           hideProgressBar: savingsGoal.hideProgressBar,
                                                           totalInAccount: savingsGoal.totalInAccount))
    }
}
