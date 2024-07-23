import UIKit
import UI

class HeaderView: UIView {

    private let accountNameContainerView = UIView()
    private let accountNameLabel = UILabel()
    private let balanceLabel = UILabel()
    private let dateBreakdownLabel = UILabel()
    var didTapRoundUp: (() -> ())?
    private let roundUpButton = Button()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    func update(_ viewModel: HeaderViewModel) {
        balanceLabel.text = viewModel.availableBalance
        dateBreakdownLabel.text = viewModel.dateDetails
        accountNameLabel.text = viewModel.accountName
        roundUpButton.configuration?.subtitle = viewModel.roundUpAmount
        roundUpButton.isEnabled = viewModel.roundUpButtonIsEnabled
        accountNameContainerView.layer.cornerRadius = accountNameContainerView.frame.height / 2
    }

    private func setupLayout() {
        roundUpButton.setTitle("Round Up", for: .normal)
        roundUpButton.addAction(UIAction(handler: { [weak self] _ in
            self?.didTapRoundUp?()
        }), for: .touchUpInside)
        accountNameContainerView.backgroundColor = UIColor.secondarySystemFill
        accountNameContainerView.clipsToBounds = true

        accountNameLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        accountNameLabel.adjustsFontForContentSizeCategory = true
        accountNameLabel.translatesAutoresizingMaskIntoConstraints = false
        accountNameContainerView.addSubview(accountNameLabel)

        let detailStackView = UIStackView()
        detailStackView.axis = .vertical

        dateBreakdownLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateBreakdownLabel.adjustsFontForContentSizeCategory = true
        dateBreakdownLabel.textColor = .secondaryLabel
        dateBreakdownLabel.translatesAutoresizingMaskIntoConstraints = false
        dateBreakdownLabel.textAlignment = .center

        balanceLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        balanceLabel.adjustsFontForContentSizeCategory = true
        balanceLabel.textAlignment = .center
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false

        detailStackView.addArrangedSubview(balanceLabel)
        detailStackView.addArrangedSubview(dateBreakdownLabel)

        let containerStackView = UIStackView(arrangedSubviews: [accountNameContainerView,
                                                                detailStackView,
                                                                roundUpButton])
        containerStackView.axis = .vertical
        containerStackView.spacing = Dimensions.large
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.alignment = .center
        addSubview(containerStackView)

        let containerStackViewTopConstraint = containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.large)
        containerStackViewTopConstraint.priority = .defaultHigh

        let containerStackViewBottomConstraint = containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.large)
        containerStackViewBottomConstraint.priority = .defaultHigh

        let containerStackViewTrailingConstraint = containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        containerStackViewTrailingConstraint.priority = .defaultHigh

        let containerStackViewLeadingConstraint = containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        containerStackViewLeadingConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            containerStackViewTopConstraint,
            containerStackViewBottomConstraint,
            containerStackViewLeadingConstraint,
            containerStackViewTrailingConstraint
        ])

        NSLayoutConstraint.activate([
            accountNameLabel.topAnchor.constraint(equalTo: accountNameContainerView.topAnchor, constant: Dimensions.small),
            accountNameLabel.bottomAnchor.constraint(equalTo: accountNameContainerView.bottomAnchor, constant: -Dimensions.small),
            accountNameLabel.leadingAnchor.constraint(equalTo: accountNameContainerView.leadingAnchor, constant: Dimensions.medium),
            accountNameLabel.trailingAnchor.constraint(equalTo: accountNameContainerView.trailingAnchor, constant: -Dimensions.medium),
        ])
    }
}
