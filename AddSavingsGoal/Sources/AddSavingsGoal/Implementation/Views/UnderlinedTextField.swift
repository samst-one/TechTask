import UIKit

class UnderlinedTextField: UITextField {

    private let underlineLayer = CALayer()

    func setupUnderlineLayer() {
        var frame = self.bounds
        frame.origin.y = frame.size.height + 3
        frame.size.height = 1

        underlineLayer.frame = frame
        underlineLayer.backgroundColor = UIColor.secondarySystemFill.cgColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.addSublayer(underlineLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(underlineLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUnderlineLayer()
    }

}
