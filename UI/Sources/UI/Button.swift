import UIKit

public class Button: UIButton {

    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        var buttonConfiguration = UIButton.Configuration.borderedProminent()
        buttonConfiguration.background.backgroundColor = Colours.teal
        buttonConfiguration.titleAlignment = .center
        buttonConfiguration.baseForegroundColor = UIColor.black
        configuration = buttonConfiguration
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            let font = UIFont.preferredFont(forTextStyle: .body)
            let fontPointSize = font.pointSize
            let fontBold = UIFont.systemFont(ofSize: fontPointSize, weight: .bold)
            outgoing.font = UIFontMetrics.default.scaledFont(for: fontBold)
            return outgoing
        }
    }

    public func showActivityIndicator() {
        configuration?.showsActivityIndicator = true
    }

}
