import UIKit
import UI

class SavingsCell: UICollectionViewCell {

    let accountOverviewView = UI.AccountOverviewView()

    override init(frame: CGRect) {
            super.init(frame: frame)
        contentView.addSubview(accountOverviewView)
        accountOverviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountOverviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimensions.medium),
            accountOverviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimensions.medium),
            accountOverviewView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimensions.medium),
            accountOverviewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Dimensions.medium),
        ])
        isAccessibilityElement = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refresh(with savingGoal: SavingsViewModel) {

        accountOverviewView.update(AccountOverviewViewModel(title: savingGoal.title,
                                                            subtitle: savingGoal.subtitle,
                                                            progress: savingGoal.progress,
                                                            hideProgressBar: savingGoal.hideProgressBar,
                                                            totalInAccount: savingGoal.totalInAccount))
        accountOverviewView.updateConstraints()
        accessibilityLabel = savingGoal.voiceOver
        layoutIfNeeded()

    }
}
