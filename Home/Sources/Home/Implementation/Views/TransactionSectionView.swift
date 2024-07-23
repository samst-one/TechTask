import UIKit
import UI

class TransactionSectionView: UITableViewHeaderFooterView {

    let date = UILabel()
    let totalAmount = UILabel()
    let stackView: UIStackView

    override init(reuseIdentifier: String?) {
        stackView = UIStackView(arrangedSubviews: [date, totalAmount])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .top

        date.font = .preferredFont(forTextStyle: .subheadline)
        date.adjustsFontForContentSizeCategory = true
        date.textColor = .secondaryLabel

        totalAmount.font = .preferredFont(forTextStyle: .subheadline)
        totalAmount.adjustsFontForContentSizeCategory = true
        totalAmount.textColor = .secondaryLabel

        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimensions.medium),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimensions.medium),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimensions.medium),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Dimensions.medium),
        ])

        date.setContentHuggingPriority(.required, for: .horizontal)
        totalAmount.setContentHuggingPriority(.required, for: .horizontal)
        let config = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfiguration = config
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func refresh(with viewModel: TransactionSectionViewModel) {
        date.text = viewModel.date
        totalAmount.text = viewModel.totalAmount
    }
}
