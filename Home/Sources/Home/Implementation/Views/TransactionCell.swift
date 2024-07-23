import UIKit
import UI

class TransactionCell: UITableViewCell {

    let image = UIImageView(image: .add)
    let title = UILabel()
    let subtitle = UILabel()
    let price = UILabel()
    let stackView: UIStackView
    let titleSubtitleStackView: UIStackView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        titleSubtitleStackView = UIStackView(arrangedSubviews: [title, subtitle])
        titleSubtitleStackView.axis = .vertical
        titleSubtitleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleSubtitleStackView.distribution = .equalCentering
        titleSubtitleStackView.spacing = Dimensions.small

        stackView = UIStackView(arrangedSubviews: [image, titleSubtitleStackView, price])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = Dimensions.medium
        stackView.alignment = .center

        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .secondarySystemFill

        title.font = UIFont.preferredFont(forTextStyle: .body)
        title.adjustsFontForContentSizeCategory = true

        price.font = UIFont.preferredFont(forTextStyle: .body)
        price.adjustsFontForContentSizeCategory = true

        subtitle.textColor = .secondaryLabel
        subtitle.font = UIFont.preferredFont(forTextStyle: .caption1)
        subtitle.adjustsFontForContentSizeCategory = true

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)

        price.setContentHuggingPriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimensions.medium),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimensions.medium),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimensions.medium),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Dimensions.medium),
            image.heightAnchor.constraint(equalToConstant: Dimensions.medium * 5),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refresh(with transaction: TransactionCellViewModel) {
        image.image = UIImage(systemName: transaction.image)
        image.tintColor = transaction.imageTint
        title.text = transaction.title
        subtitle.text = transaction.subtitle
        price.text = transaction.price
        price.textColor = transaction.priceTint
    }
}
