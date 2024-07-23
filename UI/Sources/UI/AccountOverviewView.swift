import UIKit

public struct AccountOverviewViewModel {
    let title: String
    let subtitle: String?
    let progress: Float
    let hideProgressBar: Bool
    let totalInAccount: String

    public init(title: String, subtitle: String?, progress: Float, hideProgressBar: Bool, totalInAccount: String) {
        self.title = title
        self.subtitle = subtitle
        self.progress = progress
        self.hideProgressBar = hideProgressBar
        self.totalInAccount = totalInAccount
    }
}

public class AccountOverviewView: UIView {

    private let savingsGoalTitle = UILabel()
    private let savingsGoalTotal = UILabel()
    private let savingsGoalSubtitle = UILabel()
    private let progressBar = UIProgressView()
    private let titleContainerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        set(.dark)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        titleContainerView.clipsToBounds = true
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        savingsGoalTitle.adjustsFontForContentSizeCategory = true
        savingsGoalTitle.font = .preferredFont(forTextStyle: .caption1)
        savingsGoalTitle.translatesAutoresizingMaskIntoConstraints = false
        titleContainerView.addSubview(savingsGoalTitle)
        savingsGoalTitle.setContentHuggingPriority(.required, for: .horizontal)


        savingsGoalTotal.font = .preferredFont(forTextStyle: .title1)
        savingsGoalSubtitle.font = .preferredFont(forTextStyle: .caption2)

        progressBar.progressTintColor = Colours.navy

        let savingsGoalStackView = UIStackView(arrangedSubviews: [titleContainerView,
                                                                  savingsGoalTotal,
                                                                  progressBar,
                                                                  savingsGoalSubtitle])
        savingsGoalStackView.spacing = 10
        savingsGoalStackView.axis = .vertical
        savingsGoalStackView.alignment = .top
        savingsGoalStackView.distribution = .fill
        savingsGoalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(savingsGoalStackView)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = Dimensions.medium
        clipsToBounds = true

        NSLayoutConstraint.activate([
            savingsGoalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Dimensions.medium),
            savingsGoalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.medium),
            savingsGoalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.medium),
            savingsGoalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Dimensions.medium),
        ])

        NSLayoutConstraint.activate([
            savingsGoalTitle.topAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: Dimensions.small),
            savingsGoalTitle.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: -Dimensions.small),
            savingsGoalTitle.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: Dimensions.medium),
            savingsGoalTitle.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -Dimensions.medium),

            progressBar.widthAnchor.constraint(equalTo: savingsGoalStackView.widthAnchor),
        ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        titleContainerView.layer.cornerRadius = titleContainerView.frame.height/2
    }

    public func update(_ viewModel: AccountOverviewViewModel) {
        savingsGoalTitle.text = viewModel.title
        savingsGoalTotal.text = viewModel.totalInAccount
        savingsGoalSubtitle.text = viewModel.subtitle
        progressBar.progress = viewModel.progress
        progressBar.isHidden = viewModel.hideProgressBar
    }

    public func set(_ theme: Theme) {
        switch theme {
            case .light:
                backgroundColor = Colours.teal
                titleContainerView.backgroundColor = UIColor.tertiarySystemFill
                savingsGoalTitle.textColor = .darkText
                savingsGoalTotal.textColor = .darkText
                savingsGoalSubtitle.textColor = .darkText
            case .dark:
                backgroundColor = .secondarySystemBackground
                titleContainerView.backgroundColor = UIColor.tertiarySystemFill
                savingsGoalTitle.textColor = .label
                savingsGoalTotal.textColor = .label
                savingsGoalSubtitle.textColor = .label
        }
    }

}

public enum Theme {
    case light
    case dark
}
