import UIKit
import UI

@MainActor
protocol Viewable: AnyObject {
    func set(_ addButtonEnabled: Bool)
    func keyboardShownForHeight(_ height: CGFloat, animationDuration: Double)
    func keyboardHiddenForHeight(_ height: CGFloat, animationDuration: Double)
    func present(_ error: Error)
}

class AddSavingsGoalViewController: UIViewController {

    private var buttonBottomAnchor: NSLayoutConstraint?
    private var keyboardVisible = false
    private let presenter: Presenter
    private var addButton = Button()

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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false

        title = "Add Savings Goal"
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        constructView()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func constructView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        constraintScrollView()

        let formTitle = UILabel()
        formTitle.text = "Let's begin"

        let formTitleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        let formTitlePointSize = formTitleFont.pointSize
        let formTitleFontBold = UIFont.systemFont(ofSize: formTitlePointSize, weight: .bold)
        formTitle.font = UIFontMetrics.default.scaledFont(for: formTitleFontBold)
        formTitle.adjustsFontForContentSizeCategory = true
        formTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(formTitle)

        NSLayoutConstraint.activate([
            formTitle.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Dimensions.xLarge),
            formTitle.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.xLarge),
            formTitle.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: Dimensions.xLarge),
        ])

        let savingsTitleInput = InputView(title: "What are you saving for?")
        savingsTitleInput.accessibilityIdentifier = "Savings Goal Title"
        savingsTitleInput.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(savingsTitleInput)

        NSLayoutConstraint.activate([
            savingsTitleInput.topAnchor.constraint(equalTo: formTitle.safeAreaLayoutGuide.bottomAnchor, constant: Dimensions.xLarge),
            savingsTitleInput.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.xLarge),
            savingsTitleInput.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.xLarge),
        ])

        let savingsAmountInput = CurrencyInputView(title: "How much do you hope to save? (optional)")
        savingsAmountInput.accessibilityIdentifier = "Savings Goal Value"
        savingsAmountInput.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(savingsAmountInput)

        NSLayoutConstraint.activate([
            savingsAmountInput.topAnchor.constraint(equalTo: savingsTitleInput.safeAreaLayoutGuide.bottomAnchor, constant: Dimensions.xLarge),
            savingsAmountInput.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.xLarge),
            savingsAmountInput.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.xLarge),
        ])

        savingsTitleInput.didEditText = { [weak self] in
            Task {
                await self?.presenter.didUpdateGoal(goal: savingsTitleInput.textValue, value: savingsAmountInput.textValue)
            }
        }

        savingsAmountInput.didEditText = { [weak self] in
            Task {
                await self?.presenter.didUpdateGoal(goal: savingsTitleInput.textValue, value: savingsAmountInput.textValue)
            }
        }

        addButton.setTitle("Add Goal", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.isEnabled = false
        addButton.addAction(UIAction(handler: { [weak self] _ in
            Task {
                await self?.presenter.didTapAddGoal(goal: savingsTitleInput.textValue, value: savingsAmountInput.textValue)
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

    @objc
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        Task {
            await presenter.keyboardWillShow(sizeValue: userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
                                             durationValue: userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey])
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo
        Task {
            await presenter.keyboardWillHide(sizeValue: userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
                                             durationValue: userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey])
        }
    }
}

extension AddSavingsGoalViewController: Viewable {

    func set(_ addButtonEnabled: Bool) {
        addButton.isEnabled = addButtonEnabled
    }

    func keyboardShownForHeight(_ height: CGFloat, animationDuration: Double) {
        buttonBottomAnchor?.constant -= height
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.presenter.keyboardShown()
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
        scrollView.contentInset = contentInsets
    }

    func keyboardHiddenForHeight(_ height: CGFloat, animationDuration: Double) {
        buttonBottomAnchor?.constant += height
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.presenter.keyboardHidden()
        }
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    func present(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .default,
                                      handler: nil))
        present(alert,
                animated: true,
                completion: nil)
    }

}

